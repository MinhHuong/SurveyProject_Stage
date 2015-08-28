class User < ActiveRecord::Base
  has_secure_password

  belongs_to :client
  has_one :employee
  has_one :leader

  def self.upload_file(upload, user_id, username, client_name)
    if upload != nil
      name = upload['img'].original_filename
      #extension = File.extname(upload['img'].original_filename)
      #name = 'user_' + user_id + extension
      directory = 'public/images/' + client_name + '/users/' + username
      path = File.join(directory, name)
      File.open(path, 'wb') { |f| f.write(upload['img'].read) }
      path_img = client_name + '/users/' + username + '/' + name
      User.where(:id => user_id).update_all(link_picture: path_img)
    end
  end
end
