# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create!(
  email: "admin@mailaddress",
  password: '99admin9',
  name: '管理者1',
  authority: "管理者",
  is_deleted: false
)

30.times do |n|
    User.create!(
      email: "creator#{n + 1}@gmail.com",
      password: "creator#{n + 1}",
      name: "クリエイター#{n + 1}",
      authority: "ユーザー",
      is_deleted: false
    )
  end
  
        image: File.open('./app/assets/images/test.jpg')
  10.times do |n|
    Activity.create!(
      name: "creator#{n + 1}@gmail.com",
      act_image: "creator#{n + 1}",
      to_create: "クリエイター#{n + 1}",
      to_study: "ユーザー",
      to_do: false
    )
  end