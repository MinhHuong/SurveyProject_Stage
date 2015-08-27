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
    if @employee.update_attributes(employee_full_params)
      session[:name_user] = @employee.firstname + ' ' + @employee.lastname
      render 'show'
    else
      render 'edit'
    end
  end

  private
  def employee_params
    params.require(:employee).permit(:user_id)
  end

    def employee_full_params
      params.require(:user).permit(:firstname, :lastname, :password)
    end
end
