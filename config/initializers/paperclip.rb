Paperclip.interpolates :cdn do |attachment, style|
  "cdn#{attachment.original_filename.hash % 4}"
end
