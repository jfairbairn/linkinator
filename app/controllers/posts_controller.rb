class PostsController < ApplicationController
  before_filter :login_required
  include PostsHelper
  
  def new
    @new_post = Post.new(params[:post])
    flash[:return] = params[:return] if params[:return]
  end
  
  def create
    @new_post = Post.new(params[:post])
    @new_post.title ="(no title)" if @new_post.title == ''
    @new_post.user = current_user
    if @new_post.save
      return redirect_to(@new_post.urls.first.url) if !@new_post.urls.empty? && flash[:return]
      return redirect_to(smart_post_url(@new_post))
    end
    if @new_post.in_reply_to_id # show errors inline
      @post = @new_post
      return render(:action => 'show', :id => @new_post.in_reply_to_id)
    end
    render :action => 'new'
  end
  
  def show
    @post = Post.find(:first, :conditions => ['id=?', params[:id]]) or return not_found
    @new_post = Post.new(:in_reply_to_id => @post.id) unless @new_post
  end
  
  def latest
    opts = {:order => 'created_at desc', :limit => 50}
    opts[:conditions] = 'in_reply_to_id is null' unless params[:sr]
    opts[:page] = params[:page]
    @posts = Post.paginate(:all, opts)
    render :action => 'posts'
  end

  def by
    username = params[:id].gsub /^~/, ''
    user = User.find(:first, :conditions => ['login=?', username]) or return not_found
    return not_found if user.nil?
    opts = {:order => 'created_at desc'}
    opts[:conditions] = 'in_reply_to_id is null' unless params[:sr]
    opts[:page] = params[:page]
    @posts = user.posts.paginate(:all, opts)
    render :action => 'posts'
  end
  
end
