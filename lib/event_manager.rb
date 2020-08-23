require 'csv'

contents = CSV.open('event_attendees.csv', headers: true, header_converters: :symbol)

def print_csv(contents)
  contents.each do |row|
    name = row[:first_name]
    zipcode = clean_zipcode(row[:zipcode])
    puts "#{name} #{zipcode}"
  end
end

def first_name(row)
  row[:first_name]
end

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, '0')[0..4]
end

print_csv(contents)
