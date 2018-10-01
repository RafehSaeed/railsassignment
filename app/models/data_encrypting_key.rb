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

# use this method to rotate the key 
  def self.rotate_encrypting_key(attrs={})
    create!(attrs.merge(key: AES.key))
    records_array = delete_non_primary_keys();

    sql="SELECT * FROM data_encrypting_keys";
    records_array = ActiveRecord::Base.connection.execute(sql)

    puts records_array.to_a
  end

# uses environment variable to encrypt key 
  def key_encrypting_key
    ENV['KEY_ENCRYPTING_KEY']
  end

private
 
# delete all keys other than primary 
  def self.delete_non_primary_keys
    sql="
      DELETE FROM data_encrypting_keys D
      where D.primary = FALSE;
    ";
    records_array = ActiveRecord::Base.connection.execute(sql)
    return records_array
  end

end

