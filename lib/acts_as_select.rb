require_relative(File.join('active_record', 'acts', 'select.rb'))
ActiveRecord::Base.send :include, ActiveRecord::Acts::Select