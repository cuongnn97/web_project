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
    relationship_to_delete1 = UserRelationship.where(user_first_id: attrs[:user_first_id]).where(user_second_id: attrs[:user_second_id]).delete
    relationship_to_delete2 = UserRelationship.where(user_first_id: attrs[:user_second_id]).where(user_second_id: attrs[:user_first_id]).delete
  end

  def self.create(**attrs)
    new_relation1 = UserRelationship.new
    new_relation1.user_first_id = attrs[:user_first_id]
    new_relation1.user_second_id = attrs[:user_second_id]
    new_relation1.type = "pending_first_second"
    new_relation1.save
    new_relation2 = UserRelationship.new
    new_relation2.user_first_id = attrs[:user_second_id]
    new_relation2.user_second_id = attrs[:user_first_id]
    new_relation2.type = "pending_second_first"
    new_relation2.save
  end

  def self.update(**attrs)
    UserRelationship.where(user_first_id: attrs[:user_first_id]).where(user_second_id: attrs[:user_second_id]).update(type: "friends")
    UserRelationship.where(user_first_id: attrs[:user_second_id]).where(user_second_id: attrs[:user_first_id]).update(type: "friends")
  end

end
