# frozen_string_literal: true

if Rails.env.development? && defined? Bullet
  Bullet.enable = false
  Bullet.alert = true
  # Bullet.bullet_logger = true
end
