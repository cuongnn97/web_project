require "rack"
require "thin"
require "warden"
require "pry"
require 'erb'
require 'base64'
require 'cgi'
require 'uri'
require 'pry-byebug'
require_relative './controllers/sessions_controller'
require_relative './controllers/posts_controller'
require_relative './controllers/users_controller'
require_relative './controllers/warden'
require_relative './models/user'

class RackApp

  def call(env)
    req = Rack::Request.new(env)
    case req.path_info
    when /login/
      env['warden'].authenticate!
      [404, {"Content-Type" => "text/html"}, [SessionsController.create(req.params)]]
    when /logout/
      env['warden'].logout
      [404, {"Content-Type" => "text/html"}, [SessionsController.new(req.params)]]
    when /posts/
      [500, {"Content-Type" => "text/html"}, [PostsController.create(req.params)]]
      Refresh.new.response
    when /post/:id
      if method == "DELETE"
        [500, {"Content-Type" => "text/html"}, [PostsController.delete(req.params)]]
        Refresh.new.response
      elsif method == "PUT" or method == "PATCH"
        PostsController.update(req.params)
      end
    when /init_register/
      [500, {"Content-Type" => "text/html"}, [UsersController.new(req.params)]]
    when /register/
      [500, {"Content-Type" => "text/html"}, [UsersController.create(req.params)]]
    else
      user = env['warden'].user
      SessionsController.check(user)
    end
  end


end

class Unauthorized
  def call(env)
    [401, {"Content-Type" => "text/html"}, ["Unauthorized"]]
  end
end

app = Rack::Builder.new do
  use Rack::Session::Cookie, secret: "1234561241515122132"

  use Warden::Manager do |manager|
    manager.default_strategies :password, :basic
    manager.failure_app = Unauthorized.new
  end

  run RackApp.new
end

# class Refresh
#   def response
#     [ 302, {'Location' =>"http://localhost:8080/"}, [] ]
#   end
# end

Rack::Handler::Thin.run app
