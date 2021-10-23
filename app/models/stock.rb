class Stock < ApplicationRecord
  has_many :user_stocks
  has_many :users, through: :user_stocks

  validates :name, :ticker, presence: true

  before_save {self.ticker = ticker.upcase}

  def self.iex_client
    IEX::Api::Client.new(publishable_token: Rails.application.credentials.iex_client[:sandbox_api_publishable_key],
                        secret_token: Rails.application.credentials.iex_client[:sandbox_api_secret_key],
                        endpoint: 'https://sandbox.iexapis.com/v1')
  end

  def self.new_lookup(ticker)
    client = self.iex_client
    begin                              
      new(ticker: ticker, name: client.company(ticker).company_name, last_price: client.price(ticker))
    rescue => exception
      return nil
    end
  end

  def self.check_db(ticker)
    where(ticker: ticker).first
  end
end

