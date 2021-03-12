require 'erb'
require 'sequel'

conDB = Sequel.sqlite('./sequelData.db')

class Comment < Sequel::Model(conDB[:posts])

  def self.find_by(**attrs)
    posts = Post.where(**attrs)
    return posts
  end

  def self.create(**attrs)
    new_post = Post.new
    new_post.content = attrs[:content]
    new_post.user_id = attrs[:user_id]
    new_post.save
  end

  def self.delete(**attrs)
    post_to_delete = Post.where(**attrs)
    post_to_delete.destroy
  end

  def self.edit(**attrs)
    post_to_edit = Post.where(:id => attrs[:id]).update(content: attrs[:content])
  end

end
