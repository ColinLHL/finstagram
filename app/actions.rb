# helper methods
helpers do
  
  # returns nil or a User object
  def current_user
    User.find_by(id: session[:user_id])
  end

  # if methods end in '?' return a boolean
  def logged_in?
    !!current_user
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

# before the intended route, do this first
before '/finstagram_posts/new' do
  redirect to('/login') unless logged_in?
end

# handle a GET request for the path '/finstagram-posts/new'
get '/finstagram_posts/new' do
  @finstagram_post = FinstagramPost.new
  erb(:'finstagram_posts/new')
end

# handle a GET request for the path '/finstagram-posts/:id'
get '/finstagram_posts/:id' do
  @finstagram_post = FinstagramPost.find_by(id: params[:id])

  if @finstagram_post
    erb(:'finstagram_posts/show')
  else
    halt(404, erb(:'errors/404'))
  end
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

# handle a POST request for the path '/comments'
post '/comments' do
  # point values from params to variables
  text = params[:text]
  finstagram_post_id = params[:finstagram_post_id]

  # instantiate a comment with those values & assign the comment to the `current_user`
  comment = Comment.new({ text: text, finstagram_post_id: finstagram_post_id, user_id: current_user.id })

  # save the comment
  comment.save

  # `redirect` back to wherever we came from
  redirect(back)
end

# handle a POST request for the path '/likes'
post '/likes' do
  # point values from params to variables
  finstagram_post_id = params[:finstagram_post_id]

  # instantiate a comment with those values & assign the comment to the `current_user`
  like = Like.new({ finstagram_post_id: finstagram_post_id, user_id: current_user.id })

  # save the comment
  like.save

  # `redirect` back to wherever we came from
  redirect(back)
end

# handle a DELETE request for the path '/likes/:id'
delete '/likes/:id' do
  like = Like.find(params[:id])
  like.destroy
  redirect(back)
end

before '/profile' do
  redirect to('/login') unless logged_in?
end

get '/profile' do
  @user = User.find_by(id: session[:user_id])
  erb(:profile)
end