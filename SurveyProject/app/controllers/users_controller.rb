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

      # just temporary, I'll rewrite this stupid ass code later
      # the sign up/create new user will be processed automatically (using file)
      # or only the leader has the right to create new users
      case @user.permission
        when 'employee'
          employee = Employee.new
          employee.user_id = @user.id
          employee.save
        when 'leader'
          leader = Leader.new
          leader.user_id = @user.id
          leader.save
      end

      session[:user_id] = @user.id
      redirect_to '/'
    else
      redirect_to '/signup'
    end
  end

  private
  def user_params
    params.require(:user).permit(:firstname, :lastname, :username, :password, :clients_id, :permission)
  end
end
