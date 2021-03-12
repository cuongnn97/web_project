require 'erb'
require 'sequel'
require_relative '../models/user'

class UsersController

  def self.new(params)
    return [500, {"Content-Type" => "text/html"}, [ERB.new(File.read("./views/register.erb")).result(binding)]]
  end

  def self.create(params)
    User.create(name: params['username'], password: params['password'])
    message = "Register successful!!!!"
    return [500, {"Content-Type" => "text/html"}, [ERB.new(File.read("./views/sessions/new.erb")).result(binding)]]
  end
end
