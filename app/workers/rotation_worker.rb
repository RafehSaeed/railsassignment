class RotationWorker

include Sidekiq::Worker
sidekiq_options retry:false

	def perform()
		puts "Starting Rotation"
		DataEncryptingKey.rotate_encrypting_key(primary:true)		
	end



end