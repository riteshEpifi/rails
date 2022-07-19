module ActiveRecord
  module TemporaryConnection # :nodoc:
    def self.for_config(db_config)
      pool = ActiveRecord::Base.connection_handler.establish_connection(db_config, owner_name: self, role: :writing, shard: :default)
      yield pool.connection
    ensure
      pool.connection.discard!
      ActiveRecord::Base.connection_handler.instance_variable_get(:@connection_name_to_pool_manager).delete(self.name)
      nil
    end

    def self.primary_class?
      false
    end

    def self.current_preventing_writes
      false
    end
  end
end
