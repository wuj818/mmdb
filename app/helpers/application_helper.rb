module ApplicationHelper
  def sort_link(column, title = nil)
    column = column.to_s
    title ||= column.to_s.titleize
    css_class = (column == params[:sort]) ? "current #{params[:order]}" : nil
    order = (column == params[:sort] && params[:order] == 'asc') ? 'desc' : 'asc'
    link_to title, {:sort => column, :order => order}, :class => css_class
  end
end
