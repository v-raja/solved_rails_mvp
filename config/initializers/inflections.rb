# Be sure to restart your server when you modify this file.

# Add new inflection rules using the following format. Inflections
# are locale specific, and you may define rules for as many different
# locales as you wish. All of these examples are active by default:
# ActiveSupport::Inflector.inflections(:en) do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
# end

# These inflection rules are supported but not enabled by default:
# ActiveSupport::Inflector.inflections(:en) do |inflect|
#   inflect.acronym 'RESTful'
# end

ActiveSupport::Inflector.inflections do |inflect|
  inflect.irregular 'niche', 'niches'
  inflect.irregular 'media', 'medias'
end


# encoding: utf-8
class String
  def titleize(options = {})
    exclusions = options[:exclude]

    return ActiveSupport::Inflector.titleize(self) unless exclusions.present?
    self.underscore.humanize.gsub(/\b(['’`]?(?!(#{exclusions.join('|')})\b)[a-z])/) { $&.capitalize }
  end
end

ActsAsTaggableOn.force_lowercase = true
