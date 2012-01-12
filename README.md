# bluff

* https://github.com/islandr/bluff

## DESCRIPTION:

A single source of lies for all your testing needs.

## FEATURES/PROBLEMS:

* TODO

## CONTRIBUTING:

Pull requests are welcome!  See the DEVELOPERS section at the bottom of this page for more information.

## OVERVIEW:

My original intentions for bluff are focused on rails/activerecord but I'm open
to other libraries if it doesn't pollute the API.

The goal is to minimize the amount of mocking/faking pollution in your test suits,
and to do so via an API that feels natural to rails/activerecord users.  I favor
a slightly more wordy API for defining bluffs that offers the full power and flexibility
of Ruby over a cute DSL that limits customization.

### MODEL AND DATA BLUFFS

Bluff comes with a small set of predefined data bluffs (see `lib/bluff/bluffs/data_bluffs.rb`) 
but its easy to add your own.

The standard practice is to define your bluffs within spec/bluffs.  If you are
bluffing a model, name the file **_model_\_bluff.rb**.  If you need to bluff custom
data, do so in **data_bluffs.rb**.

A bluff is a bluff, whether it's just a piece of data or a full blown model.  All bluffs
share the same namespace (the root namespace is the *only* namespace) so choose your bluff 
names accordingly.

```
# spec/bluffs/user_bluff.rb
Bluff.for(:user) do |attributes|
  attributes[:name] ||= Bluff.name
  attributes[:email] ||= Bluff.email(attributes[:name])
  
  # return your bluffed instance
  User.new(attributes)
end

# spec/bluffs/data_bluffs.rb
Bluff.for(:name) { Faker::Name.name } # Call via Bluff.name
Bluff.for(:company_name) { Faker::Company.name }
```

#### HELPERS

There is a very tiny DSL built into Bluff to help you out.  Two methods are available:
`insist()` and `default()`.

**insist([:attribute, :attribute, ...])** takes a list of required attributes. If any of those attributes were not
provided an ArgumentError will be thrown.

**default(:attribute, :value)** takes an attribute and a default value. If the attribute was not previously defined
it will be assigned the given value.

Here's an example of how you might put these two little guys to work:

```
Bluff.for(:workspace) do |attributes|
  insist(:account)
  
  default(:name, Bluff.name)

  User.new(attributes).tap do |user|
    # sometimes it's easier to define the values here instead
    user.email = Bluff.email({:name => user.name})
  end
end
```

#### CALLING YOUR BLUFFS

```
User.bluff  # returns an unsaved instance -- could also use Bluff.user
User.bluff! # returns a saved instance -- could also use Bluff.user!
User.bluff({:name => 'Ryan'}) # supply overrides in the attributes hash
```

### METHOD BLUFFS (MOCKS / STUBS)

All objects and classes are given a `bluff()` method, which is
used for bluffing both models and methods.  If given a symbol, the 
`bluff()` method can be used to define method stubs as follows:

```
User.bluff(:find) { |id| :value }
User.bluff(:save) { true }

user = Bluff.mock
user.bluff(:name).as(:value)
```

The mocking abilities of bluff are no more than a thin wrapper around
rspec-mocks.  Calling `Bluff.mock('account')` is identical to calling `double('account')`

## REQUIREMENTS:

* rspec-mocks
* faker

## INSTALL:

* `gem install bluff`
* or simply add bluff to your Gemfile and run `bundle install`

```
group :test do
  gem 'bluff'
end
```

## FURTHER READING:

http://faker.rubyforge.org/

https://www.relishapp.com/rspec/rspec-mocks/
https://www.relishapp.com/rspec/rspec-mocks/docs/method-stubs/stub-on-any-instance-of-a-class
https://www.relishapp.com/rspec/rspec-mocks/docs/outside-rspec/configure-any-test-framework-to-use-rspec-mocks

## DEVELOPERS:

After checking out the source, run:

  $ rake setup

This task will install any missing dependencies and run the tests/specs.

## LICENSE:

(The MIT License)

Copyright (c) 2011 Ryan Mohr (github.com/islandr)

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
