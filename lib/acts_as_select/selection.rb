module ActsAsSelect
  def acts_as_select
    column_names.each do |field|
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