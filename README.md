# Pets Play

## Description

Users are able to add a complete profile for their pets, in an effort to find other similar pets within a certain distance to arrange for pet socials. The application should also provide information on nearby pet stores, veterinarians and trainers.

## Other Future Considerations

- A chat service for breed specific questions.
- Online chatting service.
- A chatting service that allows for groups.
- An event planning service to arrange gatherings of pets, with an invitation service.

## Problem to Solve

Providing users with one place to find people with similar interests and pets, pet provisions, veterinarians, trainers and information.

## Minimum Viable Product

Have a API only application

- allowing users to create a profile, edit their profile, log in and log out.
- returning data on all registered users.
- allowing a user to save preferred user accounts.

## Technologies

- Ruby 3.0.2 (`rvm use 3.0.2`)
- Ruby on Rails 6.1.7
- Postgres Setup (https://www.digitalocean.com/community/tutorials/how-to-use-postgresql-with-your-ruby-on-rails-application-on-macos)
- RSpec (https://relishapp.com/rspec/rspec-rails/docs/gettingstarted)

*Notes: This backend will act as an API only. The frontend will require permissions to make requests and get responses to this API.*

## Dependencies

- bcrypt (https://github.com/bcrypt-ruby/bcrypt-ruby)
- rack-cors (https://www.rubydoc.info/gems/rack-cors/1.1.1)

## User Stories

*Note: These user stories are API based only.*

- [x] As a user, I would like to register an account for myself with and email and password
- [x] As a user, I would like to be able to log in with my account
- [x] As a user, I would like to log out from my account
- [x] As a user, I would like to edit my account details
- [x] As a user, I would like to delete my account
- [x] As a user, I would like to create a profile for my pet
- [x] As a user, I would like the profile to include
  - [x] Name (Pet's)
  - [x] Breed
  - [x] Sex
  - [x] Birthday
  - [x] Size
- [x] As a user, I would like the ability to edit my pet's profile
- [x] As a user, I would like to have the ability to delete my pet's profile
- [ ] As a user, I would like to see other matched pets to make a selection for potential pet friends
- [ ] As a user, I would like my selected pet profiles to be stored so I can visit this list whenever I want
- [ ] As a user, I would like delete unwanted pet profiles

## Testing

This API uses RSpec to test the functionality.

To run the whole test suite, simple run the below from the root directory

```bash
~ rspec ./spec
```
To test only a specific file,

```bash
~ rspec ./spec/path/file_name.rb
```
To test only a specific test,

```bash
~ rspec ./spec/path/file_name.rb:line_number
```

## Target Audience

People with either dogs, cats or birds.

## Monetisation

Encourage advertising for income
- Banner = $0.10
- Interstitial = $1.50
- Video = $5.00

This is an estimate based on 10 000 users spending 2 minutes in the app and only using banner adds.

Number of ads shown per day = number of active users * time spent on the app * ads per minute
- 10,000 * 2 * 2 = 40,000 banner ads.

Average number of clicks = number of ads * click rate
- 40,000 * (1.5 / 100) = 600 clicks

Revenue through ads = Clicks * RPM
- 600 * 0.10 = $60

A small subscription may be paid to remove adverts. The subscription options are
- $ 6.99 per month
- $ 59.88 per year

The market potential for Australia alone is massive. A survey conducted in 2021 stated that there are 10 million households that have pets. Using the above calculation, 20% of this market, using only banner ads, could generate

2,000,000 * 2 * 2 = 8,000,000 banner ads
8,000,000 * (1.5 / 100) = 120,000 clicks
120,000 * 0.10 = $ 120,000

## Marketing Strategy

## The Success
