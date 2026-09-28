# [згенеровано] rails g model BookAuthor book:references author:references
# [власний код] унікальність пари книга–автор
class BookAuthor < ApplicationRecord
  belongs_to :book
  belongs_to :author

  validates :author_id, uniqueness: { scope: :book_id }
end
