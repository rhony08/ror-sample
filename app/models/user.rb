class User < ApplicationRecord
	after_destroy :ensure_an_admin_remains

  validates :username, presence: true, uniqueness: true
  has_secure_password

  class Error < StandardError;end

  private
    def ensure_an_admin_remains
    	if User.count.zero?
    		raise Error.new "Can't delete last admin."
    	end
    end
end
