require 'sinatra/base'
require 'json'
require 'nokogiri'
require 'open-uri'


module Application
  class Application < Sinatra::Base

    set :public_folder, File.dirname(__FILE__) + '/public'

    get '/' do
      erb :index
    end

    get '/cms-detect' do
      @result = {}

      url = params['url']
      if !url['http://']
        url = 'http://' + url
      end

      begin
        urlAddr = open(url)
      rescue
        p "error!"
        halt 404
      end

      @result[:site] = url

      doc = Nokogiri::HTML(urlAddr)

      html5 = doc.to_s.split('>')[0]
      if (html5 == '<!DOCTYPE html')
        @result[:html] = "HTML5"
      else
        @result[:html] = "Not HTML5"
      end

      tmp = ''
      doc.css("meta").each do |item|
        if item.attributes["name"]
          if item.attributes["name"].value == "generator"
            tmp = item.attributes["content"].value
          end
        end
      end
      @result[:status] = tmp == '' ? "No CMS Use" : tmp
      @result.to_json

    end
  end
end