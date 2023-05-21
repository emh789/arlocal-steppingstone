module Arlake::Initialize


  INIT_TASKS = [
    'db:schema:load',
    'arlocal:initialize:settings',
    'arlocal:administrator:new'
  ]


  class NothingToDo < ::StandardError
  end


  module_function  
  

  def all
    puts "\n"
    puts '# A&R.local'
    puts "\n"
    puts '## Initializing'
    puts "\n"
    INIT_TASKS.each do |task|
      puts "#{'###'} #{task}"
      Rake::Task[task].invoke
    end
    puts "\n\n"
    puts '## Done with initialization tasks.'
    puts "\n"
  end
  
  
  def arlocal_settings
    begin
      arlocal_settings = QueryArlocalSettings.get
      if arlocal_settings == nil
        arlocal_settings = ArlocalSettingsBuilder.new.build_and_save_default
      end
      
      attributes = {}
      attributes.merge! Arlake::Interaction.ask_for_attribute(arlocal_settings, :artist_name)
      attributes.merge! Arlake::Interaction.ask_for_attribute(arlocal_settings, :artist_content_copyright_year_earliest)
      attributes.merge! Arlake::Interaction.ask_for_attribute(arlocal_settings, :artist_content_copyright_year_latest, options: ['blank = current year'])
      if attributes.empty?
        raise NothingToDo
      end
      
      arlocal_settings.update!(attributes)
      puts 'A&R.local settings updated.'
      
    rescue ActiveRecord::RecordInvalid
      puts 'A&R.local settings not updated.'
      puts arlocal_settings.errors.full_messages
    rescue ActiveRecord::RecordNotSaved
      puts 'A&R.local settings not updated.'
      puts arlocal_settings.errors.full_messages
    rescue ActiveRecord::StatementInvalid
      puts 'Database entry for A&R.local settings cannot be created.'
      puts 'Has the database been initialized?'
    rescue NothingToDo
      puts 'Nothing to do.'
    end
  end


  def tasks
    puts "\n"
    puts '## Initialization tasks invoked by `rails arlocal:initialize:all`'
    puts "\n"
    INIT_TASKS.each do |task|
      puts "  - #{task}"
    end
    puts "\n"
  end


end
