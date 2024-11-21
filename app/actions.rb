# Controller

# Routes/Actions

# when the request comes in for the path '/', send back to the client, the index.html
get '/' do
  @finstagram_posts = FinstagramPost.order(created_at: :desc)
  erb(:index)
end

# handle a GET request for the path '/signup'
get '/signup' do
  @user = User.new
  erb(:signup)
end

# handle a POST request for the path '/signup'
post '/signup' do
  # signup a User (create a User)
  email      = params[:email]
  avatar_url = params[:avatar_url]
  username   = params[:username]
  password   = params[:password]

  @user = User.new({email: email, avatar_url: avatar_url, username: username, password: password})

  # create the record
  if @user.save
    "User #{@user.username} created!"
  else
    erb(:signup)
  end
end