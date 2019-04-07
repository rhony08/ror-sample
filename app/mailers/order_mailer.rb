class OrderMailer < ApplicationMailer
  
  def received(order)
    @order = order

    mail to: @order.email, subject: 'Cilsy Book Store Order Confirmation'
  end

  def shipped
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
