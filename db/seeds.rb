Product.delete_all

books = %w( rails ruby ios java clean_code )

books.each do |book|
  Product.create title: "#{book} title", description: "This is a #{book} book descrition",
  							 image_url: "#{book}.jpg", price: [100_000, 200_000, 300_000].sample
end
