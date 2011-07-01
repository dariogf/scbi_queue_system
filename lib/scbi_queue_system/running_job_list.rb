require 'job_list'

class RunningJobList < JobList

  def initialize
    super(RUNNING_PATH)
  end


  def running_jobs_in_machine(machine)
    return list_machine_files(RUNNING_PATH,machine)
  end

  def running_cpus_in_machine(machine)
    $LOG.debug(machine)
    res=0

    running_jobs_in_machine(machine).each do |job|
      res+=job[:cpus]
    end

    return res
  end

  def to_s
    res=[]

    @jobs.each do |machine,jobs|
      # puts job
      jobs.each do |job|
        res<< "#{job[:name]}\t#{job[:cpus]}\tRUNNING\t #{machine}"
      end
    end

    return res.join("\n")

  end

  private

    def list_machine_files(folder, machine_id)
      res = []
      Dir.glob(File.join(folder,machine_id,'*')).entries.each do |job|

        h=parse_job_file(job)
        
        res << h
      end

      return res
    end

    # process currently running files
    def list_files(folder)
      res = {}

      Dir.glob(File.join(folder,'*')).entries.each do |machine|
        machine_id=File.basename(machine)

        res[machine_id]= list_machine_files(folder,machine_id)
      end

      return res
    end


end
