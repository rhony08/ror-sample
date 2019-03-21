class Cart < ApplicationRecord
	has_many :line_items, dependent: :destroy

	def add_product(product)
		item = line_items.find_by product: product
		if item
			item.quantity += 1
		else
			item = line_items.build(product: product)
		end
		item
	end

end
