class DataEncryptingKeysController < ApplicationController

  # Trigger the rotation mechanism here 
  def rotate
    RotationWorker.perform_async()
  end

  # Return the status here 
  def status
    
  end
   
end
