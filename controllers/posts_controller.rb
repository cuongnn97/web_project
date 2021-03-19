require 'erb'
require 'sequel'
require_relative '../models/post'
require_relative './warden'

class PostsController

  def self.create(params, env)
    user = env['warden'].user
    Post.create(content: params['content'], user_id: user.id)
    [302, {'Location' =>"http://localhost:8080/"}, []]
  end

  def self.delete(params)
    Post.delete(id: params['post_id'])
    [302, {'Location' =>"http://localhost:8080/"}, []]
  end

  def self.update(params)
    Post.where(id: params['post_id']).update(content: params['new_content'])
    [302, {'Location' =>"http://localhost:8080/"}, []]
  end

end
