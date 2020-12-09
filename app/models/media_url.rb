# == Schema Information
#
# Table name: media_urls
#
#  id               :integer          not null, primary key
#  url              :text
#  gallery_position :integer
#  gallery_id       :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class MediaUrl < ApplicationRecord
  belongs_to :gallery
end
