require 'erb'
require 'sequel'
require_relative '../models/reaction'
require_relative './warden'

class ReactionsController

  def self.create(params, env)
    user = env['warden'].user
    array = params.split("/")
    post_id = array[2][3..-1]
    Reaction.create(user_id: user.id, post_id: post_id)
    [302, {'Location' =>"http://localhost:8080/"}, []]
  end

  def self.delete(params, env)
    user = env['warden'].user
    Comment.delete(user_id: user.id, post_id: params['post_id'])
    [302, {'Location' =>"http://localhost:8080/"}, []]
  end

end
