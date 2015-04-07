#!/usr/bin/env ruby
 
# from the command line run:
# ruby ./find_hotspots.rb FILE_NAME THRESHOLD
 
class Array
def to_ranges
compact.sort.uniq.inject([]) do |r,x|
r.empty? || r.last.last.succ != x ? r << (x..x) : r[0..-2] << (r.last.first..x)
end
end
end
 
# read arguments from the command line
data_file = ARGV[0]
threshold = ARGV[1].to_i
 
# initiate a dictionary
aggregations = {}
 
# go through line of the file and provide the line number
File.readlines(data_file).each_with_index do |line, row_number|
next if row_number == 0 # skip the first row
# split the string, by spaces, into an array
columns = line.split /\s+/
 
# create a dictionary entry and add the 6th column's value to it
aggregations[row_number] = columns[5]
end
 
# get line numbers and their aggregation column
grouped = aggregations.group_by do |line_number, aggr_value|
aggr_value.to_f > threshold
end
 
# Grab just the line numbers from an array that looks like [[ROW, aggr], ...] == [ROW, ...]
hotspots = grouped[true].map do |group|
group[0]
end

puts data_file 
puts hotspots.to_ranges
