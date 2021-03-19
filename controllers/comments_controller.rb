require 'erb'
require 'sequel'
require_relative '../models/comment'
require_relative './warden'

class CommentsController

  def self.create(params, env)
    user = env['warden'].user
    Comment.create(comment_content: params['comment_content'], user_id: user.id, post_id: params['post_id'])
    [302, {'Location' =>"http://localhost:8080/"}, []]
  end

  def self.delete(params)
    Comment.delete(id: params['post_id'])
    [302, {'Location' =>"http://localhost:8080/"}, []]
  end

  def self.update(params)
    Comment.where(id: params['post_id']).update(content: params['new_content'])
    [302, {'Location' =>"http://localhost:8080/"}, []]
  end

end
