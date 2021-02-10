class UserController < ApplicationController 
    
    get '/signup' do
        if Helpers.is_logged_in?(session)
         redirect to '/ideas'
        end
    
        erb :"/users/create_user"
      end
    
      post '/signup' do
        params.each do |label, input|
          if input.empty?
            flash[:new_user_error] = "Please enter a value for #{label}"
            redirect to '/signup'
          end
        end
    
        user = User.create(:username => params["username"], :email => params["email"], :password => params["password"])
        session[:user_id] = user.id
    
        redirect to '/ideas'
      end
    
      get '/login' do
        if Helpers.is_logged_in?(session)
          redirect to '/ideas'
        end
    
        erb :"/users/login"
      end
    
      post '/login' do
        user = User.find_by(:username => params["username"])
    
        if user && user.authenticate(params[:password])
          session[:user_id] = user.id
          redirect to '/ideas'
        else
          flash[:login_error] = "Incorrect login. Please try again."
          redirect to '/login'
        end
      end
    
      get '/ideas' do
        if !Helpers.is_logged_in?(session)
          redirect to '/login'
        end
        @ideas = Idea.all
        @user = Helpers.current_user(session)
        erb :"/ideas/ideas"
      end
    
      get '/ideas/new' do
        if !Helpers.is_logged_in?(session)
          redirect to '/login'
        end
        erb :"/ideas/create_idea"
      end
    
      post '/ideas' do
        user = Helpers.current_user(session)
        if params["content"].empty?
          flash[:empty_idea] = "Please enter content for your idea"
          redirect to '/ideas/new'
        end
        idea = Idea.create(:content => params["content"], :user_id => user.id)
    
        redirect to '/ideas'
      end
    
      get '/ideas/:id' do
        if !Helpers.is_logged_in?(session)
          redirect to '/login'
        end
        @idea = Idea.find(params[:id])
        erb :"ideas/show_idea"
      end
    
      get '/ideas/:id/edit' do
        if !Helpers.is_logged_in?(session)
          redirect to '/login'
        end
        @idea = Idea.find(params[:id])
        if Helpers.current_user(session).id != @idea.user_id
          flash[:wrong_user_edit] = "Sorry you can only edit your own ideas"
          redirect to '/ideas'
        end
        
        erb :"ideas/edit_idea"
      end
    
      patch '/ideas/:id' do
        idea = Idea.find(params[:id])
        if params["content"].empty?
          flash[:empty_idea] = "Please enter your idea"
          redirect to "/ideas/#{params[:id]}/edit"
        end
        idea.update(:content => params["content"])
        idea.save
        
        redirect to "/ideas/#{idea.id}"     
      end
    
      post '/ideas/:id/delete' do
        if !Helpers.is_logged_in?(session)
          redirect to '/login'
        end
        @idea = Idea.find(params[:id])
        if Helpers.current_user(session).id != @idea.user_id
          flash[:wrong_user] = "Sorry you can only delete your own ideas"
          redirect to '/ideas'
        end
        @idea.delete
        redirect to '/ideas'
      end
    
      get '/users/:slug' do
        slug = params[:slug]
        @user = User.find_by_slug(slug)
        erb :"users/show_user"
      end
    
      get '/logout' do
        if Helpers.is_logged_in?(session)
          session.clear
          redirect to '/login'
        else
          redirect to '/'
        end
      end
    
end