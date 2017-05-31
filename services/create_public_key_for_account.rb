# frozen_string_literal: true

# Service object to create a new public key for an account
class CreatePublicKeyForAccount
  def self.call(owner_id:, key:, name:)
    public_key = Public_key.new(
      key: key, name: name
    )
    owner = BaseAccount[owner_id]
    public_key.owner = owner
    public_key.save
  end
end
