# in app/models/user.rb

def deliver_activation_instructions!
  reset_perishable_token!
  Notifier.deliver_activation_instructions(self)
end

def deliver_activation_confirmation!
  reset_perishable_token!
  Notifier.deliver_activation_confirmation(self)
end

# in app/models/notifier.rb

def activation_instructions(user)
  subject       "Activation Instructions"
  from          "Binary Logic Notifier <noreply@binarylogic.com>"
  recipients    user.email
  sent_on       Time.now
  body          :account_activation_url => register_url(user.perishable_token)
end

def activation_confirmation(user)
  subject       "Activation Complete"
  from          "Binary Logic Notifier <noreply@binarylogic.com>"
  recipients    user.email
  sent_on       Time.now
  body          :root_url => root_url
end

# in config/routes.rb

map.register '/register/:activation_code', :controller => 'activations', :action => 'new'
map.activate '/activate/:id', :controller => 'activations', :action => 'create'