get '/students' do
  @students = Student.all
  @students.each do |s|
    p s.name
    p s.password
  end
  erb :'students/index'
end


get '/students/new' do
  erb :'students/new'
end

post '/students/new' do
  @student = Student.new(params[:student])
  @students = Student.all
  if @student.save
    'yes'
    # @message = "Student added."
    erb :"students/new"
    # erb :"/students/display_emails"
  else
    p 'no'
  #   @errors = @entry.errors.full_messages
  #   erb :'entries/new'
    ##############################
    ### THIS NEEDS TO BE FIXED ###
    ##############################
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
  redirect '/students'

end




