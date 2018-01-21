#!/usr/bin/env ruby

require 'webrick'

include WEBrick

s = HTTPServer.new(Port: 80, DocumentRoot: "/mnt/ramdisk")

trap("INT") {s.shutdown}
s.start
