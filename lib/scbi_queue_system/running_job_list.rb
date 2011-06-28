require 'job_list'

RUNNING_PATH=File.join(JOBS_PATH,'running')


class RunningJobList < JobList
  
  def initialize
    super(RUNNING_PATH)
  end

  # process currently running files
  def list_files(folder)
    res = {}

    Dir.glob(File.join(folder,'*')).entries.each do |machine|
      machine_id=File.basename(machine)
      res[machine_id]=[]

      Dir.glob(File.join(machine,'*')).entries.each do |job|

        h={}
        h[:file] = job
        text=File.read(job)

        cpus = 1

        # parse script
        text.each_line do |line|
          if line =~ /^\s*#\s*CPUS=(\d+)/
            begin
              cpus = $1.to_i
            rescue
              cpus = 1
            end
          end
        end

        h[:name] = File.basename(job)
        h[:cpus] = cpus

        res[machine_id] << h
      end
    end

    return res
  end
  
  def to_s
    res=['']
    
    res<< "#{'Job name'.ljust(40)}\tCPUs\tStatus"
    res<<  "="*80
    @jobs.each do |machine,jobs|
      # puts job
      jobs.each do |job|
              res<< "#{job[:name]}\t#{job[:cpus]}\tRUNNING\t #{machine}"
      end
    end
    
    return res.join("\n")
    
  end
  
end