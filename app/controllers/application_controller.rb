require './config/environment'
require "./app/models/user"
require 'sinatra/flash'
require 'sinatra'
require 'date'

class ApplicationController < Sinatra::Base

  configure do
    register Sinatra::ActiveRecordExtension
    register Sinatra::Flash
    enable :sessions
    set :public_folder, 'public'
    set :views, "app/views"
    set :session_secret, "some secret"
  end

  get '/' do
    redirect '/home'
  end

  get '/welcome' do
    erb :welcome
  end

  get '/home' do
    if logged_in?
      redirect '/users/home'
    else
      redirect '/welcome'
    end
  end

  get '/account' do
    if logged_in?
      redirect '/users/account'
    else
      redirect '/welcome'
    end
  end

  not_found do
    status 404
      erb :failure
  end

  helpers do

    def logged_in?
      !!session[:user_id]
    end

    def logout!
      session.clear
    end

    def current_user
      User.find(session[:user_id])
    end

    def water_plant
      @plant = Plant.find_by(user_id: session[:user_id])
      @plant.water_date = Date.today.to_time.to_i / (60 * 60 * 24)
      @plant.health += 1
      @plant.save
    end

    def plant_still_alive?(days_ago)
      @plant = Plant.find_by(user_id: session[:user_id])
      if days_ago >= 3
        @plant.alive = false
      else
        @plant.alive = true
      end
    end

  end



end
