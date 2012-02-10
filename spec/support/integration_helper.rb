module IntegrationHelper
  def integration_login
    visit integration_login_path
  end

  def show
    save_and_open_page
  end

  def should_see(text)
    page.should have_content(text)
  end

  def should_not_see(text)
    page.should have_no_content(text)
  end

  def should_see_link(text, options = {})
    page.should have_link(text, options)
  end

  def should_not_see_link(text, options = {})
    page.should have_no_link(text, options)
  end

  def should_see_field(text, options = {})
    page.should have_field(text, options)
  end

  def should_not_see_field(text, options = {})
    page.should have_no_field(text, options)
  end

  def should_be_on(loc)
    current_path.should == loc
  end

  def should_not_be_on(loc)
    current_path.should_not == loc
  end

  def should_have_css(selector)
    page.should have_css selector
  end

  def should_not_have_css(selector)
    page.should have_no_css selector
  end

  def field(text)
    find_field text
  end

  def link(text)
    find_link text
  end
end

RSpec.configuration.include IntegrationHelper, :type => :request
