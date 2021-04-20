source ENV['GEM_SOURCE'] || "https://rubygems.org"

def location_for(place)
  if place =~ /^((?:git[:@]|https:)[^#]*)#(.*)/
    [{ :git => $1, :branch => $2, :require => false }]
  elsif place =~ /^file:\/\/(.*)/
    ['>= 0', { :path => File.expand_path($1), :require => false }]
  else
    [place, { :require => false }]
  end
end

gem 'vanagon', git: 'git@github.com:gimmyxd/vanagon.git', branch: 'PA-3570'
gem 'packaging', *location_for(ENV['PACKAGING_LOCATION'] || '~> 0.99.43')
gem 'artifactory'
gem 'rake'
gem 'json'
gem 'octokit'
gem 'rubocop', "~> 0.34.2"

eval_gemfile("#{__FILE__}.local") if File.exist?("#{__FILE__}.local")
