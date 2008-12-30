class PostsController < ApplicationController
  before_filter :login_required
  include PostsHelper
  
  def new
    @post = Post.new(params[:post])
    flash[:return] = params[:return] if params[:return]
  end
  
  def create
    @post = Post.new(params[:post])
    @post.user = current_user
    if @post.save
      return redirect_to(@post.urls.first.url) if !@post.urls.empty? && flash[:return]
      return redirect_to(posts_by_url(current_user.login))
    end
    render :action => 'new'
  end
  
  def destroy
    @post = current_user.posts.find(:first, :conditions => ['id=?', params[:id]]) or return not_found
    @post.destroy
    redirect_to :back
  end
  
  def show
    @post = Post.find(:first, :conditions => ['id=?', params[:id]]) or return not_found
  end
  
  def latest
    @posts = Post.find(:all, :order => 'created_at desc')
    render :action => 'posts'
  end

  def by
    username = params[:id].gsub /^~/, ''
    user = User.find(:first, :conditions => ['login=?', username]) or return not_found
    return not_found if user.nil?
    @posts = user.posts.find(:all, :order => 'created_at desc')
    render :action => 'posts'
  end
  
end
