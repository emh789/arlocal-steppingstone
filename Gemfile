source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '>= 3.2'

gem 'bcrypt', '~> 3.1'
gem 'bootsnap', '~> 1.17', require: false    # Reduces boot times through caching; required in config/boot.rb
gem 'coffee-rails', '~> 5.0'
gem 'commonmarker', '~> 0.23'
gem 'devise', '~> 4.9'
gem 'exiftool_vendored', '~> 12.70'
gem 'friendly_id', '~> 5.5', '>= 5.5.1'
gem 'haml', '~> 6.2'
gem 'jquery-rails', '~> 4.6'   # jPlayer requires jquery
gem 'mediainfo', '~> 1.5'
gem 'puma', '~> 6.4'
gem 'rails', '~> 7.1'
gem 'rb-readline', '~> 0.5'
# Sometimes not included in ruby stdlib
# gem 'rexml', '~> 3.2'
gem 'sassc-rails', '~> 2.1'
# A&R.Local still uses Sprockets for javascript asset compilation. There is not enough front-end javascript to justify webpacker.
gem 'sprockets', '~> 4.2'     # A&R.Local requires sprockets version 4
gem 'sqlite3', '~> 1.6'
gem 'turbolinks', '~> 5.2'
gem 'uglifier', '~> 4.2'
gem 'unicorn', '~> 6.1'


group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'web-console', '~> 4'
  gem 'listen', '~> 3.8'
  # Not using Spring
  # (Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring)
  # gem 'spring'
  # gem 'spring-watcher-listen', '~> 2.0'
end

group :test do
  gem 'capybara', '~> 3.39'
  gem 'webdrivers', '~> 5.3'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
