require 'cells'
require 'cells-erb'

class SessionsCell < Cell::ViewModel
  include ::Cell::Erb
  self.view_paths = ["views"]

  def new
    render view: :new
  end

  def homepage
    render view: :homepage
  end

  def homepage_another
    render view: :homepage_another
  end

  def register
    render view: :register
  end

end
