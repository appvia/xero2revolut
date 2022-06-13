#!/usr/bin/ruby

require 'csv'
require 'fileutils'

if ARGV.length > 1
    puts "Usage: ruby run.rb <csv_file>"
    exit
end

if ARGV.length == 0
    inputfile = Dir.glob("20*.csv").max_by {|f| File.mtime(f)}
    puts "Using latest file: #{inputfile}"
else
    inputfile = ARGV[0]
end

file = File.open("revolut.csv", "w")
csv = CSV.open(inputfile, "r")

# Write the header, as Revolut needs it:
file.write("Name,Recipient type,Account number,Sort code,Recipient bank country,Currency,Amount,Payment reference\n")

# Xero CSV format:
#Amount, Sortcode+account number, Name,,Payment reference

# Rewrite the Xero CSV format to Revolut CSV format:
csv.each do |row|
    file.write("#{row[2]},Company,#{row[1][6..13]},#{row[1][0..5]},GB,GBP,#{row[0]},#{row[4]}\n")
end
