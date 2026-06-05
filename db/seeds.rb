puts "Poblando base de datos..."
Client.unscoped.destroy_all

first_names = %w[Carlos Maria Jose Ana Luis Elena Pedro Sofia Miguel Lucia Raul Daniela]
last_names = %w[Perez Gomez Rodriguez Fernandez Morales Ramirez Torres Flores Castillo Vargas]

15.times do
  issued = Date.current - rand(30..365)
  first_name = first_names.sample
  last_name = last_names.sample
  full_name = "#{first_name} #{last_name}"
  doc_number = format("V%08d", rand(10_000_000..99_999_999))
  phone_tail = format("%07d", rand(1_000_000..9_999_999))

  Client.create!(
    type_of_person: "Natural",
    type_of_document: ["Cedula", "Pasaporte"].sample,
    document_number: doc_number,
    document_issued_at: issued,
    document_expires_at: issued + 5.years,
    full_name: full_name,
    email: "#{first_name.downcase}.#{last_name.downcase}.#{rand(1000..9999)}@example.com",
    primary_phone: "0414#{phone_tail}"
  )
end

puts "Seeds completados con exito!"
