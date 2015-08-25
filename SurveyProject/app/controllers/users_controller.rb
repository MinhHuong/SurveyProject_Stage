class UsersController < ApplicationController
  def index
    @company = Client.find(1)
    @employee = Employee.find(1)
    @user = User.find(@employee.id)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to '/'
    else
      redirect_to '/signup'
    end
  end

  private
  def user_params
    params.require(:user).permit(:firstname, :lastname, :username, :password, :clients_id)
  end
end
