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
        p student.id
        p "about to assign ..................................."
        student.password = word_list[rand(0..90)] + rand(100..999).to_s
        student.save
        p "student saved ......................................."
      else
        # if there is a password for this student, do not generate one.
        p student.id
        p "did not assign"
      end
    end
    erb :'/students/index'
  else
    p 'THIS STUDENT DID NOT SAVE .............................'
    @errors = @entry.errors.full_messages
  end

end

get '/students/words' do
  #load external file
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

delete '/students/:id' do
  @student = Student.find(params[:id])
  @student.destroy
  @students = Student.all
  erb :'/students/index'
end

post '/students/send' do
  @students = Student.all
  all_students = Student.all
  message = ""
  # message = "Here you go\n"
  all_students.each do |student|
    message += student.name
    message += " = "
    message += student.password
    message += "\n"
  end

  to_number = "+" + params[:text_number].to_s

  account_sid = ENV['account_sid']
  auth_token = ENV['auth_token']
  p account_sid
  p auth_token

  @client = Twilio::REST::Client.new account_sid, auth_token
  message = @client.account.messages.create(:body => message,
    :to => to_number,    # Replace with your phone number
    :from => "+14158516988")  # Replace with your Twilio number
  if message.sid
    @errors = ['Message sent.']
  else
    @errors = ['The message was not sent.']
  end
  p '0000000000000000000000000000000000000000000'
  p @students
  erb :'/students/index'
end




