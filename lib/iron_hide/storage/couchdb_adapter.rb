require 'multi_json'
require 'iron_hide'
require 'iron_hide/storage'
require 'typhoeus'

module IronHide
  class Storage
    class CouchdbAdapter
      attr_reader :rules

      # @option opts [String] :resource *required*
      # @option opts [String] :action *required*
      # @return [Array<Hash>] array of canonical JSON representation of rules
      def where(opts = {})
        self["#{opts.fetch(:resource)}::#{opts.fetch(:action)}"]
      end

      private
      # Implements an interface that makes selecting rules look like a Hash:
      # @example
      #   {
      #     'com::test::TestResource::read' => {
      #       ...
      #     }
      #   }
      #  adapter['com::test::TestResource::read']
      #  #=> [Array<Hash>]
      #
      # @param [Symbol] val
      # @return [Array<Hash>] array of canonical JSON representation of rules
      def [](val)
        response = couchd_db_rules(val)
        if response.response_code == 200
          MultiJson.load(response.response_body)["rows"].reduce([]) do |rval, row|
            rval << row["value"]
          end
        else
          # Do Something
        end
      end

      def couchd_db_rules(val)
        Typhoeus.get(
          "#{server}/#{database}/_design/rules/_view/resource_rules?key=\"#{val}\""
        )
      end

      def server
        IronHide.configuration.couchdb_server
      end

      def database
        IronHide.configuration.couchdb_database
      end

    end
  end
end

# Add adapter class to IronHide::Storage
IronHide::Storage::ADAPTERS.merge!(couchdb: :CouchdbAdapter)

# Add default configuration variables
IronHide.configuration.add_configuration(couchdb_server: 'http://127.0.0.1:5984',
                                         couchdb_database: 'rules')
