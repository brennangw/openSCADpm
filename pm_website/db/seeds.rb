User.create!(name:  "Example User",
             email: "example@rtutorial.org",
             username: "example-0",
             password:              "foobar123",
             password_confirmation: "foobar123")

99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@rtut.org"
  username  = "example-#{n+1}"
  password = "password"
  User.create!(name:  name,
               email: email,
               username: username,
               password:              password,
               password_confirmation: password)
end
