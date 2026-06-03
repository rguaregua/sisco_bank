require "faker"

puts "Poblando base de datos..."
Client.unscoped.destroy_all

15.times do
  issued = Faker::Date.backward(days: 365)

  Client.create!(
    type_of_person: "Natural",
    type_of_document: ["Cedula", "Pasaporte"].sample,
    document_number: "V#{Faker::Number.unique.number(digits: 8)}",
    document_issued_at: issued,
    document_expires_at: issued + 5.years,
    full_name: "#{Faker::Name.first_name} #{Faker::Name.last_name}",
    email: Faker::Internet.unique.email,
    primary_phone: "0414#{Faker::Number.number(digits: 7)}"
  )
end

puts "Seeds completados con exito!"
