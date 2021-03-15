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

end
