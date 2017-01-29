require 'sinatra'
require 'data_mapper'

#set :bind, '0,0,0,0'
set :port, '3000'

DataMapper.setup(:default, "sqlite:///#{Dir.pwd}/app.db")

class AllTasks
	# attr_reader :task_name,:completed,:task_id,:urgent,:important
	
	include DataMapper::Resource
	property :task_id, Serial
	property :task_name, String
	property :completed, Boolean
	property :urgent, Boolean
	property :important, Boolean


	# def initialize(task,unique_id)
	# 	@task_name=task
	# 	@task_id=unique_id
	# 	@completed=false
	# 	@urgent=false
	# 	@important=false
	# end 

	# def toggle_task
	# 	@completed=!@completed
	# end

	# def toggle_urgent
	# 	@urgent=!@urgent
	# end

	# def toggle_important
	# 	@important=!@important
	# end
end

DataMapper.finalize
DataMapper.auto_upgrade!

# tasks_array=[]
# unique_id=0

get '/' do
	tasks=AllTasks.all
	erb :users, locals: {:tasks =>tasks}
end

post '/add_task' do
	# # unique_id+=1
	# task_obj=AllTasks.new(params[:task],unique_id)  #Obtaining task from erb file
	# tasks_array<<task_obj
	task_obj=AllTasks.new
	task_obj.task_name = params[:task]
	task_obj.completed = false
	task_obj.important = false
	task_obj.urgent = false
	task_obj.save
	redirect '/'
end

post '/toggle_task' do
	# task_object=nil
	# task_id=params[:task_id]
	# tasks_array.each do |task_obj|
	# 	if task_obj.task_id==task_id.to_i
	# 		task_object=task_obj 
	# 	end
	# end
	# if task_object
	# 	task_object.toggle_task
	# end
	task_id=params[:task_id].to_i
	task_obj=AllTasks.get(task_id)
	task_obj.completed=!task_obj.completed
	task_obj.save
	redirect '/'
end

post '/toggle_important' do
	# task_object=nil
	# task_id=params[:task_id]
	# tasks_array.each do |task_obj|
	# 	if task_obj.task_id==task_id.to_i
	# 		task_object=task_obj 
	# 	end
	# end
	# if task_object
	# 	task_object.toggle_important
	# end
	task_id=params[:task_id].to_i
	task_obj=AllTasks.get(task_id)
	task_obj.important=!task_obj.important
	task_obj.save
	redirect '/'
end

post '/toggle_urgent' do
	# task_object=nil
	# task_id=params[:task_id]
	# tasks_array.each do |task_obj|
	# 	if task_obj.task_id==task_id.to_i
	# 		task_object=task_obj 
	# 	end
	# end
	# if task_object
	# 	task_object.toggle_urgent
	# end
	task_id=params[:task_id].to_i
	task_obj=AllTasks.get(task_id)
	task_obj.urgent=!task_obj.urgent
	task_obj.save
	redirect '/'
end

post '/remove' do
	# unique_id+=1
	# task_object=nil
	# task_id=params[:task_id]
	# tasks_array.each do |task_obj|
	# 	if task_obj.task_id==task_id.to_i
	# 		task_object=task_obj 
	# 	end
	# end
	# if task_object
	# 	tasks_array.delete(task_object)
	# end
	task_id=params[:task_id].to_i
	task_obj=AllTasks.get(task_id)
	task_obj.destroy
	# task_obj.save
	redirect '/'
end
