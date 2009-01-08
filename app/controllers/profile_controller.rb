class ProfileController < ApplicationController
  before_filter :login_required
  
  def show
    @user = current_user
  end
  
  def update
    @user = current_user
    attrs = params[:user]
    attrs.delete :login
    authenticated = @user.authenticated?(params[:old_password])
    if attrs[:password] && !authenticated
      flash[:error] = 'Old password incorrect.'
      return render(:action => 'show')
    end
    if attrs[:password].nil? || authenticated
      if @user.update_attributes(attrs)
        @user.password = nil
        @user.password_confirmation = nil
        current_user = @user
        flash[:message] = 'Changes saved.'
        redirect_to profile_url
      else
        render :action => 'show'
      end
    end
  end
  
  
end
