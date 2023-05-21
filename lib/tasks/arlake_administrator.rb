module Arlake::Administrator


  class NothingToDo < ::StandardError
  end
  

  module_function
  

  def edit
    begin
      id = Arlake::Interaction.ask(question: 'id')
      if id.to_s == ''
        raise NothingToDo
      else
        administrator = Administrator.find_by_id!(id)
      end

      attributes = {}
      attributes.merge! Arlake::Interaction.ask_for_attribute(administrator, :name)
      attributes.merge! Arlake::Interaction.ask_for_attribute(administrator, :email)
      attributes.merge! Arlake::Interaction.ask_for_attribute(administrator, :has_authority_to_write, options: [true,false])
      attributes.merge! Arlake::Interaction.ask_for_password_and_confirm
      if attributes.empty?
        raise NothingToDo
      end
      
      administrator.update!(attributes)
      puts 'Administrator updated.'
      
    rescue ActiveRecord::RecordInvalid
      puts 'Administrator not updated.'
      puts administrator.errors.full_messages
    rescue ActiveRecord::RecordNotFound
      puts "No administrator with id #{id}."
    rescue ActiveRecord::RecordNotSaved
      puts 'Administrator not updated.'
      puts administrator.errors.full_messages
    rescue Arlake::Interaction::PasswordNotConfirmed
      puts 'Administrator not updated.'
      puts 'Passwords did not match'
    rescue NothingToDo
      puts 'Nothing to do.'
    end
  end
  
  
  def delete
    begin
      id = Arlake::Interaction.ask(question: 'id')
      if id.to_s == ''
        raise NothingToDo
      else
        administrator = Administrator.find_by_id!(id)
      end
      
      puts '--------------------------'
      %w(id name email has_authority_to_write).each do |a|
        puts "#{a}: #{administrator.send(a)}"
      end
      puts '--------------------------'

      confirm_delete = Arlake::Interaction.ask(question: 'Delete administrator?', default: 'no', options: ['yes','NO'])            
      if confirm_delete.to_s.downcase == 'yes'
        administrator.destroy!
        puts 'Administrator record was deleted.'
      else
        puts 'Administrator record was not deleted.'
      end
     
    rescue ActiveRecord::RecordNotDestroyed
      puts 'Adminsitrator record could not be deleted.'
    rescue ActiveRecord::RecordNotFound
      puts "No administrator with id #{id}."
    end      
  end
  

  def index
    puts 'Current administrator list'
    Administrator.all.each.map do |administrator|
      puts '--------------------------'
      %w(id name email has_authority_to_write).each do |a|
        puts "#{a}: #{administrator.send(a)}"
      end
    end
  end  
  
  
  def new
    begin
      administrator = Administrator.new
  
      attributes = {}
      attributes.merge! Arlake::Interaction.ask_for_attribute(administrator, :name)
      attributes.merge! Arlake::Interaction.ask_for_attribute(administrator, :email)
      attributes.merge! Arlake::Interaction.ask_for_attribute(administrator, :has_authority_to_write, options: [true,false])
      attributes.merge! Arlake::Interaction.ask_for_password_and_confirm
      if attributes.empty?
        raise NothingToDo
      end

      administrator = Administrator.create(attributes)
      administrator.save!
      puts 'Administrator created.'

    rescue ActiveRecord::RecordInvalid
      puts 'Administrator not created.'
      puts administrator.errors.full_messages
    rescue ActiveRecord::RecordNotSaved
      puts 'Administrator not created.'
      puts administrator.errors.full_messages
    rescue Arlake::Interaction::PasswordNotConfirmed
      puts 'Administrator not updated.'
      puts 'Passwords did not match'
    rescue NothingToDo
      puts 'Nothing to do.'
    end
  end
  

end


