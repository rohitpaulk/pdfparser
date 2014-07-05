require 'sinatra'
require 'fileutils'
require 'pdf-reader'
require 'sass'

get '/' do
	haml :home
end

get '/styles.css' do
	scss "scss/main".to_sym
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
	if params[:default]
		@file = "./public/RspecBook.pdf"
	else
		@file = Dir.glob("./tmp/*.pdf").first		
	end
	@reader = PDF::Reader.new(@file)
	haml :analyze	
end