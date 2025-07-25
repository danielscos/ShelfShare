class BooksController < ApplicationController
  before_action :require_login, except: [ :index, :show ]
  before_action :set_book, only: [ :show, :edit, :update, :destroy ]
  before_action :check_book_owner, only: [ :edit, :update, :destroy ]

  def index
    @books = Book.available.includes(:user)
  end

  def show
    # @book is set by before_action
  end

  def new
    @book = @current_user.books.build
  end

  def create
    @book = @current_user.books.build(book_params)

    begin
      if @book.save
        redirect_to @book, notice: "Book '#{@book.title}' was successfully created and is now available for sharing!"
      else
        # log validation errors for debugging
        Rails.logger.warn "Book creation failed: #{@book.errors.full_messages.join(', ')}"

        # render form with errors and proper status code
        flash.now[:alert] = "Please fix the errors below to create your book."
        render :new, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordInvalid => e
      # handle any record invalid exceptions
      flash.now[:alert] = "Failed to create book: #{e.message}"
      render :new, status: :unprocessable_entity
    rescue StandardError => e
      # handle any other unexpected errors
      Rails.logger.error "Unexpected error creating book: #{e.message}"
      flash.now[:alert] = "An unexpected error occurred. Please try again."
      render :new, status: :internal_server_error
    end
  end

  def edit
    # @book is set by before_action
  end

  def update
    begin
      if @book.update(book_params)
        redirect_to @book, notice: "Book '#{@book.title}' was successfully updated!"
      else
        # log validation errors for debugging
        Rails.logger.warn "Book update failed for ID #{@book.id}: #{@book.errors.full_messages.join(', ')}"

        # render form with errors and proper status code
        flash.now[:alert] = "Please fix the errors below to update your book."
        render :edit, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordInvalid => e
      # handle any record invalid exceptions
      flash.now[:alert] = "Failed to update book: #{e.message}"
      render :edit, status: :unprocessable_entity
    rescue ActiveRecord::StaleObjectError
      # handle concurrent modification
      flash.now[:alert] = "This book was modified by someone else. Please reload and try again."
      render :edit, status: :conflict
    rescue StandardError => e
      # handle any other unexpected errors
      Rails.logger.error "Unexpected error updating book ID #{@book.id}: #{e.message}"
      flash.now[:alert] = "An unexpected error occurred. Please try again."
      render :edit, status: :internal_server_error
    end
  end

  def destroy
    begin
      title = @book.title
      if @book.destroy
        redirect_to books_path, notice: "Book '#{title}' was successfully deleted."
      else
        redirect_to @book, alert: "Unable to delete book. Please try again."
      end
    rescue StandardError => e
      Rails.logger.error "Error deleting book ID #{@book.id}: #{e.message}"
      redirect_to @book, alert: "An error occurred while deleting the book."
    end
  end

  private

  def set_book
    @book = Book.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to books_path, alert: "Book not found."
  end

  def check_book_owner
    unless @book.user == @current_user || admin?
      redirect_to books_path, alert: "You can only modify your own books."
    end
  end

  def book_params
    # validate required parameters are present
    params.require(:book).permit(:title, :author, :description, :condition, :available)
  rescue ActionController::ParameterMissing => e
    # handle missing parameters
    Rails.logger.warn "Missing required parameters: #{e.message}"
    redirect_to books_path, alert: "Invalid form submission. Please try again."
  end
end
