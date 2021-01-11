# == Schema Information
#
# Table name: youtube_urls
#
#  id         :integer          not null, primary key
#  url        :text
#  post_id    :integer          not null
#  youtube_id :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class YoutubeUrl < ApplicationRecord
  belongs_to :post, optional: true
  validate :valid_url
  after_validation :set_youtube_id

  # def self.


  private

    def valid_url
      errors.add(:youtube_url, "must be a valid youtube url") unless is_valid(url)
    end

    def is_valid(yt_url)
      /^(http(s)?:\/\/)?((w){3}.)?youtu(be|.be)?(\.com)?\/.+/ === yt_url
    end

    # Get YouTube ID from various YouTube URL
    # https://gist.github.com/eduardinni/ff0011ba8c411fa06253c1d5850373cf
    def set_youtube_id
      id = ''
      parts = url.gsub(/(>|<)/i,'').split(/(vi\/|v=|\/v\/|youtu\.be\/|\/embed\/)/)
      if parts[2] != nil
        id = parts[2].split(/[^0-9a-z_\-]/i)
        id = id[0];
      else
        id = parts;
      end
      self.youtube_id = id
    end

end
