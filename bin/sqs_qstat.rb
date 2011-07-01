#!/usr/bin/env ruby

$: << File.join(File.dirname(__FILE__),'..','lib')

require 'scbi_queue_system'

bucle=ARGV.shift

# if ARGV.count == 1
#   puts "#{File.basename($0)} submit_script"
#   exit -1
# end

def stat
  queued=QueuedJobList.new
  done=DoneJobList.new
  running=RunningJobList.new

  puts queued.stats_header
  puts queued.to_s
  puts running.to_s
  puts
  puts "Recently DONE jobs:"
  
  puts done.to_s
  
end

if bucle
  begin
    print "\e[2J\e[f"
    stat
    sleep 10
  end while 1
else
  stat
end

