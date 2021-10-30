class StocksController < ApplicationController
  def search
    if params[:stock].present?
      @stock = Stock.new_lookup(params[:stock])
      if @stock
        respond_to do |format|
          format.js {render partial: 'users/result'}
        end 
      else
        respond_to do |format|
          flash.now[:alert] = "Please enter a valid symbol to search."
          format.js {render partial: 'users/result'}
        end
      end
    else
      respond_to do |format|
        flash.now[:alert] = "Please enter a symbol to search."
        format.js {render partial: 'users/result'}
      end
    end
  end

  def show
    @user = current_user
    @stock = Stock.find(params[:id])
    @client = Stock.iex_client
    @company = @client.company(@stock.ticker)

    @data_keys = [
      "12:00am", "1:00am", "2:00am", "3:00am", "4:00am", "5:00am", "6:00am", "7:00am", "8:00am", 
      "9:00am", "10:00am", "11:00am", "12:00pm", "1:00pm", "2:00pm", "3:00pm", "4:00pm", "5:00pm", "6:00pm",
      "7:00pm", "8:00pm", "9:00pm", "10:00pm", "11:00pm"
    ]

    @data_values = # Each one comes out differently.
    [
      Stock.iex_client.price(@stock.ticker),
      Stock.iex_client.price(@stock.ticker),
      Stock.iex_client.price(@stock.ticker),
      Stock.iex_client.price(@stock.ticker),
      Stock.iex_client.price(@stock.ticker),
      Stock.iex_client.price(@stock.ticker),
      Stock.iex_client.price(@stock.ticker),
      Stock.iex_client.price(@stock.ticker),
      Stock.iex_client.price(@stock.ticker),
      Stock.iex_client.price(@stock.ticker),
      Stock.iex_client.price(@stock.ticker),
      Stock.iex_client.price(@stock.ticker),
      Stock.iex_client.price(@stock.ticker),
      Stock.iex_client.price(@stock.ticker),
      Stock.iex_client.price(@stock.ticker),
      Stock.iex_client.price(@stock.ticker),
      Stock.iex_client.price(@stock.ticker),
      Stock.iex_client.price(@stock.ticker),
      Stock.iex_client.price(@stock.ticker),
      Stock.iex_client.price(@stock.ticker),
      Stock.iex_client.price(@stock.ticker),
      Stock.iex_client.price(@stock.ticker),
      Stock.iex_client.price(@stock.ticker),
      Stock.iex_client.price(@stock.ticker)
    ]

    respond_to do |format|
      format.html {render(:text => "not implemented")} #To bypass chrome restrictions. False render.
      format.js {render partial: 'stocks/stock'}
    end
  end
  
  def destroy
    stock = Stock.find(params[:id])
    user_stock = UserStock.where(user_id: current_user.id, stock_id: stock.id).first
    user_stock.destroy
    flash[:notice] = "#{stock.ticker} (#{stock.name}) was removed from your portfolio."
    redirect_to my_portfolio_path
  end
end