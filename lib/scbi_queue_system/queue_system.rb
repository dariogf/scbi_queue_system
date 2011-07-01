module QueueSystem


  # def list_files(folder)
  #   res =[]
  # 
  #   Dir.glob(File.join(folder,'*')).entries.each do |job|
  #     h={}
  #     h[:file] = job
  #     text=File.read(job)
  # 
  #     cpus = 1
  # 
  #     # parse script
  #     text.each_line do |line|
  #       if line =~ /^\s*#\s*CPUS=(\d+)/
  #         begin
  #           cpus = $1.to_i
  #         rescue
  #           cpus = 1
  #         end
  #       end
  #     end
  # 
  #     h[:name] = File.basename(job)
  #     h[:cpus] = cpus
  # 
  #     res << h
  #   end
  # 
  # 
  #   return res
  # end
  # 
  # def running_files
  #   res = {}
  # 
  #   Dir.glob(File.join(RUNNING_PATH,'*')).entries.each do |machine|
  #     machine_id=File.basename(machine)
  #     res[machine_id]=[]
  # 
  #     Dir.glob(File.join(machine,'*')).entries.each do |job|
  # 
  #       h={}
  #       h[:file] = job
  #       text=File.read(job)
  # 
  #       cpus = 1
  # 
  #       # parse script
  #       text.each_line do |line|
  #         if line =~ /^\s*#\s*CPUS=(\d+)/
  #           begin
  #             cpus = $1.to_i
  #           rescue
  #             cpus = 1
  #           end
  #         end
  #       end
  # 
  #       h[:name] = File.basename(job)
  #       h[:cpus] = cpus
  # 
  #       res[machine_id] << h
  #     end
  #   end
  # 
  #   return res
  # end
  # 


  # def print_stat
  # 
  #   queued=QueuedJobList.new
  #   done=DoneJobList.new
  #   running=RunningJobList.new
  # 
  #   puts queued.to_s
  #   puts done.to_s
  #   puts running.to_s
  # 
  # end

end
