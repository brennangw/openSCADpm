class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(username: params[:session][:username].downcase)
    if user && user.authenticate(params[:session][:username])
      # Log the user in and redirect to the user's show page.
    else
      flash[:danger] = 'Invalid username or password'
      render 'new'
    end
  end

  def destroy
  end
end
