class ListingsController < ApplicationController
  before_filter :authorize
  before_filter :get_list

  def new
    @title = %(New Movie for "#{@list.name}")
    @listing = Listing.new
  end

  def create
    @title = %(New Movie for "#{@list.name}")
    @listing = Listing.new params[:listing]
    @listing.position = @listing.item_list.listings.length + 1

    if @listing.save
      flash[:success] = %("#{@listing.movie.title}" was successfully added to "#{@list.name}".)
      redirect_to @list
    else
      render :new
    end
  end

  def destroy
    @listing = Listing.find params[:id]
    list = @listing.item_list
    movie = @listing.movie.title
    @listing.destroy

    # reorder the listings
    list.listings.each_with_index do |listing, i|
      listing.update_attribute :position, i + 1
    end

    flash[:success] = %("#{movie}" was successfully removed from "#{list.name}".)
    redirect_to @list
  end

  private

  def get_list
    @list = ItemList.find_by_permalink params[:item_list_id]
    raise ActiveRecord::RecordNotFound if @list.blank?
  end
end
