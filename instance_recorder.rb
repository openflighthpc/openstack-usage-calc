#!/usr/bin/env ruby

require 'yaml'
require 'json'
require 'date'
require 'time'

# Import yaml as hash
project = ARGV[0]
cmd_out = `bash usage.sh #{project}`
data = YAML.load(cmd_out)

time = Time.new
today = time.strftime("%Y-%m-%d")
daily_usage = {}
daily_usage.default_proc = proc { '' } # This allows for += to a key that doesn't exist

# Node uptime/usage calculation
data.each do |node, data|
  all_datetimes = data.keys

  index = 1
  all_datetimes.each do |dt|
    # Get hash of date info
    info = data[dt] 
    event = info['event']

    # Use current time for Next Date (nd) if this is the last item in the list
    if dt == data.keys.last
      nd = Time.now
      nd_info = {'event' => "now", "date" => nd.strftime("%Y-%m-%d"), "time" => nd.strftime("%T.%L")}
    else
      # Get the next date from the hash
      nd = all_datetimes[index]
      nd_info = data[all_datetimes[index]]
    end
    nd_event = "#{nd_info['event']} (#{nd})"
  
    # Identify whether calculating uptime or downtime
    case info['event']
    when "create", "start"
      state = 'up'
    when "stop"
      state = 'down'
      #puts 'skipping downtime calcs'
      index +=1
      next
    end

    # Work it out for days
    day = info['date']

    while day != nd_info['date'] do
        unless daily_usage.key?(day)
          daily_usage[day] = {}
        end

        unless daily_usage[day].key?(node)
          daily_usage[day][node] = {"usage" => 0, "type" => info['type'], "usage_type" => info['usage_type'], "tags" => info['tags']}
        end
      #puts "#{day} not #{nd_info['date']}"
      # Calculate diff between start event and end of day
      eod = Time.parse(day + "-23:59:59")
      #puts "FOR DAY: #{day} (#{dt} to #{eod}): #{eod - dt}"
      daily_usage[day][node]['usage'] += (eod - dt) / 3600
      day = (Date.parse(day) + 1).strftime("%Y-%m-%d")
      dt = Time.parse(day + "-00:00:00")
    end

    unless daily_usage.key?(day)
      daily_usage[day] = {}
    end

    unless daily_usage[day].key?(node)
      daily_usage[day][node] = {"usage" => 0, "type" => info['type'], "usage_type" => info['usage_type'], "tags" => info['tags']}
    end

    if day == nd_info['date'] 
      #puts "FOR DAY: #{day} (#{dt} to #{nd}): #{nd - dt}"
      daily_usage[day][node]['usage'] += (nd - dt) / 3600
    end

    index += 1
  end
end

# Disk Usage
nodedisks_out = `bash disk_usage.sh #{project}`
nodedisks = YAML.load(nodedisks_out)

nodedisks.each do |node, data|
  data.each do |date, info|
    today = Time.now.strftime("%Y-%m-%d")
    day = info['date'].to_s
    diskkey = "#{node}volume#{info['id']}"
    while day != today do 
      #daily_usage[day][diskkey.to_s] = {"id" => node, "usage" => info["usage"], "type" => info["type"], "usage_type" => info["usage_type"], "tags" => info["tags"]}
      daily_usage[day][diskkey] = info
      daily_usage[day][diskkey]['node'] = node
      day = (Date.parse(day) + 1).strftime("%Y-%m-%d")
    end
    daily_usage[day][diskkey] = info
    daily_usage[day][diskkey]['node'] = node
  end
end

# Return the info
puts daily_usage.to_json

