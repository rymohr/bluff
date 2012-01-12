# people
Bluff.for(:name) { Faker::Name.name }
Bluff.for(:email) {|name| Faker::Internet.email(name) }
Bluff.for(:username) {|name| Faker::Internet.user_name(name) }

# companies
Bluff.for(:company_name) { Faker::Company.name }

# internet
Bluff.for(:domain) { Faker::Internet.domain_name }