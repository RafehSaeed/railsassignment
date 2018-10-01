class DataEncryptingKey < ActiveRecord::Base

  attr_encrypted :key,
                 key: :key_encrypting_key

  validates :key, presence: true


# returns current primary key
  def self.primary
    find_by(primary: true)
  end

# mergees primary true and key together 
  def self.generate!(attrs={})
    create!(attrs.merge(key: AES.key))
  end

  def rotate_encrypting_key(attrs={})
    sql="select * from data_encrypting_keys";
    records_array = ActiveRecord::Base.connection.execute(sql)
    puts records_array;
  end
  

# uses environment variable to encrypt key 
  def key_encrypting_key
    ENV['KEY_ENCRYPTING_KEY']
  end
end

