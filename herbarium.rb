#!/usr/bin/env ruby

#https://library.harvard.edu/collections/emily-dickinson-collection

require 'dotenv/load'
require 'mastodon'


client = Mastodon::REST::Client.new(base_url: 'https://botsin.space', bearer_token: ENV['ACCESS_TOKEN'])

data = File.read("data/lines.txt").gsub(/\r/, '').split(/\n\n+/)

img = Dir["data/*.jpg"].sample

puts img

index = rand(data.length)
count = 1 + rand(3)

output = data[index..index+count].join("\n")

puts output


f = File.open(img)
media = client.upload_media(f)
puts media.inspect
client.create_status(output, nil, [ media.id ])
