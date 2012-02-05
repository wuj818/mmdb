module PagesHelper
  def page
    params[:page] || 1
  end

  def per_page
    params[:per_page] || 100
  end

  def page_entries_info(collection, options = {})
    collection_size = collection.total_count
    total_pages = (collection.total_count / per_page.to_f).ceil
    offset = (page.to_i - 1) * per_page.to_i

    entry_name = options[:entry_name] || (collection_size.zero? ? 'entry' :
                 collection.first.class.name.underscore.gsub('_', ' '))

    plural_name = if options[:plural_name]
      options[:plural_name]
    elsif entry_name == 'entry'
      plural_name = 'entries'
    elsif entry_name.respond_to? :pluralize
      plural_name = entry_name.pluralize
    else
      entry_name + 's'
    end

    b = '<strong>'
    eb = '</strong>'
    sp = '&nbsp;'

    if total_pages < 2
      info = case collection_size
      when 0; "No #{plural_name} found"
      when 1; "Displaying #{b}1#{eb} #{entry_name}"
      else; "Displaying #{b}all #{number_with_delimiter collection_size}#{eb} #{plural_name}"
      end
    else
      info = %{Displaying #{plural_name} #{b}%d#{sp}-#{sp}%d#{eb} of #{b}%s#{eb} in total} % [
        offset + 1,
        offset + collection.length,
        number_with_delimiter(collection_size)
      ]
    end

    content_tag :span, info.html_safe, :class => 'page-entries-info'
  end
end
