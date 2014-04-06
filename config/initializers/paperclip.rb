Paperclip.interpolates :cdn do |attachment, style|
  "mmdb-cdn#{attachment.original_filename.hash % 4}"
end

module Paperclip
  class Attachment
    def url(style_name = default_style, options = {})
      default_options = { timestamp: false, escape: true }
      result = @url_generator.for(style_name, default_options.merge(options))
      return result if Rails.env.production?
      result.gsub!('-development', '') unless instance.created_at.localtime > STARTUP_TIMESTAMP
      result
    end
  end
end
