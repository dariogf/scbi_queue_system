require 'job_list'

QUEUED_PATH=File.join(JOBS_PATH,'queued')


class QueuedJobList < JobList
  
  def initialize
    super(QUEUED_PATH)

  end
  
end