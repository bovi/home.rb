#!/usr/bin/env ruby

PHOTO_DIR = "/mnt/ramdisk/photos"
MAX_PHOTOS = 70

def cleanup_photos
  p = Dir.entries(PHOTO_DIR).select {|i| i =~ /\.jpg$/ }.sort
  cnt = p.size - (MAX_PHOTOS - 1)
  if cnt > 0
    p_del = p.shift cnt
    p_del.each do |i|
      `sudo rm #{PHOTO_DIR}/#{i}`
    end
  end
end

def take_photo
  unless File.exist? PHOTO_DIR
    `sudo mkdir -v #{PHOTO_DIR}`
  end

  cleanup_photos

  t = Time.now.strftime('%Y-%m-%d--%H-%M-%S')
  r = `sudo /usr/bin/raspistill -v -o "#{PHOTO_DIR}/#{t}-#{rand(10000)}.jpg"`
  # was it successfull?
  r.match(/Close down completed, all components disconnected, disabled and destroyed/) != nil
end

take_photo
