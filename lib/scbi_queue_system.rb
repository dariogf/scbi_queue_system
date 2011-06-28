$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

$:<<File.join(File.dirname(__FILE__), File.basename(__FILE__,File.extname(__FILE__)))

require 'queue_system'
include QueueSystem


require 'fileutils'
require 'json'

# load internal config
INTERNAL_CONFIG_PATH=File.join(File.dirname(__FILE__), File.basename(__FILE__,File.extname(__FILE__)),'internal_config','internal_config.json')

if File.exists?(INTERNAL_CONFIG_PATH)
  config_txt=File.read(INTERNAL_CONFIG_PATH)
  internal_config=JSON::parse(config_txt)
else
  # default config
  internal_config={}
  internal_config['base_path'] = '/drives'
  
  f=File.open(INTERNAL_CONFIG_PATH,'w')
  f.puts JSON::pretty_generate(internal_config)
  f.close  
end

JOBS_PATH=File.join(internal_config['base_path'],'sqs','jobs')

# QUEUED_PATH=File.join(JOBS_PATH,'queued')
# DONE_PATH=File.join(JOBS_PATH,'done')
# RUNNING_PATH=File.join(JOBS_PATH,'running')

CONFIG_PATH=File.join('/drives','sqs','config')

LOGS_PATH=File.join('/drives','sqs','logs')

CONFIG_FILE=File.join(CONFIG_PATH,'config.json')
LOG_FILE=File.join(LOGS_PATH,'sqs.log')


# create paths
# FileUtils.mkdir_p([QUEUED_PATH,DONE_PATH,RUNNING_PATH,CONFIG_PATH,LOGS_PATH])


module ScbiQueueSystem
  VERSION = '0.0.1'
end