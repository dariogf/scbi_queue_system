require 'job_list'

DONE_PATH=File.join(JOBS_PATH,'done')

class DoneJobList < JobList
  
  def initialize
    super(DONE_PATH)
  end
  
end