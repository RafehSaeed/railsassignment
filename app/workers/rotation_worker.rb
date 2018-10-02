class RotationWorker

include Sidekiq::Worker
sidekiq_options retry:false

	def perform()
		DataEncryptingKey.rotate_encrypting_key(primary:true)
		# generate new data encrypting key
		# make the new key primary key
		# Rencrypt all existing data with new key
		# delete old keys 
		
	end



end