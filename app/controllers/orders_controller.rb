class OrdersController < ApplicationController
  include CurrentCart
  skip_before_action :authorize, only: [:new, :create]
  before_action :set_cart, only: [:new, :create]
  before_action :ensure_cart_isnt_empty, only: [:new]

  def new
  	@order = Order.new
  end

  def create
  	@order = Order.new(order_params)
  	@order.add_item_from_cart(@cart)
  	if @order.save
  		Cart.destroy(session[:cart_id])
  		session[:cart_id] = nil
      OrderMailer.received(@order).deliver_later
  		redirect_to store_index_url, notice: 'Thank you your order has been created.'
  	else
  		render :new
  	end
  end

  private

    def ensure_cart_isnt_empty
    	if @cart.line_items.empty?
    		redirect_to store_index_url, notice: 'Your cart is empty.'
    	end
    end

    def order_params
    	params.required(:order).permit(:name, :email, :address, :pay_type)
    end

end

