#!/usr/bin/env ruby

$: << File.join(File.dirname(__FILE__),'..','lib')

require 'scbi_queue_system'
require 'logger'

require 'running_job_list'
require 'queued_job_list'
require 'done_job_list'


# $LOG = Logger.new(LOG_FILE, 10, 1024000)
$LOG = Logger.new(STDOUT, 10, 1024000)

$LOG.info 'Starting up SQS'

# LOAD CONFIG FILES

$LOG.info 'Reading config files'

if File.exists?(CONFIG_FILE)
  config_txt=File.read(CONFIG_FILE)
  config=JSON::parse(config_txt)
  $LOG.info 'Config loaded'
  puts config.to_json
else
  # default config
  config={}
  
  config['polling_time'] = 10
  config['machine_list'] = []
  # config[:sqs_user] = 'dariogf'
  
  f=File.open(CONFIG_FILE,'w')
  f.puts JSON::pretty_generate(config)
  f.close
end


# # create machine slots
# config['machine_list'].each do |machine|
#   FileUtils.mkdir_p(File.join(RUNNING_PATH,machine['name']))
# end


def check_free_slots(machines,queued,running)
  machines.each do |machine|
    machine['name']
    running.each do
    end
  end
end



# event loop
begin 
  
  # check files
  $LOG.debug "Checking files"
  
  queued=QueuedJobList.new
  # done=list_files(DONE_PATH)
  running=RunningJobList.new
  
  puts queued.to_s
  puts running.to_s

  # puts "#{queued.count} queued jobs"
  # puts "QUEUED:\n#{queued.map{|q| q.to_json}.join("\n")}"
  
  # check_free_slots(config['machine_list'],queued,running)
  
  
  # config['machine_list'].each do |machine|
  #   
  #   cmd="ssh #{machine} ps aux |grep dariogf"
  #   
  #   res=system(cmd)
  #   puts res
  #   
  # end
  
  
  sleep config['polling_time']
end while 1