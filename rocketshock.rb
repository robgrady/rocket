require 'rubygems'
require 'sinatra'
require 'dm-core'
require 'dm-timestamps'
require 'dm-migrations'
# require 'dm-sqlite-adapter'

#DataMapper::setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/rocketserver.db")
#DataMapper.setup(:default, ENV['DATABASE_URL'] || 'postgres://localhost/rocketserver.db')
DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/rocketserver.db")
class Rocket  
  include DataMapper::Resource 

  property :id,        Serial
  property :title,     String
  property :description,   Text
  property :originator, String
  property :url,       String
  property :is_active, Boolean
  property :created_at, DateTime
  property :updated_at, DateTime

end

# Create or update all tables
DataMapper.auto_upgrade!

before do
  headers "Content-Type" => "text/html; charset=utf-8"
end

# View the Home Page
get '/' do 
  @title= "Welcome to Rocketshock" 
  erb :home
end

# View a Rocket
get '/rocket/:id' do
  @rocket = Rocket.get(params[:id])
  erb :rocket
end

# View the Biz Page
get '/biz' do
  @title= "Business Design Diagram"
  erb :biz_design
end

get '/show/:id' do
  @rocket = Rocket.get(params[:id])
  if @rocket
    erb :show
  else
    redirect('/list')
  end
end

# List all Rockets
get '/rockets' do
  @title = "All Rockets"
  @rockets = Rocket.all(:order => [:created_at.desc])
  erb :rocket
end

# New Rocket
get '/new' do
  @title = "Record A New Idea"
  erb :new
end

# Create New Rocket
post '/create' do
  @rocket = Rocket.new(params[:rocket])
  if @rocket.save
    redirect "/show/#{@rocket.id}"
  else
    redirect('/list')
  end
end

#Delete Rocket
#get '/delete/:id' do
#  ad = Ad.get(params[:id])
#  path = File.join(Dir.pwd, "/public/ads", ad.filename)
#  File.delete(path)
#  ad.delete unless ad.nil?
#  redirect('list')
#end