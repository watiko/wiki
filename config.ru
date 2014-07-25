#!/usr/bin/env ruby
require 'rubygems'
require 'settingslogic'
require 'gollum/app'

# load auth file
class Settings < Settingslogic
  source "conf.yml"
end

# authentication
module Precious
  class App < Sinatra::Base
    def self.new(*)
      app = Rack::Auth::Digest::MD5.new(super) do |username|
        {Settings.auth.username => Settings.auth.password}[username]
      end
      app.realm = 'Restricted Area'
      app.opaque = ''
      app
    end
  end
end

# git user and email
class Precious::App
  before do
    session['gollum.author'] = {
      :name  => Settings.git.user,
      :email => Settings.git.email,
    }
  end
end

# gollum
gollum_path = File.expand_path(File.dirname(__FILE__)) # CHANGE THIS TO POINT TO YOUR OWN WIKI REPO
Precious::App.set(:gollum_path, gollum_path)
Precious::App.set(:default_markup, :markdown)
Precious::App.set(:wiki_options, {
  :css           => true,
  :live_preview  => false,
  :mathjax       => true,
  :allow_uploads => true,
  :universal_toc => true,
  :user_icons    => 'gravatar',
  :ref           => Settings.git.branch,
})
run Precious::App
