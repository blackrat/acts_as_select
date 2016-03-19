require (File.join(File.dirname(__FILE__), 'active_record', 'acts', 'select.rb'))
ActiveRecord::Base.send :include, ActiveRecord::Acts::Select