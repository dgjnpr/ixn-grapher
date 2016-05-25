#!/usr/bin/env ruby
require 'gruff'
require 'find'
require 'csv'

# currently you need to have your files in directorys that are the test name one level deep from the ./Reports dir
# will fix this but if you have multiple subdirs it will grab the tests and add them overtop of your pretty graph in the png file

def graphme(title:, filename:, data:)
  g = Gruff::Bar.new(800) # we will want to size this properly for our word doc
  g.theme = {
    colors: ['green'],
    marker_color: '#dddddd',
    font_color: 'white',
    background_colors: 'black'
  }

  g.title = title
  g.marker_count = 6
  g.hide_legend = true
  g.data 'data', data

  g.write(filename)
end

%w(/usr/app/input /usr/app/output).each do |dir|
  unless Dir.exists?(dir)
    end_path = dir.split('/').last
    puts "please mount #{dir} (e.g. -v $PWD/#{end_path}:#{dir})"
    exit
  end
end

if Dir['/usr/app/input/*'].empty?
  puts 'there are no csv files to process'
  exit
end

Find.find('/usr/app/input').each do |file|
  next if file =~ /\._/
  next unless file =~ /.*\.csv$/

  mcast_loss = []
  unicast_loss = []

  CSV.foreach(file, headers: true) do |row|
    if row['Traffic Item'].downcase =~ /multicast/
      mcast_loss << (row['Packet Loss Duration (ms)']).to_f
    else
      unicast_loss << (row['Packet Loss Duration (ms)']).to_f
    end
  end

  basename = File.dirname(file).split('/').last
  filename = "/usr/app/output/#{basename}"

  puts "===== Graphing #{File.dirname(file).split('/').last} ======"
  puts "Multicast Loss: #{mcast_loss.max}"
  puts "Unicast Loss: #{unicast_loss.max}"
  puts "\n"
  graphme(title: 'Multicast Packet Loss Duration (ms)', filename: "#{filename}_mcastloss.png", data: mcast_loss)
  graphme(title: 'Unicast Packet Loss Duration (ms)', filename: "#{filename}_unicastloss.png", data: unicast_loss)
end
