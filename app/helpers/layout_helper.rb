# These helper methods can be called in your template to set variables to be used in the layout
# This module should be included in all views globally,
# to do so you may need to add this line to your ApplicationController
#   helper :layout
module LayoutHelper
  def link_to_logo(path=root_path, image_src="logo.png", alt="Sample App", css_class="round")
    link_to(path) do
      image_tag(image_src, :alt => alt, :class => css_class)
    end
  end
  def title(page_title, show_title = true)
    base_title = "Ruby on Rails Tutorial Sample App"
    page_title = @title.nil? ? base_title : base_title + " | " + @title
    content_for(:title) { page_title.to_s }
    @show_title = show_title
  end
  
  def show_title?
    @show_title
  end
  
  def stylesheet(*args)
    content_for(:head) { stylesheet_link_tag(*args) }
  end
  
  def javascript(*args)
    content_for(:head) { javascript_include_tag(*args) }
  end
end
