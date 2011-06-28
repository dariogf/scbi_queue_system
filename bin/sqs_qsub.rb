#!/usr/bin/env ruby

$: << File.join(File.dirname(__FILE__),'..','lib')

require 'scbi_queue_system'

if ARGV.count != 1
  puts "#{File.basename($0)} submit_script"
  exit -1
end
submit_script=ARGV[0]

if !File.exists?(submit_script)
  puts "File #{submit_script} doesn't exists"
  exit -1
end

t=Time.now
filename = ("%04d%02d%02d-%02d%02d%02d-%07d" % [t.year,t.month,t.day,t.hour,t.min,t.sec,t.usec])

filename += ('_' + File.basename(submit_script))

# copy file to queued
FileUtils.cp(submit_script,File.join(QUEUED_PATH,filename))
puts "File submitted"