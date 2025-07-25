# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Create admin user
admin = User.find_or_create_by!(email: "admin@shelfshare.com") do |user|
  user.name = "ShelfShare Admin"
  user.location = "New York, NY"
  user.password = "password123"
  user.password_confirmation = "password123"
  user.admin = true
end

# Create sample users
users = [
  {
    name: "Alice Johnson",
    email: "alice@example.com",
    location: "San Francisco, CA",
    password: "password123"
  },
  {
    name: "Bob Smith",
    email: "bob@example.com",
    location: "Austin, TX",
    password: "password123"
  },
  {
    name: "Carol Davis",
    email: "carol@example.com",
    location: "Portland, OR",
    password: "password123"
  }
]

created_users = users.map do |user_attrs|
  User.find_or_create_by!(email: user_attrs[:email]) do |user|
    user.name = user_attrs[:name]
    user.location = user_attrs[:location]
    user.password = user_attrs[:password]
    user.password_confirmation = user_attrs[:password]
  end
end

# Create sample books
books_data = [
  {
    title: "To Kill a Mockingbird",
    author: "Harper Lee",
    description: "A classic American novel about racial injustice and childhood innocence in the American South.",
    condition: "Good",
    available: true
  },
  {
    title: "The Great Gatsby",
    author: "F. Scott Fitzgerald",
    description: "A masterpiece of American literature set in the Jazz Age.",
    condition: "New",
    available: true
  },
  {
    title: "1984",
    author: "George Orwell",
    description: "A dystopian social science fiction novel about totalitarian surveillance.",
    condition: "Fair",
    available: true
  },
  {
    title: "Pride and Prejudice",
    author: "Jane Austen",
    description: "A romantic novel of manners set in Georgian England.",
    condition: "Good",
    available: false
  },
  {
    title: "The Catcher in the Rye",
    author: "J.D. Salinger",
    description: "A controversial novel about teenage rebellion and alienation.",
    condition: "Good",
    available: true
  },
  {
    title: "Dune",
    author: "Frank Herbert",
    description: "Epic science fiction novel set in a distant future.",
    condition: "New",
    available: true
  }
]

# Assign books to users
books_data.each_with_index do |book_data, index|
  user = created_users[index % created_users.length]

  Book.find_or_create_by!(title: book_data[:title], user: user) do |book|
    book.author = book_data[:author]
    book.description = book_data[:description]
    book.condition = book_data[:condition]
    book.available = book_data[:available]
  end
end

puts "Created #{User.count} users and #{Book.count} books"
puts "Admin user: admin@shelfshare.com (password: password123)"
