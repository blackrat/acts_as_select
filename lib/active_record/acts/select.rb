module ActiveRecord
  module Acts
    module Select
      class << self
        def included(base)
          base.extend ClassMethods
        end
      end

      #Acts_as_select allows you to automatically use the columns from an activerecord reference table with a
      #descriptive name and primary key ids
      #It generates XXXX_select method for each permitted column, which maps that column and its primary key
      #to an array suitable for use in an option_select or as a container for options_for_select.

      module ClassMethods
        private
        def allowed_columns(*opts)
          columns=opts[:enabled] || column_names
          columns-=opts[:disabled]
        end

        public
        def acts_as_select(*opts)
          allowed_columns(opts).each do |field|
            class_eval %Q(
                          if Rails::VERSION::MAJOR > 2
                            scope :select_#{field}_objects, lambda {{:select => "#{field}, \#{primary_key}"}}
                          else
                            named_scope :select_#{field}_objects, lambda {{:select => "#{field}, \#{primary_key}"}}
                          end

                          class << self
                            def #{field}_select
                              select_#{field}_objects.map{|x| [x.#{field}, x.send(x.class.primary_key)]}
                            end

                            def #{field}_list
                              select_#{field}_objects.map(&:#{field})
                            end

                            def #{field}_objects
                              select_#{field}_objects.map(&:#{field})
                            end

                          end
                        )
          end
        end
      end

    end
  end
end
