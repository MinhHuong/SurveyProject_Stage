require 'fileutils'

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

    if @employee != nil and client != nil
      upload_file(params[:upload], @employee, client.name_client)
    end

    if @employee.update_attributes(employee_full_params)
      session[:name_user] = @employee.firstname + ' ' + @employee.lastname
      url_redirect = '/employees/' << params[:id]
      redirect_to url_redirect
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

  def upload_file(upload, user, client_name)
    if upload != nil
      if user.link_picture != nil
        File.delete('public/images/' << user.link_picture)
      end
      name = upload['img'].original_filename
      directory = 'public/images/' + client_name + '/users/' + user.username
      path = File.join(directory, name)
      File.open(path, 'wb') { |f| f.write(upload['img'].read) }
      path_img = client_name + '/users/' + user.username + '/' + name
      User.where(:id => user.id).update_all(link_picture: path_img)
    end
  end
end
