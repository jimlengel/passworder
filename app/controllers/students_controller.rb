require 'twilio-ruby'

get '/students' do
  @students = Student.all
  erb :'students/index'
end


get '/students/new' do
  erb :'students/new'
end

post '/students/new' do
  @student = Student.new(params[:student])
  @students = Student.all

  if @student.save
    
    word_list = []
    File.open('spelling.txt').each_line do |word|
      p word.chomp
      word_list << word.chomp
    end

    @students.each do |student|
      # if there is no password for this student, generate one.
      if student.password == nil
        student.password = word_list[rand(0..90)] + rand(100..999).to_s
        student.save
      else
        # if there is a password for this student, do not generate one.
      end
    end
    erb :'/students/index'
  else
    @errors = @entry.errors.full_messages
    erb :'/students/new'
  end

end

get '/students/words' do
  # this is not being used. erase it later.
  
  @students = Student.all

  word_list = []
  File.open('spelling.txt').each_line do |word|
    p word.chomp
    word_list << word.chomp
  end

  @students.each do |student|
    if student.password == nil
      p student.id
      p "assigned"
      student.password = word_list[rand(0..90)] + rand(100..999).to_s
      student.save
    else
      p student.id
      p "did not assign"
    end
  end
  erb :'students/new'
end

get '/students/:id' do
  #gets params from url
  @student = Student.find(params[:id])
  erb :'students/show'
end

put '/students/:id' do
  @student = Student.find(params[:id])
  @student.assign_attributes(params[:student])
  if @student.save
    redirect '/students'
  else
    erb :'students/edit'
  end
end

get '/students/:id/info' do
  @student = Student.find(params[:id])
  p "*"*66
  p @student
  if request.xhr?
    erb :'/students/_details', layout: false, locals: { student: @student }
  else
    redirect '/students'
  end
end


delete '/students/:id' do
    @student = Student.find(params[:id])
    @student.destroy
    @students = Student.all
    erb :'/students/index'
end

post '/students/send' do
  @students = Student.all
  all_students = Student.all

  # compose the message
  message = ""
  all_students.each do |student|
    message += student.name
    message += " = "
    message += student.password
    message += "\n"
  end

  to_number = "+" + params[:text_number].to_s
  # send the message using the Twilio credentials
  account_sid = ENV['account_sid']
  auth_token = ENV['auth_token']
  
  @client = Twilio::REST::Client.new account_sid, auth_token
  message = @client.account.messages.create(:body => message,
    :to => to_number,
    :from => "+14158516988") # Twilio number
  if message.sid
    @errors = ['Message sent.']
  else
    @errors = ['The message was not sent.']
  end
    erb :'/students/index'
end




