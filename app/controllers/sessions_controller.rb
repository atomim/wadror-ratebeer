class SessionsController < ApplicationController
    def new
      # renderöi kirjautumissivun
    end

    def create
      user = User.where(:username => params[:username]).first
      if user.nil? or not user.authenticate params[:password]
        redirect_to signin_path, :notice => "username and password do not match"
      else
        session[:user_id] = user.id
        redirect_to user_path(user), :notice => "Welcome back!"
      end
    end

    def destroy
      # nollataan sessio
      session[:user_id] = nil
      # uudelleenohjataan sovellus pääsivulle
      redirect_to :root
    end
end
