# == Schema Information
#
# Table name: products
#
#  id         :integer          not null, primary key
#  name       :string
#  logo_url   :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Product < ApplicationRecord
  validates_presence_of :name, :logo_url
  validates :logo_url, url: { no_local: true }
end
