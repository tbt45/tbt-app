class WeightEntriesController < ApplicationController
  before_action :set_weight_entry, only: %i[ edit update destroy ]

  def index
    @weight_entries = Current.user.weight_entries.order(recorded_on: :desc)
  end

  def new
    @weight_entry = Current.user.weight_entries.build(recorded_on: Date.current)
  end

  def create
    @weight_entry = Current.user.weight_entries.build(weight_entry_params)

    if @weight_entry.save
      redirect_to weight_entries_path, notice: t(".created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @weight_entry.update(weight_entry_params)
      redirect_to weight_entries_path, notice: t(".updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @weight_entry.destroy!
    redirect_to weight_entries_path, notice: t(".destroyed")
  end

  private
    def set_weight_entry
      @weight_entry = Current.user.weight_entries.find(params[:id])
    end

    def weight_entry_params
      params.require(:weight_entry).permit(:recorded_on, :weight, :body_fat_percentage)
    end
end
