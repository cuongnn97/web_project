require 'erb'
require 'sequel'
require_relative '../models/user_relationship'

class RelationshipsController

  def self.delete(params)
    UserRelationship.delete(user_first_id: params['user_first_id'], user_second_id: params['user_second_id'])
    [302, {'Location' =>"http://localhost:8080/"}, []]
  end

  def self.create(params)
    UserRelationship.create(user_first_id: params['user_first_id'], user_second_id: params['user_second_id'])
    [302, {'Location' =>"http://localhost:8080/"}, []]
  end

  def self.update(params)
    UserRelationship.update(user_first_id: params['user_first_id'], user_second_id: params['user_second_id'])
    [302, {'Location' =>"http://localhost:8080/"}, []]
  end
end
