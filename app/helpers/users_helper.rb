module UsersHelper
  def username_hint
    PapyrusSettings.auth_cas_user_id_label
  end

  def email_hint
    "#{PapyrusSettings.org_short_name} Email"
  end

  def gravatar(email, size: '64', style: 'retro', force: false)
    email_hash = Digest::MD5.hexdigest(email)
    force_default = force ? 'f=y' : ''
    image_tag("http://www.gravatar.com/avatar/#{email_hash}?s=#{size}&d=#{style}&#{force_default}", class: 'gravatar')
  end
end
