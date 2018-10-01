class DataEncryptingKeysController < ApplicationController

  # Trigger the rotation mechanism here 
  def rotate
    puts "rotating key"
    ReportWorker.rotateKey()
  end

  # Return the status here 
  def status
      
  end
   
end
