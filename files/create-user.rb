if (! User.find_by(username: 'demo'))
  user = User.create(username:'demo')
  user.admin = true
  user.email = 'demo@dev.null'
  user.confirmed_at = Time.now
  user.name = 'demo'
  user.password = 'demo user'
  user.password_confirmation = 'demo user'

  user.save!
else
  puts 'User already exists!'
end
