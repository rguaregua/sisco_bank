class CreateClients < ActiveRecord::Migration[8.1]
  def change
    create_table :clients do |t|
      t.string :type_of_person, null: false
      t.string :type_of_document, null: false
      t.string :document_number, null: false
      t.date :document_issued_at, null: false
      t.date :document_expires_at, null: false
      t.string :full_name, null: false
      t.string :email, null: false
      t.string :primary_phone, null: false
      t.string :secondary_phone
      # Campo estrategico para Soft Delete
      t.datetime :deleted_at

      t.timestamps
    end

    # Restricciones de unicidad e indices de busqueda indexada a nivel BD
    add_index :clients, :document_number, unique: true
    add_index :clients, :email, unique: true
    add_index :clients, :primary_phone
    add_index :clients, :deleted_at
  end
end
