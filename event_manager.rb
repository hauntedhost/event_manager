# Dependencies
require "csv"
require 'sunlight'

# Class Definition
class EventManager
	INVALID_PHONE_NUMBER = "0000000000"
	INVALID_ZIPCODE = "00000"
	Sunlight::Base.api_key = "d885cdc6f21c49cabcbf326a03c85305"

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

  def rep_lookup
  	20.times do
  		line = @file.readline
  		legislators = Sunlight::Legislator.all_in_zipcode(clean_zipcode(line[:zipcode]))
			names = legislators.map do |leg|
				title = leg.title
				party = leg.party
				first_name = leg.firstname
				first_initial = first_name[0]
				last_name = leg.lastname
				"#{title} #{first_initial}. #{last_name} (#{party})" 
			end			
			puts "#{line[:last_name]}, #{line[:first_name]}, #{line[:zipcode]}, #{names.join(", ")}"
  	end
  end

  def create_form_letters
		replacements = %w(first_name last_name street city state zipcode)
		letter = File.open("form_letter.html", "r").read
		20.times do
			line = @file.readline
			replacements.each do |rep|
				letter.gsub!("##{rep}", line[rep.to_sym].to_s)
			end
			filename = "output/thanks_#{line[:last_name].downcase}_#{line[:first_name].downcase}.html"
			output = File.new(filename, "w")
			output.write(letter)
			output.close
		end		
	end

  def rank_times
    hours = Array.new(24){0}
    @file.each do |line|
      #11/12/08 16:05
      hour = line[:regdate].split[1].split(":")[0]
      hours[hour.to_i] += 1
    end
    hours.each_with_index { |counter, hour| puts "#{hour}\t#{counter}" }
  end

  def day_stats
  	days = Array.new(7){0}
  	day_names = %w(sun mon tue wed thu fri sat)
  	@file.each do |line|
  		date = Date.strptime(line[:regdate].split[0], "%m/%d/%y")
  		days[date.wday] += 1 
  	end
  	days.each_with_index { |counter, day| puts "#{day_names[day].capitalize}\t#{counter}" }
  end
end

# Script
manager = EventManager.new("event_attendees.csv")
#manager.output_data("event_attendees_clean.csv")
#manager.rep_lookup
#manager.create_form_letters
#manager.rank_times
manager.day_stats