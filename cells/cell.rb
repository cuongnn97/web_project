require 'cells'
require 'cells-erb'

class SessionsCell < Cell::ViewModel
  include ::Cell::Erb
  self.view_paths = ["views"]

  def new
    render view: :new
  end

  def homepage
    (render view: :homepage) + cell(:sessions).show_relation(model[:friends], model[:new_users], model[:user])
  end


  def newfeed
    (render view: :newfeed) + cell(:sessions).show_relation(model[:friends], model[:new_users], model[:user])
  end

  def register
    render view: :register
  end

  def show_relation(friends, new_users, user_id)
    options[:friends] = friends
    options[:new_users] = new_users
    options[:user_id] = user_id
    render view: :relation_cell
  end

  def post_reactions(post_id, reactions)
    string = ""
      reactions.each do |reaction|
        if reaction.post_id.to_i == post_id
          string += reaction[:name]
          string += ', '
        end
      end
    return string
  end

  def post_comments(post_id, comments)
    string = ""
      comments.each do |comment|
        if comment.post_id.to_i == post_id
          string += '<p class="content_comment">'
          string += comment[:name]
          string += ' wrote: "'
          string += comment[:content]
          string += '"</p>'
        end
      end
    return string
  end

end
