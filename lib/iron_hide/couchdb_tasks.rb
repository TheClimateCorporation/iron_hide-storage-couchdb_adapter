require 'couchrest'
require 'typhoeus'
require 'multi_json'

module IronHide
  class CouchDbTasks
    include Rake::DSL if defined? Rake::DSL

    def install_tasks
      namespace :iron_hide do
        # Interface to load some local JSON files to a remote CouchDB server
        #
        # Usage:
        #   bundle exec rake load_rules\['/absolute/path/file.json','http://127.0.0.1:5984/rules'\]
        #
        desc 'Load rules from local JSON file to remote CouchDB server'
        task :load_rules, :file, :db_server do |t, args|
          db    = args[:db_server]
          rules = MultiJson.load(File.open(args[:file]).read)

          # Use the bulk document API
          # See: https://wiki.apache.org/couchdb/HTTP_Bulk_Document_API
          response = Typhoeus.post("#{db}/_bulk_docs",
            body: MultiJson.dump(docs: rules), headers: { "Content-Type" => "application/json" })

          puts "Status: #{response.response_code}\nBody: #{response.body}"
        end

        # Interface to create a CouchDB database if one doesn't exist
        #
        # Usage:
        #   bundle exec rake create_db\['http://127.0.0.1:5984/rules'\]
        #
        desc 'Create a database'
        task :create_db, :db do |t, args|
          CouchRest.database!(args[:db])
        end

        # Interface to create required views on CouchDB server.
        #
        # Usage:
        #   bundle exec rake create_views\['http://127.0.0.1:5984/rules'\]
        #
        desc 'Create a map-reduce view on a CouchDB server to find rules by namespace and resource'
        task :create_views, :db_server do |t, args|
          db       = args[:db_server]
          function = "function(doc) {" \
                    "  doc.action.forEach(function(e) {" \
                    "    if(e && doc.resource){" \
                    "      emit(doc.resource + '::' + e, doc);" \
                    "    }" \
                    "  })" \
                    "};"

          document = {
            "_id" => "_design/rules",
            "views" => {
              "resource_rules" => {
                "map" => function
              }
            }
          }
          response = Typhoeus.post(db,
            body: MultiJson.dump(document), headers: { "Content-Type" => "application/json"} )
          puts "Status: #{response.response_code}\nBody: #{response.body}"
        end
      end
    end
  end
end

IronHide::CouchDbTasks.new.install_tasks
