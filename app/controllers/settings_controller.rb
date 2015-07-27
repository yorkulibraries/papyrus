class SettingsController < ApplicationController

  authorize_resource PapyrusSettings

  def general
  end

  def email
  end

  def bib_search
  end

  def item
  end

  def system
  end

  def update
    settings = params[:setting]

    settings.each do |key, value|
      PapyrusSettings[key] = value
    end

    case params[:return_to]
    when "email"
      redirect_to email_settings_path, notice: "Saved Email Settings"
    when "bib_search"
      redirect_to bib_search_settings_path, notice: "Saved Catalog Search Settings"
    when "item"
      redirect_to item_settings_path, notice: "Saved Item Settings"
    when "system"
      redirect_to system_settings_path, notice: "Saved Acquisition Requests Settings"
    else
      redirect_to general_settings_path
    end

  end


end
