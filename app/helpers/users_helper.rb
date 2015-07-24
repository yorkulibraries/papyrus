module UsersHelper
  def username_hint
    PapyrusSettings.auth_cas_user_id_label
  end

  def email_hint
    "#{PapyrusSettings.org_short_name} Email"
  end
end
