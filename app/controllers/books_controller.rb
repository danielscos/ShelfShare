class BooksController < ApplicationController
  before_action :require_login, except: [ :index, :show ]
  before_action :set_book, only: [ :show, :edit, :update, :destroy ]
  before_action :require_owner, only: [ :edit, :update, :destroy ]

  def index
    @books = Book.includes(:user).all
  end

  def show
  end

  def new
    @book = @current_user.books.build
  end

  def create
    @book = @current_user.books.build(book_params)

    if @book.save
      redirect_to @book, notice: "Book was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @book.update(book_params)
      redirect_to @book, notice: "Book was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @book.destroy
    redirect_to books_path, notice: "Book was successfully deleted."
  end

  private

  def set_book
    @book = Book.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to books_path, alert: "Book not found."
  end

  def require_owner
    redirect_to books_path, alert: "Not authorized." unless @book.user == @current_user
  end

  def book_params
    params.require(:book).permit(:title, :author, :description, :condition, :available)
  end
end
