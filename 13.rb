# modified app/controllers/users_controller.rb
def create
  @user = User.new(params[:user])

  # Saving without session maintenance to skip
  # auto-login which can't happen here because
  # the User has not yet been activated
  if @user.save_without_session_maintenance
    @user.deliver_activation_instructions!
    flash[:notice] = "Your account has been created. Please check your e-mail for your account activation instructions!"
    redirect_to root_url
  else
    render :action => :new
  end
end