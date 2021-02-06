require 'addressable/uri'

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

  def upvote_count(votable)
    votable.cached_votes_score
    # if votable.class.name == "Solution" || votable.class.name == "Requests"
    #   votable.cached_votes_score
    # else
    #   votable.votes_for.up.by_type(User).size
    # end
  end

  def random_thumbnail_bg_color
    colors = ["E284B3", "FFED8B",  "681313", "F3C1C6",  "735372",  "009975", "FFBD39", "B1E8ED", "52437B", "F76262", "216583", "293462", "DD9D52", "936B93", "6DD38D", "888888", "6F8190", "BCA0F0", "AAF4DD", "96C2ED", "3593CE", "5EE2CD", "96366E", "E38080"]
    colors.sample
  end

  def is_oxro_url?(url)
    Addressable::URI.parse(url).host == "avatar.oxro.io"
  end

  def link_to_add_field(name, f, association, **args)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize, f: builder)
    end
    # byebug
    link_to(name, 'javascript:;', class: "add_fields " + args[:class], data: {id: id, fields: fields.gsub("\n", "")}, id: args[:id])
  end

  def niche_types
    ["Industry", "Occupation"]
  end

  def niche_type
    params[:type] if params[:type].in? niche_types
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
