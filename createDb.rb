require 'sequel'

DB = Sequel.sqlite('sequelData.db') # memory database, requires sqlite3

# DB.create_table :users do
#   primary_key :id
#   String :name
#   String :password
# end
# users = DB[:users]

# users.insert(:name => 'Cuong', :password => 'cuong')
# users.insert(:name => 'Tung',  :password => 'tung')

# DB.create_table :posts do
#   primary_key :id
#   String :content
#   String :user_id
# end
# posts = DB[:posts]

# posts.insert(:content => 'Post 1 user Cuong', :user_id => '1')
# posts.insert(:content => 'Post 2 user Cuong',  :user_id => '1')
# posts.insert(:content => 'Post 1 user Tung', :user_id => '2')
# posts.insert(:content => 'Post 2 user Tung',  :user_id => '2')

# DB.create_table :comments do
#   primary_key :id
#   String :user_id
#   String :post_id
#   String :content
# end
# comments = DB[:comments]

# comments.insert(:user_id => '1', :post_id => '10', :content => 'comment 1')
# comments.insert(:user_id => '2',  :post_id => '10', :content => 'comment 2')

# DB.create_table :user_relationship do
#   String :user_first_id
#   String :user_second_id
#   String :type
# end
relationship = DB[:user_relationship]

relationship.insert(:user_first_id => '8', :user_second_id => '11', :type => 'pending_first_second')
relationship.insert(:user_first_id => '11',  :user_second_id => '8', :type => 'pending_second_first')
