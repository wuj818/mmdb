module Paperclip
  # use production images in development when available
  class UrlGenerator
    def timestamp_as_needed(url, options)
      if @attachment.present? && @attachment.updated_at < STARTUP_TIMESTAMP
        url.gsub '-development', ''
      else
        url
      end
    end
  end
end

Paperclip::UriAdapter.register
Paperclip::HttpUrlProxyAdapter.register

Paperclip::Attachment.default_options.update(
  use_timestamp: false
)

Paperclip.interpolates :asset_default_url do |attachment, style|
  if Rails.env.production?
    ActionController::Base.helpers.asset_path "posters/#{style}-poster.gif"
  else
    "/assets/posters/#{style}-poster.gif"
  end
end
