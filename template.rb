# Reemplazo de prototype por jquery
say "Reemplazando prototype por jquery (se agrega soporte de jquery-ui)", :blue
gem 'jquery-rails', '>= 0.2.6'
generate 'jquery:install --ui -f'
application "config.action_view.javascript_expansions[:defaults] = %w(jquery.min jquery-ui.min rails)"

say "Se modifica el archivo inflections para que se pluralize/singularize en castellano", :blue

append_to_file 'config/initializers/inflections.rb' do
  apply 'https://gist.github.com/838188.txt'
end

gem 'devise'
gem 'cancan'
gem 'formtastic', :version => "~> 1.2.3"
gem 'slim', :require => 'slim/rails'
gem 'slim-rails'
gem 'will_paginate', '~> 3.0.pre2'
gem 'meta_search'

#gem("rspec-rails", :group => "test")
#gem("cucumber-rails", :group => "test")

#if yes?("Would you like to install Devise?")
#  gem("devise")
#  model_name = ask("What would you like the user model to be called? [user]")
#  model_name = "user" if model_name.blank?
#  generate("devise:install")
#  generate("devise", model_name)
#end

#config.action_view.javascript_expansions[:defaults] = %w(jquery rails)

