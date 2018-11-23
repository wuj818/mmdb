module GoogleAnalyticsHelper
  def ga_property_id
    Rails.application.credentials.google_analytics[:property_id]
  end
end
