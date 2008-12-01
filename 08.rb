# added to user.rb
def activate!
  self.active = true
  save
end