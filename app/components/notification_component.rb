# frozen_string_literal: true

# @param type [String] Classic notification type `error`, `alert` and `info` + custom `success`
# @param data [String, Hash] `String` for backward compatibility,
#   `Hash` for the new functionality `{title: '', body: '', timeout: 5, countdown: false, action: { url: '', method: '', name: ''}}`.
#   The `title` attribute for `Hash` is mandatory.
class NotificationComponent < ViewComponent::Base

  def initialize(type:, data:)
    @type = type
    @data = prepare_data(data)
    @svg = svg
    @icon_color_class = icon_color_class

    @data[:timeout] ||= 5
  end

  private

  def svg
    case @type
    when 'success'
      svg_tag "check-circle-medium"
    when 'error'
      svg_tag "exclamation-triangle-medium"
    when 'alert'
      svg_tag "exclamation-circle-medium"
    else
      # 'fa-info-circle'
      svg_tag "information-circle-medium"
    end
  end

  def icon_color_class
    case @type
    when 'success'
      'text-green-400'
    when 'error'
      'text-red-800'
    when 'alert'
      'text-red-400'
    else
      'text-green-400'
    end
  end

  def prepare_data(data)
    case data
    when Hash
      data.deep_symbolize_keys
    else
      { title: data }
    end
  end

  def svg_tag(icon_name, options={})
    file = File.read(Rails.root.join('app', 'assets', 'svgs', "#{icon_name}.svg"))
    doc = Nokogiri::HTML::DocumentFragment.parse file
    svg = doc.at_css 'svg'

    options.each {|attr, value| svg[attr.to_s] = value}

    doc.to_html.html_safe
  end
end
