# when the request comes in for the path '/', send back to the client, the index.html
get '/' do
  @finstagram_posts = FinstagramPost.order(created_at: :desc)

  erb(:index)
end