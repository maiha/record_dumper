
directory = File.dirname __FILE__
require "#{directory}/active_record/record_dumper"

ActiveRecord::Base.class_eval do
  include ActiveRecord::RecordDumper
end

