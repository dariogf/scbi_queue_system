class JobList
  
  attr_accessor :jobs
  
  def initialize(folder)
    
    @jobs = list_files(folder)
  end

  def stats_header
      res=['']

      res << "#{'Job name'.ljust(40)}\tCPUs\tStatus"

      return res.join("\n")

  end

  def to_s
    res=[]

    res <<  "="*80
    
    @jobs.each do |job|
      # puts job
      res << "#{job[:name]}\t#{job[:cpus]}\t#{self.class.to_s[0]}"
    end
    
    return res.join("\n")
    
  end
  
  
private

  def parse_job_file(job)
    h={}
    
    h[:file] = job
    text=File.read(job)

    cpus = 1
    cwd=''
    script=''
    run_script=''

    # parse script
    text.each_line do |line|
      if line.upcase =~ /^\s*#\s*CPUS\s*=\s*(\d+)/
        begin
          cpus = $1.to_i
        rescue
          cpus = 1
        end
      end

      if line.upcase =~ /^\s*#\s*CWD\s*=\s*(.+)/
        begin
          # use without upcase for path
          line =~ /^\s*#\s*CWD\s*=\s*(.+)/
          cwd = $1
        rescue
          cwd = ''
        end
      end
      
      if line.upcase =~ /^\s*#\s*SCRIPT\s*=\s*(.+)/
        begin
          # use without upcase for path
          line =~ /^\s*#\s*SCRIPT\s*=\s*(.+)/
          script = $1
        rescue
          script = ''
        end
      end
      
      if line.upcase =~ /^\s*#\s*RUN_SCRIPT\s*=\s*(.+)/
        begin
          # use without upcase for path
          line =~ /^\s*#\s*RUN_SCRIPT\s*=\s*(.+)/
          run_script = $1
        rescue
          run_script = ''
        end
      end
      
      
    end

    h[:name] = File.basename(job)
    h[:cpus] = cpus
    h[:cwd] = cwd
    h[:script] = script
    h[:run_script] = run_script

    return h
  end

  def list_files(folder)
    res =[]
    # puts folder
    Dir.glob(File.join(folder,'*')).entries.each do |job|
      h=parse_job_file(job)
      res << h
    end

    return res
  end
  

  
end