require 'fileutils'
require 'date'

class UsersController < ApplicationController
  # temporary
  def new
    @user = User.new
  end

  # temporary
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

  def check_password
    _id = session[:user_id].to_i
    @user = User.find(_id)
    old_pwd = params[:oldPwd]
    if @user.authenticate(old_pwd)
      result = true
    else
      result = false
    end
    render status: 200, json: result.to_json
  end

  def show
    _id = session[:user_id].to_i
    @user = User.find(_id)
  end

  def edit
    _id = session[:user_id].to_i
    @user = User.find(_id)
  end

  # Update User's profile (including changing password and uploading pictures)
  def update
    _id = session[:user_id].to_i
    @user = User.find(_id)
    client = Client.find(@user.clients_id)

    if @user != nil and client != nil
      upload_file(params[:upload], @user, client.name_client)
    end

    if @user.update_attributes(user_edit_params)
      session[:name_user] = @user.firstname + ' ' + @user.lastname

      # !!! If using RENDER instead of REDIRECT, there will be problem
      # (request not finishing...I dunno, but use this and problems solved)
      redirect_to '/profile'
    else
      render 'edit'
    end
  end

  private
  def user_params
    params.require(:user).permit(:firstname, :lastname, :username, :password, :clients_id, :permission)
  end

  def user_edit_params
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
