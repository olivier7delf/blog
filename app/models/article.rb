class Article < ApplicationRecord
  has_many_attached :photos
  # it create a link
end
