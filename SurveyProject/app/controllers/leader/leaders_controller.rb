class Leader::LeadersController < ApplicationController
  def index
  end

  def show
    @leader = User.find(params[:id])
  end

  def edit
    @leader = User.find(params[:id])
  end

  def check_password
    @leader = User.find(params[:id])
    old_pwd = params[:oldPwd]
    if @leader.authenticate(old_pwd)
      result = true
    else
      result = false
    end
    render status: 200, json: result.to_json
  end

  def update
    leader = User.find(params[:id])
    client = Client.find(leader.clients_id)

    if leader != nil and client != nil
      upload_file(params[:upload], leader, client.name_client)
    end

    if leader.update_attributes(leader_full_param)
      session[:name_user] = leader.firstname + ' ' + leader.lastname
      url_redirect = '/leader/profile/' << params[:id]
      redirect_to url_redirect
    else
      render 'edit'
    end
  end

  private
  def leader_full_param
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
