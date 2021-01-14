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

  10.times do |n|
    Activity.create!(
      name: "絵画サークル#{n + 1}",
      act_image: File.open('./public/white-color.jpg'),
      to_create: "絵画",
      to_study: "画材の性質、デッサン",
      to_do: "5月11日（火）19時～です"
    )
  end