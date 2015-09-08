require 'fileutils'
require 'date'

class Employee::EmployeesController < ApplicationController
  # Show surveys in corresponding widgets
  def index
    # recently created surveys
    recent_created = Survey.recently_created.limit(5)

    # recently done surveys
    recent_done = Survey.recently_done(session[:user_id]).limit(5)

    # high priority surveys
    high_prio = Survey.high_prio.limit(5)

    # surveys that will be closed today
    closed_today = Survey.closed_today.limit(5)

    @content_widgets = {
        recent_created: recent_created,
        high_prio: high_prio,
        closed_today: closed_today,
        recent_done: recent_done
    }
  end

  # display User's profile
  def show
    @employee = User.find(params[:id])
  end

  # show form to edit User's profile
  def edit
    @employee = User.find(params[:id])
  end

  # Update User's profile (including changing password and uploading pictures)
  def update
    @employee = User.find(params[:id])
    client = Client.find(@employee.clients_id)

    if @employee != nil and client != nil
      upload_file(params[:upload], @employee, client.name_client)
    end

    if @employee.update_attributes(employee_full_params)
      session[:name_user] = @employee.firstname + ' ' + @employee.lastname
      url_redirect = '/employee/profile/' << params[:id]
      redirect_to url_redirect
    else
      render 'edit'
    end
  end

  # Check of the old-password is correct
  # If yes, return true
  # If no, return false so the User cannot change to new password
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
  # Full params required to update an Employee
  def employee_full_params
    params.require(:user).permit(:firstname, :lastname, :password)
  end

  # Function that manages the picture uploading
  # Keep original name of the pictures
  # Save it into the right directory, following this rule:
  # <company_name>/users/<username>/
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
