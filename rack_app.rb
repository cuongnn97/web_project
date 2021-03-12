require 'base64'
require 'cgi'
require 'erb'
require 'uri'
require "rack"
require "thin"
require "pry"
require 'pry-byebug'
require "warden"
require_relative './controllers/users_controller'
require_relative './controllers/sessions_controller'
require_relative './controllers/posts_controller'
require_relative './controllers/warden'
require_relative './models/user'

class RackApp

  def call(env)
    req = Rack::Request.new(env)
    case req.path_info

    when /login/

      env['warden'].authenticate!
      SessionsController.create(req.params)

    when /logout/

      env['warden'].logout
      SessionsController.new(req.params)

    when /posts/

      PostsController.create(req.params)

    when /post/
      binding.pry
      if req.params['method'] == "DELETE"
        PostsController.delete(req.params)
      elsif req.params['method'] == "PUT"
        PostsController.update(req.params)
      end

    when /init_register/

      UsersController.new(req.params)

    when /register/

      UsersController.create(req.params)

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

Rack::Handler::Thin.run app
