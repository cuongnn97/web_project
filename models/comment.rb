require 'erb'
require 'sequel'

conDB = Sequel.sqlite('./sequelData.db')

class Comment < Sequel::Model(conDB[:comments])

  def self.find_by(**attrs)
    conDB = Sequel.sqlite('./sequelData.db')
    comments = Comment.join(conDB[:users], id: :user_id).where(**attrs)
    return comments
  end

  def self.create(**attrs)
    new_comments = Comment.new
    new_comments.user_id = attrs[:user_id]
    new_comments.post_id = attrs[:post_id]
    new_comments.content = attrs[:comment_content]
    new_comments.save
  end

  def self.delete(**attrs)
    comment_to_delete = Comment.where(**attrs)
    comment_to_delete.destroy
  end

  def self.edit(**attrs)
    comment_to_edit = Comment.where(:id => attrs[:id]).update(content: attrs[:content])
  end

end
