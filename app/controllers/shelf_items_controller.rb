# [власний код] особисті полиці читача (FR-4.6)
class ShelfItemsController < ApplicationController
  def index
    items = current_user.shelf_items.includes(book: :authors).order(updated_at: :desc)
    @shelves = ShelfItem::SHELF_NAMES.keys.index_with { |shelf| items.select { |i| i.shelf == shelf } }
  end

  # Одна дія і додає книгу на полицю, і переміщує між полицями
  def create
    item = current_user.shelf_items.find_or_initialize_by(book_id: params[:book_id])
    item.shelf = params[:shelf].presence_in(ShelfItem.shelves.keys) || "want"
    item.save!
    redirect_to item.book, notice: "Книгу додано на полицю «#{item.shelf_name}»."
  end

  def destroy
    item = current_user.shelf_items.find(params[:id])
    item.destroy
    redirect_to shelf_items_path, notice: "Книгу прибрано з полиці.", status: :see_other
  end
end
