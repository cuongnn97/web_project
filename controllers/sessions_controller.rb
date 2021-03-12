require 'erb'
require 'sequel'
require 'digest'
require_relative '../models/post'
require_relative '../models/user'

class SessionsController

  #Init login screen
  def self.new(params)
    message = ""
    return [500, {"Content-Type" => "text/html"}, [ERB.new(File.read("./views/sessions/new.erb")).result(binding)]]
  end

  def self.check(user)
    if user == nil
      message = ""
      return [500, {"Content-Type" => "text/html"}, [ERB.new(File.read("./views/sessions/new.erb")).result(binding)]]
    else
      posts = Post.find_by(user_id: user.id)
      return [500, {"Content-Type" => "text/html"}, [ERB.new(File.read("./views/homepage.erb")).result(binding)]]
    end
  end

  #Action login button
  def self.create(params)

    user = User.find_first(name: params['username'], password: (Digest::SHA256.base64digest params['password']))
    if user == nil
      message = "Wrong username or password, type again"
      return [500, {"Content-Type" => "text/html"}, [ERB.new(File.read("./views/sessions/new.erb")).result(binding)]]
    else
      posts = Post.find_by(user_id: user.id)
      return [500, {"Content-Type" => "text/html"}, [ERB.new(File.read("./views/homepage.erb")).result(binding)]]
    end
  end
end
