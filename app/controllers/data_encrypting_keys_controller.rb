class DataEncryptingKeysController < ApplicationController

  # Trigger the rotation mechanism here 
  def rotate
    
  	stats = Sidekiq::Stats.new 

    workers = Sidekiq::Workers.new

    puts workers.size
    # also need to make sure that a job is not in progress
  	if stats.enqueued == 0 and workers.size == 0
  		  RotationWorker.perform_async()
  			render json: { message: "Key rotation has been queued"},
	    	status: :success
  	else
  		status()
  	end

  end

  # Return the status here 
  def status

    workers = Sidekiq::Workers.new

  	stats = Sidekiq::Stats.new
  	if stats.enqueued == 0 and workers.size == 0
		  render json: { message: "No key rotation queued or in progress"},
	    status: :unprocessable_entity

    elsif stats.enqueued > 0
      render json: { message: "Key rotation has been queued"},
      status: :unprocessable_entity

    elsif stats.enqueued == 0 and workers.size > 0
      render json: { message: "Key rotation is in progress"},
      status: :unprocessable_entity
    
     end 
    

# 	check to see if job is running if yes send the message that already in progress

	# end

  end
   
end
