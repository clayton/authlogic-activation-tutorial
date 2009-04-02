# modified user.rb
# For authlogic 2.0+
acts_as_authentic do |c|
  c.validates_length_of_password_field_options = {:on => :update, :minimum => 4, :if => :has_no_credentials?}
  c.validates_length_of_password_confirmation_field_options = {:on => :update, :minimum => 4, :if => :has_no_credentials?}
end

# Pre-authlogic 2.0
# acts_as_authentic :login_field_validation_options => { :if => :openid_identifier_blank? },
#                   :password_field_validation_options => { :if => :openid_identifier_blank? },
#                   :password_field_validates_length_of_options => { :on => :update, :if => :has_no_credentials? }

# ...
# we need to make sure that either a password or openid gets set
# when the user activates his account
def has_no_credentials?
  self.crypted_password.blank? && self.openid_identifier.blank?
end

# ...
# now let's define a couple of methods in the user model. The first
# will take care of setting any data that you want to happen at signup
# (aka before activation)
def signup!(params)
  self.login = params[:user][:login]
  self.email = params[:user][:email]
  save_without_session_maintenance
end

# the second will take care of setting any data that you want to happen
# at activation. at the very least this will be setting active to true
# and setting a pass, openid, or both.
def activate!(params)
  self.active = true
  self.password = params[:user][:password]
  self.password_confirmation = params[:user][:password_confirmation]
  self.openid_identifier = params[:user][:openid_identifier]
  save
end

# modified activations_controller.rb
def create
  @user = User.find(params[:id])

  raise Exception if @user.active?

  if @user.activate!(params)
    @user.deliver_activation_confirmation!
    flash[:notice] = "Your account has been activated."
    redirect_to account_url
  else
    render :action => :new
  end
end

# modified users_controller.rb
def create
  @user = User.new

  if @user.signup!(params)
    @user.deliver_activation_instructions!
    flash[:notice] = "Your account has been created. Please check your e-mail for your account activation instructions!"
    redirect_to root_url
  else
    render :action => :new
  end
end