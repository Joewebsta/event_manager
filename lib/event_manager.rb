require 'csv'

contents = CSV.open('event_attendees.csv', headers: true, header_converters: :symbol)

def print_csv(contents)
  contents.each do |row|
    name = first_name(row)
    zipcode = zipcode(row)
    puts "#{name} #{zipcode}"
  end
end

def first_name(row)
  row[:first_name]
end

def zipcode(row)
  zipcode = row[:zipcode].nil? ? '00000' : row[:zipcode]
  zipcode_length = zipcode.length

  return zipcode if zipcode_length == 5
  return zipcode.slice(0, 5) if zipcode_length > 5
  return zipcode.rjust(5, '0') if zipcode_length < 5
end

print_csv(contents)
