#!/usr/bin/env ruby

# https://iiif.lib.harvard.edu/manifests/view/drs:4184689$1i

require 'nokogiri'
require 'json'

doc = File.open("index.html") { |f| Nokogiri::HTML(f) }

urls = doc.css("img.thumbnail-image").collect { |i| i.attributes["data-image-id"].value }

urls.each { |u|
  #  "https://iiif.lib.harvard.edu/manifests/drs:422685711/canvas/canvas-422685735.json"
  id = u.split(/\//).last.gsub(/[^0-9]/, "")
  
  dest = "#{id}.json"
  if ! File.exist?(dest) || File.size(dest) <= 0
    url = "https://ids.lib.harvard.edu/ids/iiif/#{id}/info.json"
    cmd = "curl #{url} > #{dest}"
    puts cmd
    `#{cmd}`
    sleep 3
  end
}


Dir["*.json"].each { |f|
  data = JSON.parse(File.read(f))
  id = f.split(/\./).first
  
  dest = "#{id}.jpg"

  if ! File.exist?(dest) || File.size(dest) <= 0
    #    url = "http://ids.lib.harvard.edu/ids/view/#{id}?width=#{data['width']}&height=#{data['height']}"
    maxWidth = data['maxWidth']
    url = "https://ids.lib.harvard.edu/ids/iiif/#{id}/full/#{maxWidth},/0/default.jpg"
    puts url
    cmd = "curl '#{url}' > #{dest}"

    puts cmd
    `#{cmd}`

    sleep 3
  end
}
