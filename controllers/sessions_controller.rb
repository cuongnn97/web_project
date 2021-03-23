require 'erb'
require 'sequel'
require 'digest'
require_relative '../models/comment'
require_relative '../models/user'
require_relative '../models/user_relationship'
require_relative '../models/post'
require_relative '../models/reaction'
require_relative './warden'
require_relative '../cells/cell'

class SessionsController

  def self.new(params, env)
    message = ""
    rreturn [500, {"Content-Type" => "text/html"}, [SessionsCell.new({message: ""}).new()]]
  end

  def self.delete(env)
    env['warden'].logout
    message = ""
    return [500, {"Content-Type" => "text/html"}, [SessionsCell.new({message: ""}).new()]]
  end

  def self.homepage_another(env, id)
    user = env['warden'].user
    friends = UserRelationship.find(user_first_id: user.id)
    posts = Post.find_by(user_id: id[13..-1])
    comments = get_comment_by_posts(posts)
    new_users = User.find_new_users(id: user.id)
    page_user = User.first(id: id[13..-1])
    reactions = get_reaction_by_posts(posts)
    return [500, {"Content-Type" => "text/html"}, [SessionsCell.new({user: user, friends: friends, posts: posts, comments: comments, new_users: new_users, reactions: reactions, page_user: page_user}).homepage_another()]]
  end

  def self.check(env)
    user = env['warden'].user
    if user == nil
      message = ""
      return [500, {"Content-Type" => "text/html"}, [SessionsCell.new({message: ""}).new()]]

    else
      friends = UserRelationship.find(user_first_id: user.id)
      posts = Post.find_by(user_id: user.id)
      comments = get_comment_by_posts(posts)
      new_users = User.find_new_users(id: user.id)
      reactions = get_reaction_by_posts(posts)
      return [500, {"Content-Type" => "text/html"}, [SessionsCell.new({user: user, friends: friends, posts: posts, comments: comments, new_users: new_users, reactions: reactions}).homepage()]]
    end
  end

  def self.create(params, env)
    env['warden'].authenticate!
    user = User.find_first(name: params['username'], password: (Digest::SHA256.base64digest params['password']))
    if user == nil
      message = "Wrong username or password, type again"
      return [500, {"Content-Type" => "text/html"}, [SessionsCell.new({message: ""}).new()]]
    else
      friends = UserRelationship.find(user_first_id: user.id)
      posts = Post.find_by(user_id: user.id)
      comments = get_comment_by_posts(posts)
      new_users = User.find_new_users(id: user.id)
      reactions = get_reaction_by_posts(posts)
      return [500, {"Content-Type" => "text/html"}, [SessionsCell.new({user: user, friends: friends, posts: posts, comments: comments, new_users: new_users, reactions: reactions}).homepage()]]
    end
  end

  def self.get_comment_by_posts(posts)
    post_id_array = []
    if !posts.nil? && !posts.empty?
      posts.each do |post|
        post_id_array << post.id
      end
    end
    if post_id_array.length > 0
      comments = Comment.find_by(post_id: post_id_array)
      return comments
    else
      return nil
    end
  end

  def self.get_reaction_by_posts(posts)
    post_id_array = []
    if !posts.nil? && !posts.empty?
      posts.each do |post|
        post_id_array << post.id
      end
    end
    if post_id_array.length > 0
      reactions = Reaction.find_by(post_id: post_id_array)
      return reactions
    else
      return nil
    end
  end

end
