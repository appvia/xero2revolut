#!/usr/bin/ruby

require 'csv'
require 'fileutils'
require 'date'

if ARGV.length > 1
    puts "Usage: payroll.rb <csv_file>"
    exit
end

if ARGV.length == 0
    inputfile = Dir.glob("BAC*.csv").max_by {|f| File.mtime(f)}
    puts "Using latest file: #{inputfile}"
else
    inputfile = ARGV[0]
end

file = File.open("revolut.csv", "w")
csv = CSV.open(inputfile, "r")

# Write the header, as Revolut needs it:
file.write("Name,Recipient type,Account number,Sort code,Recipient bank country,Currency,Amount,Payment reference\n")

month=Date::MONTHNAMES[Date.today.month] 
year=Date.today.year

# Rewrite the PayCircle to Revolut CSV format:
csv.each do |row|
    # Skip the header row
    if ! row.include?("amount")
        amount = row[0].to_i
        amount_withdecimal = amount/100.0
        name = row[1].upcase
        file.write("#{name},Individual,#{row[2]},#{row[3]},GB,GBP,#{amount_withdecimal},Salary #{month} #{year}\n")
    end
end
