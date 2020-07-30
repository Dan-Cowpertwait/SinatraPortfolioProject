class QuoteController < ApplicationController

  get '/quote' do
    @quote = Quote.all.sample
    erb :'/quotes/new'
  end

  get '/quotes/:id/save' do
    data = Quote.find(params[:id])
    quote = Quote.create(text: data.text, author: data.author, user_id: current_user.id)
    quote.user = current_user
		quote.save
    redirect '/quotes/index'
  end

  get '/quotes/index' do
    @user = current_user
    @userquotes = Quote.all.select{|quote| quote.user_id == @user.id}
    erb :'quotes/index'
  end

  get '/quotes/:id/delete' do
    @quote = Quote.find(params[:id])
    # raise @quote.user_id.inspect
    quote.user_id = 0
    redirect 'home'
  end


end
