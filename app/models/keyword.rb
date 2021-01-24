# == Schema Information
#
# Table name: keywords
#
#  id         :bigint           not null, primary key
#  code       :text
#  keyword    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Keyword < ApplicationRecord
end
