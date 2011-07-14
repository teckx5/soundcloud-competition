module ApplicationHelper
  def login_link
    login_path + "?return_to=" + request.env['PATH_INFO']
  end
end
