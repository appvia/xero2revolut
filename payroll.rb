#!/usr/bin/ruby
require 'csv'
require 'fileutils'
require 'date'

if ARGV.length > 1
    puts "Usage: payroll.rb <csv_file>"
    exit
end

if ARGV.length == 0
    inputfile = Dir.glob("PayRun*.txt").max_by {|f| File.mtime(f)}
    puts "Using latest file: #{inputfile}"
else
    inputfile = ARGV[0]
end

file = File.open("revolut.csv", "w")
inp = File.open(inputfile, "r")

# Write the header, as Revolut needs it:
file.write("Name,Recipient type,Account number,Sort code,Recipient bank country,Currency,Amount,Payment reference\n")

top = 0
bottom = CSV.open(inputfile, "r").readlines.length
month=Date::MONTHNAMES[Date.today.month] 
year=Date.today.year

# Rewrite the Xero CSV format to Revolut CSV format:
inp.each do |line|
    # Skipping first 4 and last 4 lines
    if top > 3 && top < bottom-4

        sortcode=line[0..5]
        account=line[6..13]
        amount1=line[38..43]
        amount2=line[44..45]
        name=line[82..-1].chop.strip

        file.write("#{name},Individual,#{account},#{sortcode},GB,GBP,#{amount1}.#{amount2},Salary #{month} #{year}\n")
    end
    top +=1
end

