module UsersHelper
  def username_hint
    PapyrusConfig.authentication.cas_user_id_name
  end
  
  def email_hint
    "#{PapyrusConfig.organization.short_name} Email"
  end
end
