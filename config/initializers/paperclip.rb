Paperclip.interpolates :cdn do |attachment, style|
  "cdn#{attachment.original_filename.hash % 4}"
end

module Paperclip
  class Attachment
    def url(style_name = default_style, use_timestamp = @use_timestamp)
      original_filename.nil? ? interpolate(@default_url, style_name) : interpolate(@url, style_name)
    end
  end
end
