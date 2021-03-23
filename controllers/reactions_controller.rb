require 'erb'
require 'sequel'
require_relative '../models/reaction'
require_relative './warden'

class ReactionsController

  def self.create(params, env)
    user = env['warden'].user
    array = params.split("/")
    post_id = array[2][3..-1]
    reaction = Reaction.find_first(user_id: user.id, post_id: post_id)
    if reaction == nil
      Reaction.create(user_id: user.id, post_id: post_id)
    else
      Reaction.delete(user_id: user.id, post_id: post_id)
    end
    [302, {'Location' =>"http://localhost:8080/"}, []]
  end
end
