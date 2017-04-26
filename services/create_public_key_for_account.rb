# Service object to create a new project for an owner
class CreatePublicKeyForAccount
  def self.call(owner_id:, key:, name:)
    public_key = Public_key.new(
      key: key, name: name
    )
    owner = Account[owner_id]
    public_key.owner = owner
    public_key.save
  end
end
