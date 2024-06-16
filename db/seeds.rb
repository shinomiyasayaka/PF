puts "seedの実行を開始"

olivia = Customer.find_or_create_by!(email: "olivia@example.com") do |customer|
  customer.name = "Olivia"
  customer.password = "password"
  customer.profile_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-user1.jpg"), filename:"sample-user1.jpg")
end

james = Customer.find_or_create_by!(email: "james@example.com") do |customer|
  customer.name = "James"
  customer.password = "password"
  customer.profile_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-user2.jpg"), filename:"sample-user2.jpg")
end

lucas = Customer.find_or_create_by!(email: "lucas@example.com") do |customer|
  customer.name = "Lucas"
  customer.password = "password"
  customer.profile_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-user3.jpg"), filename:"sample-user3.jpg")
end

Post.find_or_create_by!(title: "Cavello") do |post|
  post.image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-post1.jpg"), filename:"sample-post1.jpg")
  post.body = "大人気のカフェです。"
  post.customer = olivia
end

Post.find_or_create_by!(title: "和食屋せん") do |post|
  post.image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-post2.jpg"), filename:"sample-post2.jpg")
  post.body = "日本料理は美しい！"
  post.customer = james
end

Post.find_or_create_by!(title: "ShoreditchBar") do |post|
  post.image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-post3.jpg"), filename:"sample-post3.jpg")
  post.body = 'メキシコ料理好きな方にオススメ！'
  post.customer = lucas
end

puts "seedの実行が完了しました"