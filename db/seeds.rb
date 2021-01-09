# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Theme.create!(
  month: '6',
  theme1: '雨',
  theme2: '傘',
  theme3: 'あじさい',
  sentence: '5月。
            ゴールデンウィークは何をしよう。
            パンフレットを見て、遠い異国に思いを馳せたり。
            公園を散歩したら、出会った生き物を改めて観察してみたり。
            いつもの食事に遊びを取り入れたり。
            あなたの目に映るひと時を、2createで伝えてみよう。',
)
