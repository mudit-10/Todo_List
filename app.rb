require 'sinatra'
require 'data_mapper'

DataMapper.setup(:default, "sqlite:///#{Dir.pwd}/project.db")

set :sessions, true
#set :bind, '0.0.0.0'

class User
	include DataMapper::Resource
	property :id, Serial
	property :email, String
	property :password, String
end

class AllTasks
	include DataMapper::Resource
	property :task_id, Serial
	property :task_name, String
	property :completed, Boolean
	property :important, Boolean
	property :urgent, Boolean
	property :user_id, Integer
end

DataMapper.finalize
User.auto_upgrade!
AllTasks.auto_upgrade!

get '/test' do
	"It Works"
end

#Login, logout

get '/' do
	user = nil
	
	if session[:user_id] 
		user = User.get(session[:user_id])
		# if user!=nil
		# else
		# 	puts "user is empty ********************"
		# end
	else
		redirect '/signin'
	end
	tasks = AllTasks.all(:user_id => user.id)
	erb :index, locals: {user: user, tasks: tasks}
end

get '/signup' do
	erb :signup
end


post '/register' do 
	email = params[:email]
	password = params[:password]

	user = User.all(:email => email).first

	if user
		redirect '/signup'
	else
		user = User.new
		user.email = email
		user.password = password
		user.save
		session[:user_id] = user.id
		redirect '/'
	end

end


post '/logout' do
	session[:user_id] = nil
	redirect '/'
end


get '/signin' do
	erb :signin
end

post '/signin' do

	email = params[:email]
	password = params[:password]

	user = User.all(:email => email).first

	if user
		if user.password == password
			session[:user_id] = user.id
			redirect '/'
		else
			redirect '/signin'
		end

	else
		redirect '/signup'
	end
	redirect '/'
end

#Tasks

post '/add_task' do
	task_name = params[:task_name]
	task = AllTasks.new
	task.task_name = task_name
	task.user_id = session[:user_id]       
	task.completed = false
	task.save
	redirect '/'
end

post '/toggle_task' do 
	task_id = params[:task_id]
	task_obj = AllTasks.get(task_id)
	if task_obj.user_id == session[:user_id]  # So that a user doesn't modify someone else's tasks
		task_obj.completed = !task_obj.completed
		task_obj.save
	end
	redirect '/'
end

post '/toggle_important' do
	task_id = params[:task_id]
	task_obj = AllTasks.get(task_id)
	if task_obj.user_id == session[:user_id]  # So that a user doesn't modify someone else's tasks
		task_obj.important = !task_obj.important
		task_obj.save
	end
	redirect '/'
end

post '/toggle_urgent' do
	task_id=params[:task_id].to_i
	task_obj=AllTasks.get(task_id)
	task_obj.urgent=!task_obj.urgent
	task_obj.save
	redirect '/'
end

post '/remove' do
	task_id=params[:task_id].to_i
	task_obj=AllTasks.get(task_id)
	task_obj.destroy
	redirect '/'
end