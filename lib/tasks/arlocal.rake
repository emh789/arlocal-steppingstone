module Arlake
  require_relative 'concerns/arlake_interaction'
  require_relative 'arlake_administrator'
  require_relative 'arlake_initialize'
end


namespace :arlocal do


  namespace :administrator do
    desc 'Edit an administrator account'
    task :edit => :environment do Arlake::Administrator.edit end

    desc 'Delete an administrator account'
    task :delete => :environment do Arlake::Administrator.delete end

    desc 'Index of administrator accounts'
    task :index => :environment do Arlake::Administrator.index end

    desc 'New administrator account'
    task :new => :environment do Arlake::Administrator.new end
  end


  namespace :initialize do
    desc 'Inititalize A&R.local'
    task :all => :environment do Arlake::Initialize.all end

    desc 'Initialize arlocal settings'
    task :settings => :environment do Arlake::Initialize.arlocal_settings end

    desc 'List tasks performed in arlocal:init:all'
    task :tasks do Arlake::Initialize.tasks end
  end


end
