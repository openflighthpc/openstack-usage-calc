require 'sinatra'

class App < Sinatra::Base
  get '/usage/:project' do
    prj = params[:project]

    # Check Project Exists
    if( ! File.file?("project/#{prj}"))
      "Unknown project: #{prj}"
    else
      # Run usage
      `ruby instance_recorder.rb #{prj}`
    end
  end
end
