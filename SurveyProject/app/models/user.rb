class User < ActiveRecord::Base
  has_secure_password

  belongs_to :client
  has_one :employee
  has_one :leader
end
