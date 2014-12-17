require "date"
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Contact.create(fullname: "Matthew Kilan",email: "matthew.kilan@gmail.com",phone: "790-680-882",
    facebook: "https://www.facebook.com/mateusz.kilan",twitter: "https://twitter.com/MateuszKilan1",github: "https://github.com/BobcatMK")

def create_records_for_calendar
    year = 2014
    month = 1

    while year <= 2030 do
        while month <= 12 do
            nr_of_days_in_month = Date.new(year,month,-1).day
            day = 1
            nr_of_days_in_month.times do
                Calendar.create(year: year,month: month,day: day)
                day += 1
            end
            month += 1
        end
        year += 1
        month = 1
    end

end

create_records_for_calendar