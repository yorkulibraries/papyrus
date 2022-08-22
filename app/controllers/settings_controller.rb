class SettingsController < AuthenticatedController
  authorize_resource PapyrusSettings

  def general; end

  def email; end

  def bib_search; end

  def item; end

  def courses; end

  def acquisitions; end

  def students; end

  def system; end

  def update
    settings = params[:papyrus_settings]

    settings.each do |key, value|
      PapyrusSettings.send("#{key}=", value)
    end

    case params[:return_to]
    when 'email'
      redirect_to email_settings_path, notice: 'Saved Email Settings'
    when 'bib_search'
      redirect_to bib_search_settings_path, notice: 'Saved Bib Search Settings'
    when 'primo_alma'
      redirect_to primo_alma_settings_path, notice: 'Saved Primo Alma Settings'
    when 'item'
      redirect_to item_settings_path, notice: 'Saved Item Settings'
    when 'students'
      redirect_to students_settings_path, notice: 'Saved Student Management Settings'
    when 'courses'
      redirect_to courses_settings_path, notice: 'Saved Courses Settings'
    when 'system'
      redirect_to system_settings_path, notice: 'Saved System Settings'
    when 'acquisitions'
      redirect_to acquisitions_settings_path, notice: 'Saved Acquisitions Settings'
    else
      redirect_to general_settings_path, notice: 'Saved General Settings'
    end
  end
end
