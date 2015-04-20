class Project < ActiveRecord::Base
  has_many :projects_comments, :dependent => :destroy
  has_many :projects_requests, :dependent => :destroy
  has_many :project_technologies, :dependent => :destroy, :class_name => 'ProjectsTechnology'
  has_many :technologies, :through => :project_technologies
  has_one :client, class_name: "Client", foreign_key: "client_id"

  validates :title, presence: true
  validates :client_id, :numericality => { :greater_than => 0 }
  validates :project_status_id, presence: true, :numericality => { :greater_than => 0 }
  validates :account_manager_user_id, presence: true, :numericality => { :greater_than => 0 }

  def account_manager_email
    @user = User.find_by(:id => account_manager_user_id)
    if !@user.nil?
      @user.username
    end
  end

  def account_manager_name
    @user = User.find_by(:id => account_manager_user_id)
    if !@user.nil?
      @user.first_name + ' ' + @user.last_name
    end
  end

  def production_manager_email
    @user = User.find_by(:id => production_manager_user_id)
    if !@user.nil?
      @user.username
    end
  end

  def project_owner_email
    @user = User.find_by(:id => project_owner_user_id)
    if !@user.nil?
      @user.username
    end
  end

  def project_owner_name
    @user = User.find_by(:id => project_owner_user_id)
    if !@user.nil?
      @user.first_name + ' ' + @user.last_name
    end
  end

  def production_manager_name
    @user = User.find_by(:id => production_manager_user_id)
    if !@user.nil?
      @user.first_name + ' ' + @user.last_name
    end
  end

end
