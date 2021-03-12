require 'erb'
require 'sequel'
require_relative '../models/post'

class PostsController

  def self.create(params)
    validate_params(params)
    Post.create(content: params['content'], user_id: params['user_id'])
    [302, {'Location' =>"http://localhost:8080/"}, []]
  end

  def self.delete(params)
    validate_params(params)
    Post.delete(id: params['post_id'])
    [302, {'Location' =>"http://localhost:8080/"}, []]
  end

  def self.update(params)
    validate_params(params)

    Post.where(id: params['post_id']).update(content: params['new_content'])
    [302, {'Location' =>"http://localhost:8080/"}, []]
  end

  def self.validate_params(params)

  end

end
