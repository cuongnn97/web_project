require 'erb'
require 'sequel'
require 'digest'
require_relative './user_relationship'

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

  def self.find_friend(**attrs)
    users = User.exclude(**attrs)
    return users
  end

  def self.find_new_users(**attrs)
    conDB = Sequel.sqlite('./sequelData.db')
    users_status = User.select(:id, :name, :password).join(conDB[:user_relationship], user_second_id: :id).where(user_first_id: attrs[:id])
    new_users = User.exclude(id: attrs[:id]).except(users_status)
    return new_users
  end

end
