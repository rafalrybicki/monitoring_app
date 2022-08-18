class QuotesController < ApplicationController
  before_action :set_quote, except: %i[index new create]

  def index
    @quotes = Quote.all
  end

  def new
    @quote = Quote.new
  end

  def create
    @quote = Quote.new(quote_params)

    respond_to do |format|
      if @quote.save
        format.turbo_stream
        format.html { redirect_to quotes_path }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit; end

  def update
    respond_to do |format|
      if @quote.update!(quote_params)

        format.turbo_stream
        format.html { redirect_to quotes_path }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @quote.delete
  end

  private

  def quote_params
    params.require(:quote).permit(:content, :author)
  end

  def set_quote
    @quote = Quote.find(params[:id])
  end
end
