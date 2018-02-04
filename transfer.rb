#!/usr/bin/env ruby

RSYNC = '/usr/bin/rsync'
RSYNC_ARGS = '-e "ssh -i /home/dabo/.ssh/id_rsa" --remove-source-files -r'
SENSOR_DIR = '/mnt/ramdisk'
SERVER_ADDR = 'dabo@172.16.3.1'
SERVER_DIR = '/mnt/storage1'
HOSTNAME = `hostname`.strip

def rsync_it
  `#{RSYNC} #{RSYNC_ARGS} #{SENSOR_DIR}/* #{SERVER_ADDR}:#{SERVER_DIR}/#{HOSTNAME}/`
end

def convert_log_files
  dir = "#{SERVER_DIR}/#{HOSTNAME}"
  ts = Time.now.strftime "%Y%m%d%H%M%S"
  `ssh -i /home/dabo/.ssh/id_rsa #{SERVER_ADDR} "mv #{dir}/ping.log #{dir}/ping_#{ts}.log"`
end

rsync_it
convert_log_files
