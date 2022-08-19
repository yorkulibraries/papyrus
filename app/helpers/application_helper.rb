module ApplicationHelper
  def controller_name
    controller.controller_name
  end

  def is_action?(a, output = nil)
    result = controller.action_name == a
    !output.nil? && result ? output : result
  end

  def is_controller?(c, output = nil)
    result = controller.controller_name == c
    !output.nil? && result ? output : result
  end

  def is_controller_and_action?(c, a, output = nil)
    result = (controller.controller_name == c && controller.action_name == a)
    !output.nil? && result ? output : result
  end

  def action_name
    controller.action_name
  end

  def current_path
    path = request.env['PATH_INFO']
  end

  def papyrus_version
    Papyrus::Version.new.version
    # "2.8.3"
  end

  def papyrus_institution
    PapyrusSettings.org_name
  end

  def org_short_name
    PapyrusSettings.org_short_name
  end
end
