require 'faker'

# people
Bluff.for(:name) { Faker::Name.name }
Bluff.for(:username) { (params[:name] ||= Bluff.name).parameterize }
Bluff.for(:email) { Faker::Internet.email( params[:name] || Bluff.name ) }

# companies
Bluff.for(:company_name) { Faker::Company.name }

# internet
Bluff.for(:domain) { Faker::Internet.domain_name }

# words
Bluff.for(:words) { Faker::Lorem.words(params[:count] || 3) }
Bluff.for(:phrase) { Faker::Company.bs }
