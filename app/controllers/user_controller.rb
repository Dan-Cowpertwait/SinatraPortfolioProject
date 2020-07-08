class UserController < ApplicationController

	get '/signup' do
			erb :"users/new"
	end

	post '/signup' do
		user = User.new(params)
		if User.all.any?{|user|user.username.downcase == params["username"].downcase}
			flash.next[:error] = "Username already exists!"
			redirect "/signup"
		else
			if user.save
				session[:user_id] = user.id
				flash.next[:greeting] = "Welcome, #{user.username}!"
				redirect '/plant/new'
			else
				flash.next[:error] = "Username, email, and password are required to create an account."
				redirect '/signup'
			end
		end
	end

  get "/login" do
		if logged_in?
			redirect 'home'
		else
    erb :'users/login'
  	end
	end

  post "/login" do
      user = User.find_by(:username => params["username"])

      if user && user.authenticate(params[:password])
        session[:user_id] = user.id
        redirect "home"
      else
        redirect "/signup"
      end
    end


	get '/users/home' do
		if logged_in?
			@user = current_user
			@tasks = Task.all.select{|task| task.user_id == @user.id}
			@plant = Plant.find_by(user_id: session[:user_id])
			# raise @plant.health.inspect
			@days_ago = Date.today.to_time.to_i / (60 * 60 * 24) - @plant.water_date
			plant_still_alive?(@days_ago)
			if @plant.alive? == false
				redirect '/dead'
			else
				if @plant.health < 3 && @plant.health < 6
				@status = "budding!"
				elsif
				@plant.health > 3 && @plant.health < 6
				@status = "growing!"
			elsif @plant.health <= 6
				@status = "blossoming!"
				end
			end
			erb :"/users/home"
		else
			flash.next[:error] = "Please log in"
			redirect '/login'
		end
	end

	get '/users/account' do
		if logged_in?
			@user = current_user
			@tasks = Task.all.select{|task| task.user_id == @user.id}
			@plant = Plant.find_by(user_id: session[:user_id])
		erb :"/users/account"
		else
			flash.next[:error] = "Please log in"
			redirect '/login'
		end
	end

	get '/users/:id' do
		@user = User.find(params[:id])
		erb :"users/show"
	end

	get '/users/:id/edit' do
		@user = User.find(params[:id])
			erb :"users/edit"
	end

	patch '/users/:id' do
		user = User.find(params[:id])
		if user.username != params["username"] && User.all.any?{|user|user.username.downcase == params["username"].downcase}

			flash.next[:error] = "Username Already Exists!"
			redirect "/users/#{user.id}/edit"

		else
			if user.update(:username => params["username"], :password => params["password"])
				flash.next[:message] = "Account successfully edited!"
				redirect "home"
			else
				flash.next[:error] = "Account requires username, and password!"
				redirect "/users/#{user.id}/edit"
			end
		end
	end

	get '/users/:id/delete' do
		@user = User.find(params[:id])
		if @user == current_user
			erb :"users/delete"
		else
			flash.next[:error] = "This ain't your account gardner!"
			redirect "home"
		end
	end


	delete '/users/:id/delete' do
		user = current_user
		raise.user.Quotes
		Quote.find(params[:id])
		user.tasks.destroy_all
		user.plant.destroy
		session.clear
		redirect to '/welcome'
	end

	get '/logout' do
		if logged_in?
			session.clear
			flash.next[:greeting] = "You've been logged out"
			redirect '/welcome'
		else
			flash.next[:greeting] = "You were not logged in"
			redirect '/welcome'
		end
	end


end
