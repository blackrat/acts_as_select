module ActiveRecord
  module Acts
    module Select
      class << self
        def included(base)
          base.instance_eval do
            extend ClassMethods
          end
        end
      end

      #Acts_as_select allows you to automatically use the columns from an activerecord reference table with a
      #descriptive name and primary key ids
      #It generates XXXX_select method for each permitted column, which maps that column and its primary key
      #to an array suitable for use in an option_select or as a container for options_for_select.

      module ClassMethods
        private
        def default_opts
          {
            :include=>column_names,
            :exclude=>[]
          }
        end

        def allowed_columns(*opts)
          opts=!opts.empty? && opts.first.is_a?(Hash) ? default_opts.merge(opts.first) : default_opts
          opts[:include]=[opts[:include]] if opts[:include].is_a?(String)
          opts[:exclude]=[opts[:exclude]] if opts[:exclude].is_a?(String)
          column_names & (opts[:include]-opts[:exclude])
        end

        public
        def acts_as_select(*opts)
          allowed_columns(*opts).each do |field|
            (class << self;self;end).class_eval do
              define_method "#{field}_select" do
                if respond_to?(:scoped)
                  scoped(:select=>["#{field}, #{primary_key}"])
                else
                  select(field,primary_key)
                end.map{|x| [x.send(field),x.send(primary_key)]}
              end
              define_method "#{field}_list" do
                (respond_to?(:scoped) ? scoped(:select=>[field]) : select(field)).map{|x| x.send(field)}
              end
              define_method "#{field}_objects" do
                respond_to?(:scoped) ? scoped(:select=>[field]) : select(field)
              end
            end
          end
        end
      end
    end
  end
end
