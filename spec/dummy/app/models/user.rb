class User < ActiveRecord::Base
  has_many :tray_positions, :order => "position", :include => {:asset => :classifications}
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable #, :lockable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
	devise :database_authenticatable, :trackable, :timeoutable #, :lockable
	attr_accessible :email, :password, :password_confirmation	
end
