# when the request comes in for the path '/', send back to the client, the index.html
get '/' do
  File.read(File.join('app/views', 'index.html'))
end