class User < ActiveRecord::Base
	validates_uniqueness_of :email
	def expire
		expires_at < Time.now
	end
end
