#!/usr/bin/env ruby

# $: << File.join(File.dirname(__FILE__),'..','lib')

require 'scbi_queue_system'
require 'logger'

require 'running_job_list'
require 'queued_job_list'
require 'done_job_list'

system_log_message="SCBI SQS queue at: #{QUEUED_PATH}"
`logger "#{system_log_message}"`

user=`whoami`
system_log_message="SCBI SQS user: #{user}"
`logger "#{system_log_message}"`


$LOG = Logger.new(LOG_FILE, 10, 1024000)

# $LOG = Logger.new(STDOUT, 10, 1024000)

$LOG.level = Logger::INFO

$LOG.info 'Starting up SQS'

# LOAD CONFIG FILES

def load_config
  
  $LOG.info 'Reading config files'

  if File.exists?(CONFIG_FILE)
    config_txt=File.read(CONFIG_FILE)

    # remove comments
    config_txt_cleaned=config_txt.split("\n").select{|l| !(l=~ /^\s*\#/)}.join("\n")
    # puts config_txt_cleaned
    config=JSON::parse(config_txt_cleaned,:symbolize_names => true)
    
  else
    # default config
    config={}

    config[:polling_time] = 10
    config[:machine_list] = []
    
    cpus=1
    
    if RUBY_PLATFORM.downcase.include?("darwin")
      cpus=`hwprefs -cpu_count`.chomp.to_i
    else
      cpus=`grep processor /proc/cpuinfo |wc -l`.chomp.to_i
    end
    
    machine={:name=>'localhost', :cpus => cpus}
    
    config[:machine_list] << machine
    # config[:sqs_user] = 'dariogf'

    f=File.open(CONFIG_FILE,'w')
    f.puts "# You can add comment lines to this config file"
    
    f.puts JSON::pretty_generate(config)
    f.close
    $LOG.debug "Generating default config. You can modify it by editing #{CONFIG_FILE}"
  end

  $LOG.debug "Config loaded #{config.to_json}"


  # # create machine slots
  config[:machine_list].each do |machine|
    FileUtils.mkdir_p(File.join(RUNNING_PATH,machine[:name]))
    FileUtils.mkdir_p(File.join(SENT_PATH,machine[:name]))
  end
  return config
end

def select_next_jobs(machines,queued,running)
  # select next job for running
  res = {}

  if !queued.jobs.empty?

    # iterate over machines
    machines.each do |machine|

      # find free_cpus
      running_cpus=running.running_cpus_in_machine(machine[:name])
      free_cpus = machine[:cpus]-running_cpus

      $LOG.debug("Free space on #{machine[:name]}: #{free_cpus}")

      # use free cpus
      while (free_cpus > 0) do

          next_job=queued.jobs.find{|job| job[:cpus] <= free_cpus}

          if next_job
            # delete job from queue
            queued.jobs.delete(next_job)

            # discount cpus
            free_cpus -= next_job[:cpus]

            # add job to be run on current machine
            res[machine[:name]]=[] if res[machine[:name]].nil?
            res[machine[:name]] << next_job
          else
            break
          end

        end
      end
    end

    return res
  end

  def update_running_jobs(machines,running)

    machines.each do |machine|

      running_in_machine=running.running_jobs_in_machine(machine[:name])
      if machine[:name].upcase.index('LOCALHOST')
        cmd= machine[:ps_command] || "ps ax -o command"
      else
        ps_cmd=machine[:ps_command] || "ps ax -o command"
        cmd="ssh #{machine[:name]} \"#{ps_cmd}\""
      end
      # puts cmd
      res=`#{cmd}`

      running_in_machine.each do |job|
        sqs_job_file=File.join(RUNNING_PATH,machine[:name],job[:run_script])
        user_job_file=File.join(job[:cwd],job[:run_script])
        if File.exists?(sqs_job_file)

          # if script is not running
          if !res.index(user_job_file)
            # remove it from folder
            File.delete(sqs_job_file)
            FileUtils.mv(File.join(SENT_PATH,machine[:name],job[:run_script]),DONE_PATH)
            $LOG.info("Job finished: #{job[:run_script]}")
          end
        end
      end

      # puts "#{machine[:name]}, #{res}"

    end

  end

  config=load_config
      
  exit_loop=false

  Signal.trap("INT") do
    puts "Terminating SQS manager..."
    puts "Please wait #{config[:polling_time]} seconds..."
    exit_loop=true
  end

  # event loop
  begin
    
    config=load_config
    # clear screen
    # print "\e[2J\e[f"

    # check files
    $LOG.debug "Checking queue and machine status"

    queued=QueuedJobList.new
    running=RunningJobList.new

    # puts queued.to_s
    # puts running.to_s


    update_running_jobs(config[:machine_list],running)

    # puts "#{queued.count} queued jobs"
    # puts "QUEUED:\n#{queued.map{|q| q.to_json}.join("\n")}"

    next_jobs=select_next_jobs(config[:machine_list],queued,running)

    if !next_jobs.empty?
      $LOG.debug("Running next jobs")
      next_jobs.each do |machine,jobs|
        jobs.each do |job|
          QueuedJobList.execute_job(job,machine)
        end
      end
    end

    # queued=QueuedJobList.new
    # running=RunningJobList.new
    #
    # puts queued.stats_header
    # puts queued.to_s
    # puts running.to_s


    sleep config[:polling_time]
  end while !exit_loop
