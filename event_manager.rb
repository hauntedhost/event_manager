# Dependencies
require "csv"

# Class Definition
class EventManager

	INVALID_PHONE_NUMBER = "0000000000"
	INVALID_ZIPCODE = "00000"

  def initialize(filename)
    puts "EventManager Initialized."
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

  	number = case number.length
  	when 10 then 
  		number
  	when 11
  		number[0] == "1" ? number[1..-1] : INVALID_PHONE_NUMBER
  	else
  		INVALID_PHONE_NUMBER
  	end
  end

  def clean_zipcode(zip)
 		zip = case
 		when zip.nil?
 			INVALID_ZIPCODE
 		when zip.length < 5
 			"%05d" % zip
 		when zip.length == 5
 			zip
 		else
 			INVALID_ZIPCODE
 		end
  end

  def print_zipcodes
  	@file.each do |line|
  		zipcode = clean_zipcode(line[:zipcode])
  		puts zipcode
  	end
  end

  def output_data(filename)
  	output = CSV.open(filename, "w")
  	@file.each do |line|
			line[:homephone] = clean_number(line[:homephone])
			line[:zipcode] = clean_zipcode(line[:zipcode])
  		@file.lineno == 2 ? output << line.headers : output << line
  	end
  end
end

# Script
manager = EventManager.new("event_attendees.csv")
manager.output_data("event_attendees_clean.csv")
