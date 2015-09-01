class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by_username(params[:session][:username])
    permission = @user.permission

    if @user && @user.authenticate(params[:session][:password])
      session[:user_id] = @user.id
      session[:name_user] = @user.firstname + ' ' + @user.lastname
      session[:user_permission] = @user.permission
      case permission
        when 'leader'
          redirect_to '/leaders'
        when 'employee'
          redirect_to '/employees'
      end
    else
      redirect_to '/login'
    end
  end

  def destroy
    session[:user_id] = nil
    session[:name_user] = nil
    redirect_to '/'
  end
end
