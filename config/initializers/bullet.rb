if Rails.env.development? && defined? Bullet
  Bullet.enable = true
  Bullet.alert = true
  #Bullet.bullet_logger = true
end

