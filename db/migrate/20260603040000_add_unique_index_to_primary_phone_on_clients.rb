class AddUniqueIndexToPrimaryPhoneOnClients < ActiveRecord::Migration[8.1]
  def change
    add_index :clients, :primary_phone, unique: true
  end
end
