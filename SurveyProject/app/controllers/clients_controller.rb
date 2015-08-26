class ClientsController < ApplicationController
  def new
    @client = Client.new
  end

  def create
    @client = Client.new(client_params)
    if @client.save
      redirect_to '/'
    else
      redirect_to 'clients#new'
    end
  end

  private
  def client_params
    params.require(:client).permit(:name_client, :connection_string)
  end
end
