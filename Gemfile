# Gemfile for Numatron
source "https://rubygems.org"
if defined? JRuby then
	gem 'therubyrhino'
else
	gem "therubyracer", '~> 0.12.1' # For js modules
	gem 'ruby-lua', :git => 'git://github.com/vifino/ruby-lua.git'
end
gem 'rufus-lua', '~> 1.1.1' # For Lua Modules
gem 'whatlanguage' # For other/language.rb
gem 'geoip' # For geoIP
gem 'nokogiri' # For eval.in
gem 'json' # For multiple things
gem 'dnsruby' # for dns.rb
gem 'programr'
gem 'htmlentities'
gem 'hpricot'
gem 'wikipedia'

# Because (╯°□°）╯︵ ┻━┻ everytime when exception happens.
gem 'table_flipper'
