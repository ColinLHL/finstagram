# helper methods
helpers do
  
  # returns nil or a User object
  def current_user
    User.find_by(id: session[:user_id])
  end

end

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
    redirect to('/login')
  else
    erb(:signup)
  end
end

# handle a GET request for the path '/login'
get '/login' do
  erb(:login)
end

# handle a POST request for the path '/login'
post '/login' do
  username   = params[:username]
  password   = params[:password]

  user = User.find_by(username: username)

  # they are who they say they are
  if user && user.password == password
    # they're authenticated
    session["user_id"] = user.id
    redirect to('/')
  else
    @error_msg = "Login failed"
    erb(:login)
  end
end

# handle a GET request for the path '/login'
get '/logout' do
  session[:user_id] = nil
  redirect to('/')
end

# handle a GET request for the path '/finstagram-posts/new'
get '/finstagram_posts/new' do
  @finstagram_post = FinstagramPost.new
  erb(:'finstagram_posts/new')
end

# handle a GET request for the path '/finstagram-posts/:id'
get '/finstagram_posts/:id' do
  @finstagram_post = FinstagramPost.find(params[:id])
  erb(:'finstagram_posts/show')
end

# handle a POST request for the path '/finstagram-posts'
post '/finstagram_posts' do
  photo_url = params[:photo_url]

  @finstagram_post = FinstagramPost.new({
    photo_url: photo_url,
    user_id: current_user.id
  })

  # create the record
  if @finstagram_post.save
    redirect to('/')
  else
    erb(:'finstagram_posts/new')
  end
end