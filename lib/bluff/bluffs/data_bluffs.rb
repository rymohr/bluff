require 'faker'

# people
Bluff.for(:name) { Faker::Name.name }
Bluff.for(:username) {|name = nil| (name ||= Bluff.name).parameterize }
Bluff.for(:email) {|name = nil| Faker::Internet.email(name) }

# companies
Bluff.for(:company_name) { Faker::Company.name }

# internet
Bluff.for(:domain) { Faker::Internet.domain_name }

# words
Bluff.for(:words) {|count = 3| puts "bluffing words with count=#{count}"; Faker::Lorem.words(count) }
Bluff.for(:phrase) { Faker::Company.bs }
