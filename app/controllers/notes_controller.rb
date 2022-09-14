class NotesController < ApplicationController
  before_action :set_note, only: %i[show edit update destroy]

  def index
    @notes = Note.all.select(:id, :name)
    @note = params[:id] ? Note.find(params[:id]) : Note.order(:order, :created_at).first
  end

  def new
    @note = Note.new
  end

  def create
    @note = Note.new(note_params)
    @note.user_id = current_user.id

    respond_to do |format|
      if @note.save!
        format.turbo_stream
      else
        render :new, status: :unprocessable_entity, notice: 'Something went wrong'
      end
    end
  end

  def show; end

  def edit; end

  def update
    respond_to do |format|
      if @note.update!(note_params)
        format.turbo_stream
      else
        render :edit, status: :unprocessable_entity, notice: 'Something went wrong'
      end
    end
  end

  def destroy
    @note.destroy
  end

  private

  def set_note
    @note = Note.find(params[:id])
  end

  def note_params
    params.require(:note).permit(:name, :content, :order)
  end
end
