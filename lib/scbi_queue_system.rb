$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

$:<<File.join(File.dirname(__FILE__), File.basename(__FILE__,File.extname(__FILE__)))


require 'fileutils'
require 'json'

# load internal config
INTERNAL_CONFIG_PATH=File.join(File.dirname(__FILE__), File.basename(__FILE__,File.extname(__FILE__)),'internal_config','internal_config.json')

if File.exists?(INTERNAL_CONFIG_PATH)
  config_txt=File.read(INTERNAL_CONFIG_PATH)
  internal_config=JSON::parse(config_txt, :symbolize_names => true)
  if ENV['SQS_BASE_PATH']
    internal_config[:base_path] = ENV['SQS_BASE_PATH']
  end
else
  # default config
  internal_config={}
  internal_config[:base_path] = ENV['SQS_BASE_PATH'] || '~/.sqs'
  
  f=File.open(INTERNAL_CONFIG_PATH,'w')
  f.puts JSON::pretty_generate(internal_config)
  f.close
end

JOBS_PATH=File.join(internal_config[:base_path],'sqs','jobs')

CONFIG_PATH=File.join(internal_config[:base_path],'sqs','config')

LOGS_PATH=File.join(internal_config[:base_path],'sqs','logs')

CONFIG_FILE=File.join(CONFIG_PATH,'config.json')

LOG_FILE=ENV['SQS_LOG_PATH'] || File.join(LOGS_PATH,'sqs.log')

# create paths
FileUtils.mkdir_p([CONFIG_PATH,LOGS_PATH])

QUEUED_PATH=ENV['SQS_QUEUED_PATH'] || File.join(JOBS_PATH,'queued')
DONE_PATH=File.join(JOBS_PATH,'done')
RUNNING_PATH=File.join(JOBS_PATH,'running')
SENT_PATH=File.join(JOBS_PATH,'sent')

# create paths
FileUtils.mkdir_p([QUEUED_PATH,DONE_PATH,SENT_PATH,RUNNING_PATH])

require 'running_job_list'
require 'queued_job_list'
require 'done_job_list'


module ScbiQueueSystem
   VERSION = '0.0.2'
end
