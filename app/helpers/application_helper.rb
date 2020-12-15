module ApplicationHelper
  def svg_tag(icon_name, options={})
    file = File.read(Rails.root.join('app', 'assets', 'svgs', "#{icon_name}.svg"))
    doc = Nokogiri::HTML::DocumentFragment.parse file
    svg = doc.at_css 'svg'

    options.each {|attr, value| svg[attr.to_s] = value}

    doc.to_html.html_safe
  end

  def add_class_if_path_is_base(path, class_to_add)
    request.path.start_with?(path) ? class_to_add : ""
  end

  # Get YouTube ID from various YouTube URL
  # https://gist.github.com/eduardinni/ff0011ba8c411fa06253c1d5850373cf
  def get_youtube_id(url)
    var re = /\/\/(?:www\.)?youtu(?:\.be|be\.com)\/(?:watch\?v=|embed\/)?([a-z0-9_\-]+)/i;
    var matches = re.exec(str);
    return matches && matches[1];
    id = ''
    url = url.gsub(/(>|<)/i,'').split(/(vi\/|v=|\/v\/|youtu\.be\/|\/embed\/)/)
    if url[2] != nil
      id = url[2].split(/[^0-9a-z_\-]/i)
      id = id[0];
    else
      id = url;
    end
    id
  end



end

module Haml
  # Haml::AttriubuteParser parses Hash literal to { String (key name) => String (value literal) }.
  module AttributeParser
    class << self
      # @param  [String] exp - Old attributes literal or Hash literal generated from new attributes.
      # @return [Hash<String, String>,nil] - Return parsed attribute Hash whose values are Ruby literals, or return nil if argument is not a single Hash literal.
      def parse(exp)
        return nil unless hash_literal?(exp)

        hash = Hash.new{"\"\""}
        each_attribute(exp) do |key, value|
          if key.in?(['f', 'h', 'smmd', 'sm', 'md', 'lg', 'xl', 'focus', 'hover'])
            # Build up string to insert into class attribute
            tw_classes = value[1..-2]   # Remove the esacped quotes from the original string
                          .split        # Split into array
                          .map{ |clas| "#{attribute_name(key)}:#{clas}" }
                          .join(" ")

            # Insert tw classes string before last escape quote
            hash['class'] = hash['class'].insert(-2, " #{tw_classes}")
            # puts hash
            # raise
          elsif key.in?(['c', 'class', 'sm'])
            hash['class'] = hash['class'].insert(-2, " #{value[1..-2]}")
          else
            hash[key] = value
          end
        end
        hash
      rescue UnexpectedTokenError, UnexpectedKeyError
        nil
      end

      # Returns name of attribute based on first letter if defined, else
      # original string
      def attribute_name(first_letter)
        if first_letter == 'f'
          "focus"
        elsif first_letter == 'h'
          "hover"
        else
          first_letter
        end
      end
    end
  end
end
