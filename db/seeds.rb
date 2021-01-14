# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create!(
  email: "admin1@mailaddress",
  password: 'admin1admin',
  name: '管理者1',
  authority: "管理者",
  is_deleted: false
)

User.create!(
  email: "admin2@mailaddress",
  password: 'admin2admin',
  name: '管理者2',
  authority: "管理者",
  is_deleted: false
)

User.create!(
  email: "guest1@mailaddress",
  password: 'guest1guest',
  name: 'ゲスト1',
  authority: "ユーザー",
  is_deleted: false
)

User.create!(
  email: "guest2@mailaddress",
  password: 'guest2guest',
  name: 'ゲスト2',
  authority: "ユーザー",
  is_deleted: false
)