# == Schema Information
#
# Table name: youtube_urls
#
#  id          :bigint           not null, primary key
#  url         :text
#  solution_id :bigint           not null
#  youtube_id  :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class YoutubeUrl < ApplicationRecord
  belongs_to :solution, optional: true, touch: true
  validate :valid_url
  after_validation :set_youtube_id


  private

    def valid_url
      errors.add(:youtube_url, "must be a valid youtube url") unless is_valid(url)
    end

    def is_valid(url)
      /^(http(s)?:\/\/)?((w){3}.)?youtu(be|.be)?(\.com)?\/.+/ === url
    end

    # def is_yt_url?(url)
    #   /^(http(s)?:\/\/)?((w){3}.)?youtu(be|.be)?(\.com)?\/.+/ === url
    # end

    # def is_loom_url?(url)
    #   /^(https:\/\/www.loom.com/share/c4ffd1fd8c9f427dbdc1a04a84197923/
    # end

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
