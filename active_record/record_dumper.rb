######################################################################
### dump AR objects as source code

module ActiveRecord
  module RecordDumper
    def record_dumper(*args)
      RecordDumper[:create!].new(self, *args)
    end

    class Base
      attr_reader  :klass, :options
      def self.bang() false end

      def column(col, val)
        raise NotImplementedError, "[BUG] #{self.class} should have 'column' method"
      end

      def record
        raise NotImplementedError, "[BUG] #{self.class} should have 'record' method"
      end

      def initialize(record, options = {})
        @klass   = record.class
        @record  = record
        @options = {:delimiter=>"\n",:separater=>"\n\n"}.merge(options)
      end

      def delimiter
        @options[:delimiter]
      end

      def separater
        @options[:separater]
      end

      def bang
        self.class.bang ? '!' : ''
      end

      def max_column_name_size
        @max_column_name_size ||= @klass.column_names.map(&:size).max
      end

      def quote(value)
        case value
        when Time, Date
          "'#{value}'"
        else
          value.inspect
        end
      end

      def columns
        @klass.column_names.map do |key|
          column(key, quote(@record[key]))
        end
      end

      def associations
        case options[:dependent]
        when NilClass      then []
        when Symbol, Array then options[:dependent]
        when TrueClass     then [:has_one, :has_many, :has_and_belongs_to_many]
        else
          raise ArgumentError, "invalid dependent type: %s" %  options[:dependent].class
        end
      end

      def to_s
        buffer = record
        associations.each do |type|
          klass.reflect_on_all_associations(type).each do |association|
            targets = [@record.__send__(association.name)].flatten.compact
            targets.each do |obj|
              string = self.class.new(obj, options).to_s
              buffer << separater << string unless string.blank?
            end
          end
        end
        return buffer
      end

      def method_missing(name, *args)
        RecordDumper[name].new(@record, options)
      end
    end

    class Create < Base
      def column(col, val)
        "  :%-#{max_column_name_size}s => %s" % [col, val]
      end

      def record
        "%s.create%s(#{delimiter}%s#{delimiter})" % [klass, bang, columns.join(",#{delimiter}")]
      end
    end

    class CreateBang < Create
      def self.bang() true end
    end

    class Save < Base
      def column(col, val)
        "record[:%s]%s = %s" % [col, ' '*(max_column_name_size-col.size),  val]
      end

      def record
        "record = %s.new#{delimiter}%s#{delimiter}record.save%s" % [klass, columns.join(delimiter), bang]
      end
    end

    class SaveBang < Save
      def self.bang() true end
    end

    class Sql < Base
      def record
        columns = @record.__send__(:quoted_column_names).join(",#{delimiter}")
        values  = @record.__send__(:attributes_with_quotes).values.join(",#{delimiter}")
        "INSERT INTO %s(#{delimiter}%s#{delimiter}) VALUES (#{delimiter}%s#{delimiter});" % [klass.table_name, columns, values]
      end
    end

    module_function
      def [](key)
        reload if @named_subclasses.blank?
        @named_subclasses[key.to_s] or
          raise NotImplementedError, "doesn't support '#{key}'. Valid methods are #{@named_subclasses.keys.inspect}"
      end

      def reload
        @named_subclasses = Base.__send__(:subclasses).inject({}){|h,k|
          h[k.demodulize.underscore.sub(/_bang$/,'!')] = k.constantize; h}
      end

    reload
  end

end
