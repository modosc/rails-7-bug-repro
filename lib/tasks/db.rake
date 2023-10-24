require "active_record"

module ActiveRecord::Tasks::DatabaseTasks
  class << self
    def prepare_all
      seed = false

      each_current_configuration env do |db_config|
        ActiveRecord::Base.establish_connection db_config

        begin
          # Skipped when no database
          migrate

          if ActiveRecord.dump_schema_after_migration
            dump_schema db_config, ActiveRecord.schema_format
          end
        rescue ActiveRecord::NoDatabaseError
          create db_config

          if File.exist? schema_dump_path(db_config)
            load_schema(
              db_config,
              ActiveRecord.schema_format,
              nil,
            )
          else
            migrate
          end

          seed = true
        end
      end

      ActiveRecord::Base.establish_connection
      load_seed if seed
    end
  end
end
