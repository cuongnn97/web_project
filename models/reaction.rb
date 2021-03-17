require 'erb'
require 'sequel'

conDB = Sequel.sqlite('./sequelData.db')

class Reaction < Sequel::Model(conDB[:reactions])

  def self.find_by(**attrs)
    conDB = Sequel.sqlite('./sequelData.db')
    reactions = Reaction.join(conDB[:users], id: :user_id).where(**attrs)
    return reactions
  end

  def self.create(**attrs)
    new_reaction = Reaction.new
    new_reaction.post_id = attrs[:post_id]
    new_reaction.user_id = attrs[:user_id]
    new_reaction.save
  end

  def self.delete(**attrs)
    Reaction.where(post_id: attrs[:post_id]).where(user_id: attrs[:user_id]).delete
  end

end
