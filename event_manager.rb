# Dependencies
require "csv"

# Class Definition
class EventManager
  def initialize
    puts "EventManager Initialized."
    filename = "event_attendees.csv"
    @file = CSV.open(filename, {headers: true, header_converters: :symbol})
  end

  def print_names
  	@file.each do |line|
  		puts "#{line[:first_name]} #{line[:last_name]}"
  	end
  end

  def print_numbers
  	@file.each do |line|
  		number = clean_number(line[:homephone])
  		puts number
  	end
  end

  def clean_number(number)
  	number = number.scan(/\d/).join
  	junk = "0000000000"

  	number = case number.length
  	when 10 then 
  		number
  	when 11
  		number[0] == "1" ? number[1..-1] : junk
  	else
  		junk
  	end
  end

  def clean_zipcode(zip)
  	junk = "00000"

 		zip = case
 		when zip.nil?
 			junk
 		when zip.length < 5
 			"%05d" % zip
 		when zip.length == 5
 			zip
 		else
 			junk
 		end
  end

  def print_zipcodes
  	@file.each do |line|
  		zipcode = clean_zipcode(line[:zipcode])
  		puts zipcode
  	end
  end
end

# Script
manager = EventManager.new
#manager.print_names
#manager.print_numbers
manager.print_zipcodes