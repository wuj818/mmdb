WillPaginate::ViewHelpers.pagination_options[:previous_label] = '&#9668;'
WillPaginate::ViewHelpers.pagination_options[:next_label] = '&#9658;'

module WillPaginate
  module ViewHelpers
    module Base
      def page_entries_info(collection, options = {})
        entry_name = options[:entry_name] || (collection.empty?? 'entry' :
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

        b  = '<b>'
        eb = '</b>'
        sp = '&nbsp;'

        if collection.total_pages < 2
          case collection.size
          when 0; "No #{plural_name} found"
          when 1; "Displaying #{b}1#{eb} #{entry_name}"
          else;   "Displaying #{b}all #{number_with_delimiter collection.size}#{eb} #{plural_name}"
          end
        else
          %{Displaying #{b}%d#{sp}-#{sp}%d#{eb} of #{b}%s#{eb} #{plural_name}} % [
            collection.offset + 1,
            collection.offset + collection.length,
            number_with_delimiter(collection.total_entries)
          ]
        end
      end
    end

    class LinkRendererBase
      def pagination
        items = @options[:page_links] ? windowed_page_numbers : []
        items.push :previous_page
        items.push :next_page
      end
    end

    class LinkRenderer < LinkRendererBase
      private

      def link(text, target, attributes = {})
        if target.is_a? Fixnum
          attributes[:rel] = rel_value(target)
          target = url(target)
        end
        attributes[:href] = target
        tag(:a, text, attributes.merge('data-remote' => true))
      end
    end
  end
end
