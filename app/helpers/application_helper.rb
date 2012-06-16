module ApplicationHelper
  def login_url
    client_id = Rails.env == "development" ? 119934318017902 : 383285121729602
    "https://www.facebook.com/dialog/oauth?client_id=#{client_id}&redirect_uri=#{intro_url}&scope=user_photos&state=iwilldoit"
  end
end
