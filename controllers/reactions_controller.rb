require 'erb'
require 'sequel'
require_relative '../models/reaction'

class ReactionsController

  def self.create(params)
    array = params.split("/")
    post_id = array[2][3..-1]
    user_id = array[3][5..-1]
    Reaction.create(user_id: user_id, post_id: post_id)
    [302, {'Location' =>"http://localhost:8080/"}, []]
  end

  def self.delete(params)
    Comment.delete(user_id: params['user_id'], post_id: params['post_id'])
    [302, {'Location' =>"http://localhost:8080/"}, []]
  end

end
