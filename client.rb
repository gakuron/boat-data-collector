# coding: utf-8

require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'json'
require 'uri'

class BoatDataClient

  def get_html(url)
    html = open(url)
    return Nokogiri::HTML(html)
  end
 
  def parse_race_list(date="20161008")
    url = "http://app.boatrace.jp/race/?day=20161008"
    doc = get_html(url)
    list_body = doc.css(".unitRaceInfo tbody")

    races = []
    list_body.css("tr").each do |tr|
      url = "http://app.boatrace.jp#{tr.css(".title a").attr("href").to_s}"
      uri_info = URI::parse(url)
      info = { 
        :base_url => url.split("?")[0],
        :query    => Hash[URI::decode_www_form(uri_info.query)],
        :day      => tr.css(".day").text.strip,
        :title    => tr.css(".title a").text,
        :grade    => tr.css(".grade img").attr("alt").to_s
      }
      races.push info
    end

    prev_path = doc.css(".prev a").css(".txt").attr("href").to_s
    return { :prev => "http://app.boatrace.jp#{prev_path}", :races => races }
  end

  def parse_cup_page()
    url  = "http://app.boatrace.jp/race/13_20160112.php?day=20160117&jyo=13&rno=01&type=before_info" # test
    html = open(url)
    doc  = Nokogiri::HTML(html)
    rounds_num = doc.css(".roundsNav li").count
    title = doc.css(".ttlArea h1").text
    location = doc.css(".ttlArea img").attr("alt").to_s
    res = {
      :rounds   => rounds_num,
      :title    => title,
      :location => location
    }
    #.css(".li").each do |li|
    #  p li
    #end
    p res
  end

  def parse_race_result_page(day, rno)
    
  end

end

c = BoatDataClient.new
p c.parse_race_list

