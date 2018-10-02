class EncryptedString < ActiveRecord::Base
  belongs_to :data_encrypting_key

  attr_encrypted :value,
                 mode: :per_attribute_iv_and_salt,
                 key: :encrypted_key

  validates :token, presence: true, uniqueness: true
  validates :data_encrypting_key, presence: true
  validates :value, presence: true

  before_validation :set_token, :set_data_encrypting_key

# returns encrypted key 
  def encrypted_key
    self.data_encrypting_key ||= DataEncryptingKey.primary
    data_encrypting_key.encrypted_key
  end

# re-encrypt existing data
  def self.reencrypt_data

    data_encrypting_key ||= DataEncryptingKey.primary

    EncryptedString.find_each do |estring|
      # store token and value in local variables
      token = estring.token 
      value = estring.value

      params = ActionController::Parameters.new({
        token: token ,
        value: value ,
        data_encrypting_key: data_encrypting_key
      })

      # Delete the string associated with that token  
      sql= '
        DELETE FROM "encrypted_strings" WHERE 
        token = ?;
      '
      query = sanitize_sql([sql, params[:token] ])
      connection.execute(query)
   
      # create an empty store with the token value and encrypt the string using the new key
      sql= '
        INSERT INTO "encrypted_strings" (
            encrypted_value,
            encrypted_value_iv,
            encrypted_value_salt,
            data_encrypting_key_id,
            token,
            created_at,
            updated_at
          ) 
        VALUES (
            null,
            null,
            null,
            ?,
            ?,
            CURRENT_TIMESTAMP ,
            CURRENT_TIMESTAMP
          )
        RETURNING id
        ;
      '
      query = sanitize_sql([sql, params[:data_encrypting_key], params[:token] ])
      result = connection.execute(query)

      # get returned id 
      id = result.to_a[0]["id"]
      EncryptedString.update(id, :value => value);
    end
  end

  private

# gets the encryption key
  def encryption_key
    self.data_encrypting_key ||= DataEncryptingKey.primary
    data_encrypting_key.key
  end

# sets a unique token
  def set_token
    begin
      self.token = SecureRandom.hex
    end while EncryptedString.where(token: self.token).present?
  end

# gets the primary key being used for encryption
  def set_data_encrypting_key
    self.data_encrypting_key ||= DataEncryptingKey.primary
  end

end
