require 'csv'
require 'google/apis/civicinfo_v2'
require 'erb'

def first_name(row)
  row[:first_name]
end

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, '0')[0..4]
end

def clean_telephone(telephone)
  phone_num = telephone.gsub(/[^\d]/, '')

  if phone_num.length < 10 || phone_num.length > 11
    phone_num = ''
  elsif phone_num.length == 11 && phone_num.start_with?('1')
    phone_num = phone_num[1..11]
  end

  puts phone_num.empty? ? '' : phone_num.insert(7, '-').insert(3, '-')
end

def target_registration_time(contents)
  hours = contents.map do |row|
    row[:reg_date].split(' ')[1].split(':')[0].to_i
  end.sort

  hour_count = hours.each_with_object({}) do |hour, hash|
    hash[hour] ? hash[hour] += 1 : hash[hour] = 1
  end

  pp hour_count

  # date = date_time.split(' ')[0]
  # year = date.split('/')[2].prepend('20').to_i
  # month = date.split('/')[0].to_i
  # day = date.split('/')[1].to_i

  # time = date_time.split(' ')[1]
  # hour = time.split(':')[0].to_i
  # min = time.split(':')[1].to_i

  # DateTime.new(year, month, day, hour, min)
end

def legislators_by_zipcode(zipcode)
  civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
  civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'

  begin
    civic_info.representative_info_by_address(
      address: zipcode,
      levels: 'country',
      roles: %w[legislatorUpperBody legislatorLowerBody]
    ).officials
  rescue StandardError
    'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
  end
end

def save_thank_you_letter(id, form_letter)
  Dir.mkdir('output') unless Dir.exist? 'output'
  filename = "output/thanks_#{id}.html"

  File.open(filename, 'w') do |file|
    file.puts form_letter
  end
end

def create_personal_letter
  contents = CSV.open('event_attendees.csv', headers: true, header_converters: :symbol)
  template_letter = File.read 'form_letter.erb'
  erb_template = ERB.new template_letter

  target_registration_time(contents)

  contents.each do |row|
    # clean_telephone(row[:home_phone])
    # id = row[0]
    # name = row[:first_name]
    # zipcode = clean_zipcode(row[:zipcode])
    # legislators = legislators_by_zipcode(zipcode)
    # form_letter = erb_template.result(binding)
    # save_thank_you_letter(id, form_letter)
  end
end

create_personal_letter
