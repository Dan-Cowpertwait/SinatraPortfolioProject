class User < ActiveRecord::Base
    validates :username, presence: true
    has_secure_password
    has_many :tasks
    has_many :quotes
    has_one :plant
end
