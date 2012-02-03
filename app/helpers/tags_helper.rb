module TagsHelper
  def tag_link(tag, type, options = {})
    type = type.to_s.pluralize
    link_to tag.name, "/#{type}/#{CGI::escape tag.name}", options
  end
end
