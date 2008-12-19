class PostsController < ApplicationController
  before_filter :login_required
  
  def create
    @post = Post.new(params[:post])
    @post.user = current_user
    if @post.save
      return redirect_to @post.url if @post.url
      return redirect_to by_posts_url(:id => "~#{current_user.login}")
    end
    render :action => 'new'
  end
  
  def by
    username = params[:id].gsub /^~/, ''
    user = User.find(:first, :conditions => ['login=?', username])
    return not_found if user.nil?
    @posts = user.posts.find(:all, :order => 'created_at desc')
    render :action => 'posts'
  end
  
  def latest
    @posts = Post.find(:all, :order => 'created_at desc')
    render :action => 'posts'
  end
  
  
end
