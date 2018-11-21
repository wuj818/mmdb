class ItemListsController < ApplicationController
  before_action :authorize, only: [:new, :create, :edit, :update, :destroy, :reorder]
  before_action :get_list, only: [:edit, :update, :destroy]

  caches_action :show, expires_in: 2.weeks

  def index
    raise ActiveRecord::RecordNotFound if Rails.env.production?

    @title = 'Lists'

    @lists = ItemList.order(:position)
  end

  def show
    raise ActiveRecord::RecordNotFound if Rails.env.production?

    @list = ItemList.find_by_permalink! params[:id]

    @title = "Lists - #{@list.name}"
  end

  def new
    @title = 'New List'

    @list = ItemList.new
  end

  def edit
    @title = %(Edit "#{@list.name}")
  end

  def create
    @title = 'New List'

    @list = ItemList.new params[:item_list]

    if @list.save
      flash[:success] = %("#{@list.name}" was successfully added.)

      redirect_to @list
    else
      render :new
    end
  end

  def update
    @title = %(Edit "#{@list.name}")

    if @list.update params[:item_list]
      flash[:success] = %("#{@list.name}" was successfully edited.)

      redirect_to @list
    else
      render :edit
    end
  end

  def destroy
    title = @list.name

    @list.destroy

    flash[:success] = %("#{title}" was successfully deleted.)

    redirect_to item_lists_path
  end

  def reorder
    params[:listing].each_with_index do |listing, i|
      Listing.find(listing).update_attribute(:position, i + 1)
    end
  end

  private

  def get_list
    @list = ItemList.find_by_permalink! params[:id]
  end
end
