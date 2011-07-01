require 'job_list'


class QueuedJobList < JobList

  def initialize

    super(QUEUED_PATH)

  end

  def self.execute_job(job,machine)

    $LOG.info("Sending job #{job[:name]} to #{machine}")

    job_path=File.join(QUEUED_PATH,job[:name])

    machine_path = File.join(SENT_PATH,machine)

    FileUtils.cp(job_path , File.join(RUNNING_PATH,machine))
    FileUtils.mv(job_path , machine_path)

    # launch_cmd="ssh #{machine} \"bash #{File.join(machine_path,job[:name])}\""


    output_file=File.join(job[:cwd],job[:name]+'.out')
    error_file=File.join(job[:cwd],job[:name]+'.error')

    # output_file=File.join('/tmp',job[:name]+'.out')
    # error_file=File.join('/tmp',job[:name]+'.error')
    copy_cmd = "scp #{File.join(machine_path,job[:name])} #{machine}:#{job[:cwd]}"
    
    if system(copy_cmd)
      # launch_cmd = "ssh #{machine} \"nohup bash < #{job[:script]} > #{output_file} 2> #{error_file} & \""
      script_on_machine = File.join(job[:cwd],job[:name])
      launch_cmd = "ssh #{machine} \"nohup #{script_on_machine} </dev/null > #{output_file} 2> #{error_file} &\""
      $LOG.info("Launch cmd: #{launch_cmd}")
      if system(launch_cmd)
        $LOG.info "LAUNCH DONE"
      else
        $LOG.error "LAUNCH FAILED: #{launch_cmd}"
      end
    else
      $LOG.error "SCP FAILED: #{copy_cmd}"
    end



  end

end
