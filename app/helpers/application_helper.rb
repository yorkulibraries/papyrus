module ApplicationHelper
  
  def controller_name
    controller.controller_name
  end
  
  def action_name
    controller.action_name
  end

  def current_path
    path = request.env['PATH_INFO']    
  end
  
  def papyrus_version
    "2.1"
  end
end
