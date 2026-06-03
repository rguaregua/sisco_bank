class ClientManagementService
  def initialize(repository = ClientRepository.new)
    @repository = repository
  end

  def list_clients(params)
    @repository.filter_and_paginate(params)
  end

  def get_client(id)
    @repository.find(id)
  end

  def create_client(attributes)
    client = Client.new(attributes)
    return client unless client.valid?

    @repository.create(attributes)
  end

  def update_client(id, attributes)
    client = @repository.find(id)
    client.assign_attributes(attributes)
    return client unless client.valid?

    @repository.update(client, attributes)
    client
  end

  def delete_client(id)
    client = @repository.find(id)
    @repository.soft_delete(client)
  end
end
