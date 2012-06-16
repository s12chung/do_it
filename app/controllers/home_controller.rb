class HomeController < ApplicationController
  require 'net/http'

  def index
    @client = FacebookOAuth::Client.new(
        :application_id => Rails.env == "development" ? 119934318017902 : 383285121729602,
        :application_secret => "IWillDoIt",
        :callback => intro_url,
        :scope => 'user_photos'
    )
  end

  def intro
    client = FacebookOAuth::Client.new(
        :application_id => Rails.env == "development" ? 119934318017902 : 383285121729602,
        :application_secret => "IWillDoIt",
        :callback => intro_url,
        :scope => "user_photos"
    )
    session[:access_token] = client.authorize(:code => params[:code])
    p session[:access_token]
  end
end