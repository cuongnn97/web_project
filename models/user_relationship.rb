require 'erb'
require 'sequel'
require 'digest'

conDB = Sequel.sqlite('./sequelData.db')

class UserRelationship < Sequel::Model(conDB[:user_relationship])

  def self.find(**attrs)
    conDB = Sequel.sqlite('./sequelData.db')
    user = UserRelationship.join(conDB[:users], id: :user_second_id).where(**attrs)
    return user
  end

  def self.delete(**attrs)
    UserRelationship.where(user_first_id: attrs[:user_first_id]).where(user_second_id: attrs[:user_second_id]).delete
    UserRelationship.where(user_first_id: attrs[:user_second_id]).where(user_second_id: attrs[:user_first_id]).delete
  end

  def self.create(**attrs)
    first_relation = UserRelationship.new
    second_relation = UserRelationship.new
    first_relation.user_first_id = attrs[:user_first_id]
    first_relation.user_second_id = attrs[:user_second_id]
    first_relation.type = "pending_first_second"
    second_relation.user_first_id = attrs[:user_second_id]
    second_relation.user_second_id = attrs[:user_first_id]
    second_relation.type = "pending_second_first"
    first_relation.save
    second_relation.save
  end

  def self.update(**attrs)
    UserRelationship.where(user_first_id: attrs[:user_first_id]).where(user_second_id: attrs[:user_second_id]).update(type: "friends")
    UserRelationship.where(user_first_id: attrs[:user_second_id]).where(user_second_id: attrs[:user_first_id]).update(type: "friends")
  end

end
