class RemoveUniqueIndexFromPrimaryPhoneOnClients < ActiveRecord::Migration[8.1]
  def change
    remove_index :clients, :primary_phone, if_exists: true
    add_index :clients, :primary_phone unless index_exists?(:clients, :primary_phone)
  end
end
