#!/usr/bin/env ruby

PING_LOG_FILE = "/mnt/ramdisk/ping.log"
NUM = '([\d\.]*)'

def ping ip
  r = `ping -q -c3 #{ip}`
  m1 = r.match(/ #{NUM}\% packet loss/)
  m2 = r.match(/min\/avg\/max\/(stddev|mdev) \= #{NUM}\/#{NUM}\/#{NUM}\/#{NUM} ms/)
  if m1 and m2
    [:ok, m1[1], m2[2], m2[3], m2[4], m2[5]]
  elsif m1
    [:nok, m1[1]]
  else
    [:ko]
  end
end

File.open(PING_LOG_FILE, 'a') do |f|
  f.print Time.now.strftime('%Y-%m-%d--%H-%M-%S')
  f.print ': '
  f.puts ['192.168.2.1', '8.8.8.8', 'blog.mruby.sh'].map do |h|
    f.print "#{ping(h).inspect}"
  end.join(' - ')
end
