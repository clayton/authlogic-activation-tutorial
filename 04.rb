# added to user.rb
attr_accessible :login, :email, :password, :password_confirmation, :openid_identifier

def active?
  active
end