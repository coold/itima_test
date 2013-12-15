class User < ActiveRecord::Base
	has_secure_password

	validates :username, presence: true, uniqueness: { case_sensitive: false }, length: {maximum: 20}
	validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
	before_create { generate_token(:auth_token)}
	
	def generate_token(column)
		begin
			self[column]= SecureRandom.urlsafe_base64
		end while User.exists?(column => self[column])
	end
	
end
