class Product < ApplicationRecord
	before_destroy :ensure_not_referenced_by_any_line_item
	has_many :line_items

	validates :title, :description, :image_url, presence: true
	validates :price, numericality: {greater_than_or_equal_to: 0.01}
	validates_uniqueness_of :title
	validates :image_url, allow_blank: true, format: {
		with: %r{\.(gif|jpg|png)\Z}i,
		message: 'must be a URL for GIF, JPG or PNG image.'
	}

	private

	  def ensure_not_referenced_by_any_line_item
	  	if line_items.present?
	  		errors.add(:base, 'Line Item present')
	  		throw(:abort)
	  	end
	  end
end
