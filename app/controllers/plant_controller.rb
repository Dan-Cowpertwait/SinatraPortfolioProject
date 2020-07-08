class PlantController < ApplicationController

  get '/plant/new' do
			erb :"plants/new"
	end

  post '/plant' do
    plant = Plant.new(params)
    plant.health = 1
    plant.user = current_user
    plant.water_date = Date.today.to_time.to_i / (60 * 60 * 24)
    plant.alive = true
    plant.save
    redirect 'home'
  end

  get '/dead' do
    erb :'/plants/dead'
  end

  get 'dead/new' do
    @plant = Plant.find_by(user_id: session[:user_id])
    plant.destroy
    erb :'/plant/new'
  end




end
