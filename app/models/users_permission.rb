class UsersPermission < ActiveRecord::Base
  belongs_to :user
  belongs_to :permission
end
