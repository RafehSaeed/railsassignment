class RotationWorker

include Sidekiq::Worker
sidekiq_options retry:false

def rotateKey()
	# generate new data encrypting key
	# make the new key primary key
	# Rencrypt all existing data with new key
	# delete old keys 
	puts "sidekiq worker rotating key"
end



end