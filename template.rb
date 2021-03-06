remove_file "public/index.html"
#route("root :to => 'usuarios#index'")

say ">> Se modifica el archivo inflections para que se pluralize/singularize en castellano", :blue
copy_file "#{File.dirname(__FILE__)}/files/inflections.rb", "config/initializers/inflections.rb", :force => true

say ">> Se agregan los templates de generación de scaffold modificados", :blue
directory "#{File.dirname(__FILE__)}/files/templates", 'lib/templates'

say ">> Se agrega archivo para internacionalización del proyecto (I18N)", :blue
copy_file "#{File.dirname(__FILE__)}/files/locales/es-AR.yml", 'config/locales/es-AR.yml'
copy_file "#{File.dirname(__FILE__)}/files/locales/devise.es-AR.yml", 'config/locales/devise.es-AR.yml'
application "config.i18n.default_locale = 'es-AR'"

say ">> Se configura el time_zone de Buenos Aires", :blue
application "config.time_zone = 'America/Buenos_Aires'"

say ">> Actualizando e instalando dependencias (bundles)", :blue
gem 'jquery-rails', '>= 0.2.6'
gem 'devise'
gem 'cancan'
gem 'formtastic', :version => "~> 1.2.3"
#if yes?("Desea agregar soporte de slim template engine (http://slim-lang.com/) [y/N]?")
  gem 'slim', :require => 'slim/rails'
#  gem 'slim-rails'
#end
gem 'will_paginate', '~> 3.0.pre2'
gem 'meta_search'
gem "rspec-rails", :group => [:test, :development], :version => "~> 2.4"
run 'bundle install'


# Reemplazo de prototype por jquery
say ">> Reemplazando prototype por jquery (se agrega soporte de jquery-ui)", :blue
generate 'jquery:install --ui -f'
application "config.action_view.javascript_expansions[:defaults] = %w(jquery.min jquery-ui.min rails)"

say ">> Se configura devise", :blue
generate "devise:install"
#generate "scaffold Usuario nombre:string apellido:string email:string"
generate "devise Usuario nombre:string apellido:string email:string"
say ">> Se generar un usuario para acceder al sistema", :blue
email = ask("email para el usuario: ")
password = ask("contraseña: ")
append_to_file 'db/seeds.rb', <<-RUBY
unless usr = Usuario.find_by_email('#{email}')
usr = Usuario.create({:nombre => 'Guest', :apellido => 'Guest',
	:email => '#{email}',
	:password => '#{password}'})
	usr.save
end
RUBY

say ">> Se configura cancan", :blue
file 'app/models/ability.rb', <<-RUBY
# coding: utf-8
class Ability
	include	CanCan::Ability

	def initialize(usuario)
	  can :manage, :all
#		can :read, :all
#		cannot :write, :all
#   alias_action [:index, :show, :search, :recent, :popular], :to => :coolread
  end
end
RUBY

say ">> Se customiza el applications_controller", :blue
copy_file "#{File.dirname(__FILE__)}/files/application_controller.rb", "app/controllers/application_controller.rb", :force => true

say ">> Se configura formtastic", :blue
generate "formtastic:install"

say ">> Se configura rspec"
generate "rspec:install"
#gem("cucumber-rails", :group => "test")

#if yes?("Would you like to install Devise?")
#  gem("devise")
#  model_name = ask("What would you like the user model to be called? [user]")
#  model_name = "user" if model_name.blank?
#  generate("devise:install")
#  generate("devise", model_name)
#end

#config.action_view.javascript_expansions[:defaults] = %w(jquery rails)
rake("db:migrate")
rake("db:seed")

