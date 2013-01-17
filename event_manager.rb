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
  	junk = "0000000000"
  	number = number.scan(/\d/).join

  	number = case number.length
  	when 10 then 
  		number
  	when 11
  		number[0] == "1" ? number[1..-1] : junk
  	else
  		junk
  	end
  end

end

# Script
manager = EventManager.new
#manager.print_names
manager.print_numbers