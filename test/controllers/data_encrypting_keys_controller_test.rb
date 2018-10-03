require 'test_helper'

class DataEncryptingKeysControllerTest < ActionController::TestCase
self.use_transactional_fixtures = false

  def setup
    @data_encrypting_key = DataEncryptingKey.generate!(primary: true)

# create 1000 encrypted strings
    1000.times do
      @encrypted_string = EncryptedString.new(value: 'Hello')
      @encrypted_string.save
    end
  end

# rotate the key and decrypt the 1000 strings via that using sidekiq
  test "post_rotate_key" do
      post :rotate
    # DataEncryptingKey.rotate_encrypting_key(primary:true)
  end

end
