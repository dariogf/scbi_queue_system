require 'job_list'

class DoneJobList < JobList
  
  def initialize
    
    super(DONE_PATH)
  end
  
end