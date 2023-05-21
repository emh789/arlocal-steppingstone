module Arlake::Portfolio


  def self.pull
    puts "Pull portfolio"
    puts Rails.application.config.x.arlocal[:rsync_source_imported_remote_url]
    puts Rails.application.config.x.arlocal[:rsync_source_uploaded_remote_url]
  end
  
  
  def self.push
    puts "Push portfolio"
    puts Rails.application.config.x.arlocal[:rsync_source_imported_remote_url]
    puts Rails.application.config.x.arlocal[:rsync_source_uploaded_remote_url]
  end
  

end
