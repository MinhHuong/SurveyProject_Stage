class User < ActiveRecord::Base
  has_secure_password

  belongs_to :client
  has_one :employee
  has_one :leader
  has_many :surveys

  def employee?
    self.permission == 'employee'
  end

  def leader?
    self.permission == 'leader'
  end
end
