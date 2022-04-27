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
      "12:00am", "6:00am", "12:00pm", "6:00pm",
    ]

    @data_values = # Each one comes out differently.
    [
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