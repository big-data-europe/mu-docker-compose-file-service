require 'net/http'
require 'json'
# require 'pry'# for breakpoints

###############
#### Calls ####
###############

get '/:text' do
    headers 'Content-Disposition' => "attachment; filename='docker-compose.yml",
            'Content-Type' => "application/x-yaml"
    status 200
    "file: " + params[:text].to_s
end
