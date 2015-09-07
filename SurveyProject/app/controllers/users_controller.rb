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
          path = '/employee/home'
        when 'leader'
          leader = Leader.new
          leader.user_id = @user.id
          leader.save
          path = '/leader/home'
        else
          path = '/'
      end

      username = @user.username
      client_name = Client.find(@user.clients_id).name_client

      directory = 'public/images/' + client_name + '/users/' + username
      unless File.directory?(directory)
        FileUtils.mkdir_p(directory)
      end

      session[:user_id] = @user.id
      session[:name_user] = @user.firstname + ' ' + @user.lastname
      redirect_to path
    else
      redirect_to '/signup'
    end
  end

  def edit
  end

  def update
  end

  private
  def user_params
    params.require(:user).permit(:firstname, :lastname, :username, :password, :clients_id, :permission)
  end

  def user_employee_params
    params.require(:user).permit(:firstname, :lastname, :password)
  end
end
