require 'sinatra'
require 'fileutils'
require 'pdf-reader'

get '/' do
	haml :home
end

post '/upload' do
	if params[:thepdffile]
		FileUtils.rm_rf("./tmp/.")
		File.open("./tmp/#{params[:thepdffile][:filename]}", 'w') do |f|
    	f.write(params[:thepdffile][:tempfile].read)
  	end
  	redirect '/analyze'
	else
		return "Oopsy, you haven't uploaded a file!"		
	end
end

get '/analyze' do
	if Dir.glob("./tmp/*.pdf").length == 0		
		return "Oopsy, can't find any pdf files. Try <a href='/''>uploading</a> again?"		
	end

	@file = Dir.glob("./tmp/*.pdf").first		
	@reader = PDF::Reader.new(@file)
	haml :analyze	
end