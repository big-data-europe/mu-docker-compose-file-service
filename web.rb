require 'net/http'
require 'json'
# require 'pry'# for breakpoints

###############
#### Calls ####
###############

get '/:id' do
    headers 'Content-Disposition' => "attachment; filename='docker-compose.yml",
            'Content-Type' => 'application/x-yaml'

    id = params[:id].to_s
    log.error('Invalid ID:' + id ) if id.empty?
    error('Invalid ID', status = 400) if id.empty?

    sparql_query = 'select ?content '
    sparql_query += ' where {'
    sparql_query += ' ?composeFile a <http://stackbuilder.semte.ch/vocabularies/core/DockerCompose>;'
    sparql_query += " <http://mu.semte.ch/vocabularies/core/uuid> '#{id}';"
    sparql_query += ' <http://stackbuilder.semte.ch/vocabularies/core/text> ?content.'
    sparql_query += ' }'

    log.info("\n" + sparql_query)

    dockerFile = ""
    query(sparql_query).map do |row|
        dockerFile += row['content'].to_s.gsub('\n', "\n")
    end
    status 200
    dockerFile.to_s
end
