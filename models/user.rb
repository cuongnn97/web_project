require 'erb'
require 'sequel'
require 'digest'

conDB = Sequel.sqlite('./sequelData.db')

class User < Sequel::Model(conDB[:users])

  def self.find_first(**attrs)
    user = User.first(**attrs)
    return user
  end

  def self.create(**attrs)
    user = User.new
    user.name = attrs[:name]
    user.password = Digest::SHA256.base64digest attrs[:password]
    user.save
  end

  def self.authenticate(username, password)
    user = User.first(name: username)
    return nil if user.nil?
    user.password == (Digest::SHA256.base64digest password) ? user : nil
  end

end
