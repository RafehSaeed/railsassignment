require 'test_helper'

class DataEncryptingKeyTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test ".generate!" do
    assert_difference "DataEncryptingKey.count" do
      key = DataEncryptingKey.generate!

      puts key
      assert key
    end
  end

  test "rotate_key" do

      key = DataEncryptingKey.rotate_encrypting_key(primary:true)

      puts key
   
    end

end
