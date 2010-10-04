class SourceAnnotationExtractor
  def find_with_custom_directories
    find_without_custom_directories %w(app lib spec)
  end
  alias_method_chain :find, :custom_directories
end
