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

  get '/status/:project/:node' do
    prj = params[:project]
    node = params[:node]

    `bash status.sh #{prj} #{node}`
  end

  get '/monitor/:project/:node' do
    prj = params[:project]
    node = params[:node]

    `bash instance_monitor.sh #{prj} #{node}`
  end

  get '/on/:project/:node' do
    prj = params[:project]
    node = params[:node]

    `bash on.sh #{prj} #{node}`
  end

  get '/off/:project/:node' do
    prj = params[:project]
    node = params[:node]

    `bash off.sh #{prj} #{node}`
  end
end
