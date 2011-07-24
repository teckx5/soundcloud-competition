module ApplicationHelper
  def login_link
    login_path + "?return_to=" + request.env['PATH_INFO']
  end

  def markdown(text)
    Redcarpet.new(text).to_html.html_safe
  end
end
