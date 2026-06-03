class ClientRepository
  def initialize(scope = Client.all)
    @scope = scope
  end

  def filter_and_paginate(params)
    clients = @scope

    if params[:name].present?
      name = ActiveRecord::Base.sanitize_sql_like(params[:name])
      clients = clients.where("full_name ILIKE ?", "%#{name}%")
    end

    clients = clients.where(document_number: params[:document]) if params[:document].present?
    clients = clients.where(type_of_person: params[:type_of_person]) if params[:type_of_person].present?

    clients.order(created_at: :desc).page(params[:page]).per(params[:per_page] || 10)
  end

  def find(id)
    @scope.find(id)
  end

  def create(attributes)
    Client.create(attributes)
  end

  def update(client, attributes)
    client.update(attributes)
  end

  def soft_delete(client)
    client.update(deleted_at: Time.current)
  end
end
