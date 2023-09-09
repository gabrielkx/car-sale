class Car < ApplicationRecord
  has_many_attached :images

  def thumbnail
    return images.first.variant(resize_to_limit: [100, 100]).processed if images.attached?
  end
end
