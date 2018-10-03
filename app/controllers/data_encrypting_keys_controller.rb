class DataEncryptingKeysController < ApplicationController

  # Trigger the rotation mechanism here 
  def rotate
    
  	stats = Sidekiq::Stats.new 
  	if stats.enqueued == 0 
  		  RotationWorker.perform_async()
  			render json: { message: "Key rotation has been queued"},
	    	status: :success
  	else
  		status()
  	end

  end

  # Return the status here 
  def status

  	stats = Sidekiq::Stats.new
  	if stats.enqueued == 0 
		  render json: { message: "No key rotation queued or in progress"},
	    status: :unprocessable_entity

    elsif stats.enqueued > 0
      render json: { message: "Key rotation has been queued"},
      status: :unprocessable_entity
    
     end 
    

# 	check to see if worker running if yes send the message that already in progress
	# workers = Sidekiq::Workers.new
	# workers.each do |_process_id, _thread_id, work|
 #  		p work
	# end

  end
   
end
