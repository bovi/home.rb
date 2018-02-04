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

  begin
    # get humidity and temperature
    r = `sudo dht_sensor`
    m = r.match /Temperature: (.*?\..*?) C Humidity: (.*?\..*?)%/
    temp = m[1]
    humi = m[2]

    write_value d, 't', temp
    write_value d, 'h', humi
  rescue
    # error while reading temperature and humidity
  end

  begin
    # get system information
    r = `df -h|grep /mnt/`
    r = r.split
    disk = r.split[-2]

    write_value d, 'd', disk
  rescue
    # error while reading free disk space
  end

  begin
    # get memory information
    r = `cat /proc/meminfo|grep MemAvailable`
    r = r.split
    memory = r.split[2]

    write_value d, 'm', memory
  rescue
    # error while reading memory
  end

  begin
    # get wlan signal
    r = `iw dev wlan0 station dump|grep signal`
    r = r.split
    wlan = r.split[2]

    write_value d, 'w', wlan
  rescue
    # error while reading memory
  end
end

track_environment
