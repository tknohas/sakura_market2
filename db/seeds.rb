products = %w(にんじん 玉ねぎ ピーマン ジャガイモ 白菜 大根)
(0..5).each do |n|
  Product.create!(name: products[n], price: n * 1000, description: "#{n}番目の商品です。", private: false, position: n)
end
User.create!(name: 'Alice', email: 'alice@example.com', password: '123456')
