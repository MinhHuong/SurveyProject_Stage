class EmployeesController < ApplicationController
  def new
    @employee = Employee.new
  end

  def create
    @employee = Employee.new(employee_params)
  end

  def show
    @employee = User.find(params[:id])
  end

  def edit
    @employee = User.find(params[:id])
  end

  def update
    @employee = User.find(params[:id])
    client = Client.find(@employee.clients_id)
    if @employee.update_attributes(employee_full_params)
      User.upload_file(params[:upload], params[:id], @employee.username, client.name_client)
      session[:name_user] = @employee.firstname + ' ' + @employee.lastname
      render 'show'
    else
      render 'edit'
    end
  end

  def check_password
    @employee = User.find(params[:id])
    old_pwd = params[:oldPwd]
    if @employee.authenticate(old_pwd)
      result = true
    else
      result = false
    end
    render status: 200, json: result.to_json
  end

  private
  def employee_params
    params.require(:employee).permit(:user_id)
  end

    def employee_full_params
      params.require(:user).permit(:firstname, :lastname, :password)
    end
end
