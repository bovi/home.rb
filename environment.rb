#!/usr/bin/env ruby

ENVIRONMENT_DIR = "/mnt/ramdisk/environment"

def write_value d, k, v
  unless v.nil?
    File.open("#{File.join(d)}/#{k}", 'a') do |f|
      f.print v
    end
  end
end

def track_environment
  unless File.exist? ENVIRONMENT_DIR
    puts "sudo mkdir -v #{ENVIRONMENT_DIR}"
    `sudo mkdir -v #{ENVIRONMENT_DIR}`
  end

  d = [ENVIRONMENT_DIR]
  f = Time.new.strftime("%Y,%m,%d,%H,%M,%S").split(',')
  f.each do |i|
    d << i
    _d = File.join(d)
    unless File.exist?(_d)
      puts "sudo mkdir -v #{_d}"
      `sudo mkdir -v #{_d}`
    end
  end

  r = `sudo dht_sensor`
  m = r.match /Temperature: (.*?\..*?) C Humidity: (.*?\..*?)%/

  write_value d, 't', m[1]
  write_value d, 'h', m[2]
end

track_environment
