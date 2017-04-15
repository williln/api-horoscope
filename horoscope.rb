require 'dotenv'
Dotenv.load
require 'httparty'
require 'oauth'
require 'sinatra'

get '/' do
  random_wiki = HTTParty.get('https://en.wikipedia.org/w/api.php?action=query&list=random&format=json&rnnamespace=0')
  @prediction = random_wiki['query']['random'][0]['title']
  @id = random_wiki['query']['random'][0]['id']
  erb :index
end

post '/status' do
  consumer = OAuth::Consumer.new(ENV['API_KEY'], ENV['API_SECRET'], { site: "https://api.twitter.com", scheme: 'header' })
  token_hash = { oauth_token: ENV['ACCESS_TOKEN'], oauth_token_secret: ENV['ACCESS_TOKEN_SECRET'] }
  request_token  = OAuth::AccessToken.from_hash(consumer, token_hash)
  status = request_token.request(:post, "https://api.twitter.com/1.1/statuses/update.json", status: params[:status])
  redirect to('/')
end