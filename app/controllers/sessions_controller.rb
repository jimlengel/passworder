# go to log in page
get '/sessions/new' do
  erb :'sessions/new'
end

# create the session
post '/sessions' do
  @user = User.find_by(username: params[:username])
  if @user && @user.password == params[:password]
    session[:id] = @user.id
    redirect "/users/#{@user.id}"
  else
    @errors = ["Username and/or password not found"]
    erb :'/sessions/new'
  end
end

# delete the session
delete '/sessions' do
  session[:id] = nil
  redirect '/'
end