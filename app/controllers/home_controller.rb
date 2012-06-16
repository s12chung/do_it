class HomeController < ApplicationController
  require 'net/http'
  require 'open-uri'

  def index
  end

  def intro
    session[:code] = params[:code]

    client_id = Rails.env == "development" ? 119934318017902 : 383285121729602
    path = "/oauth/access_token?client_id=#{client_id}&redirect_uri=#{intro_url}&client_secret=d6a6829389885c0ce7b71551963f1130&code=#{session[:code]}"

    http = Net::HTTP.new "graph.facebook.com", 443
    http.use_ssl = true

    request = Net::HTTP::Get.new path
    response = http.request request

    session[:access_token] = response.body.split("&").first.sub("access_token=", "")

    @photos = []
    photo_request "https://graph.facebook.com/me/photos?access_token=#{session[:access_token]}&limit=1000"
    @photos = [@photos.first,
               @photos[(@photos.size() * 1/5).floor],
               @photos[(@photos.size() * 2/5).floor],
               @photos[(@photos.size() * 3/5).floor],
               @photos[(@photos.size() * 4/5).floor],
               @photos.last]
    @photos.reverse!

    @profile_picture_src = profile_picture_request

    @photos = [{src: @profile_picture_src}] + @photos + [{src: @profile_picture_src}]
    @pp_small = "https://graph.facebook.com/me/picture?type=square&access_token=#{session[:access_token]}"
  end

  def photo_request(url)
    photos = open_json url
    photos['data'].each do |photo|
      score = 0
      if photo['likes']; score += photo['likes'].size end
      if photo['comments']; score += photo['comments'].size end
      if photo['tags']; score += photo['tags']['data'].size/5 end

      @photos << {
          src: photo['source'],
          score: score
      }
    end
    if photos['paging'] && photos['paging']['next']
      photo_request(photos['paging']['next'])
    end
  end

  def profile_picture_request
    photos = open_json "https://graph.facebook.com/me/albums?access_token=#{session[:access_token]}"
    photos['data'].each do |photo|
      if photo['name'] == "Profile Pictures"
        full_photo = open_json "https://graph.facebook.com/#{photo['id']}/photos?access_token=#{session[:access_token]}"
        return full_photo['data'].first['source']
      end
    end
  end

  def open_json(uri)
    result = nil
    3.times do
      begin
        result = ActiveSupport::JSON.decode open(uri)
      rescue Errno::ECONNRESET; result = nil end
      if result; break end
    end
    result
  end
end