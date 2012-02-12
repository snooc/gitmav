# coding: utf-8

$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'hallon'

# make sure that we can actually play music
begin
  require 'hallon/openal'
rescue LoadError => e
  puts e.message
  abort "[ERROR] Could not load gem 'hallon-openal', please install with 'gem install hallon-openal'"
end

# load configuration
require_relative 'config.rb'

# create hallon session
session = Hallon::Session.initialize IO.read(ENV['HALLON_APPKEY']) do
  on(:connection_error) do |error|
    Hallon::error.maybe_raise(error)
  end

  on(:logged_out) do
    about "[FAIL] Logged out!"
  end
end

# create hallon player
player = Hallon::Player.new(session, Hallon::OpenAL)

# login
session.login!(ENV['HALLON_USERNAME'], ENV['HALLON_PASSWORD'])

dangerzone = Hallon::Track.new("spotify:track:1GYYqJlTVKrz6NUMbokAYm")
session.wait_for do
  dangerzone.loaded?
end

puts("HIGGGGGGHHHHHWAYYYYY TO THE DANGERZONE!")
player.play!(dangerzone)
