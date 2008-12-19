module PostsHelper
  def posts_by_url(username)
    url_for(:controller => 'posts', :action => 'by', :id => "~#{username}")
  end
  
end
