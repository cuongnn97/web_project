require 'base64'
require 'cgi'
require 'erb'
require 'uri'
require "rack"
require "thin"
require "pry"
require 'pry-byebug'
require "warden"
require_relative './controllers/comments_controller'
require_relative './controllers/users_controller'
require_relative './controllers/sessions_controller'
require_relative './controllers/posts_controller'
require_relative './controllers/relationships_controller'
require_relative './controllers/reactions_controller'
require_relative './controllers/warden'
require_relative './models/user'

class RackApp

  def call(env)
    req = Rack::Request.new(env)
    case req.path_info

    when /login/

      SessionsController.create(req.params, env)

    when /logout/

      SessionsController.new(req.params, env)

    when /posts/

      PostsController.create(req.params)

    when /post/

      if req.params['method'] == "DELETE"
        PostsController.delete(req.params)
      elsif req.params['method'] == "PUT"
        PostsController.update(req.params)
      end

    when /init_register/

      UsersController.new(req.params)

    when /register/

      UsersController.create(req.params)

    when /delete_relation/

      RelationshipsController.delete(req.params)

    when /add_friend/

      RelationshipsController.create(req.params)

    when /accept_relation/

      RelationshipsController.update(req.params)

    when /homepage/

      SessionsController.homepage_another(env, req.path_info)

    when /comments/

      CommentsController.create(req.params)

    when /reaction/

      ReactionsController.create(req.path_info)

    else

      SessionsController.check(env)

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
