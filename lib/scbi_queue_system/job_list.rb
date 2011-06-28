class JobList
  
  
  def initialize(folder)
    
    @jobs = list_files(folder)
  end
  
  
  def list_files(folder)
    res =[]
    puts folder
    Dir.glob(File.join(folder,'*')).entries.each do |job|
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

      res << h
    end

    return res
  end
  
  def to_s
    res=['']
    
    res<< "#{'Job name'.ljust(40)}\tCPUs\tStatus"
    res<<  "="*80
    @jobs.each do |job|
      # puts job
      res<< "#{job[:name]}\t#{job[:cpus]}\t#{self.class.to_s[0]}"
    end
    
    return res.join("\n")
    
  end
  
  
end