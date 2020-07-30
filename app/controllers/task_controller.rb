class TaskController < ApplicationController

	get '/tasks/new' do
		if logged_in?
			erb :"tasks/new"
		else
			flash.next[:error] = "Gotta log in for that!"
			redirect "/login"
		end
	end

  post '/tasks' do
		user = current_user
		task = Task.new(params, :complete => false)
		task.user = current_user
		task.save
		redirect 'home'
	end

  get '/tasks/:id/edit' do
		@task = Task.find(params[:id])
		user = current_user
		if !logged_in? || @task.user_id != user.id
			flash.next[:error] = "Gotta log in for that!"
			redirect "/login"
		else
			erb :"tasks/edit"
		end
	end

	patch '/tasks/:id' do
		task = Task.find(params[:id])
		task.update(:text => params[:text], :complete => false)
			flash.next[:error] = "Saved!"
			redirect 'home'
	end

	get '/tasks/:id/delete' do
		task = Task.find(params[:id])
		task.destroy
		flash.next[:greeting] = "Deleted!"
		redirect 'home'
	end

	get '/tasks/:id/complete' do
		task = Task.find(params[:id])
		task.destroy
		water_plant
		redirect '/quote'
	end

end
