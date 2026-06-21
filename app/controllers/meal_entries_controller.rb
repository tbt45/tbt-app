class MealEntriesController < ApplicationController
  before_action :set_meal_entry, only: %i[ edit update destroy ]
  before_action :set_date, only: %i[ index summary ]

  def index
    @meal_entries = Current.user.meal_entries.on_date(@date).order(:id)
    @daily_total = Current.user.meal_calories_on(@date)
    @calorie_target = Current.user.current_goal&.daily_calorie_target
  end

  def summary
    @daily_total = Current.user.meal_calories_on(@date)
    @weekly_average = Current.user.meal_weekly_average(@date)
    @monthly_average = Current.user.meal_monthly_average(@date)
    @calorie_target = Current.user.current_goal&.daily_calorie_target
    @calorie_gap = Current.user.calorie_gap_to_target(@date)
  end

  def new
    @recorded_on = params[:recorded_on]&.to_date || Date.current
    @meal_templates = Current.user.meal_templates.alphabetical
    @rows = batch_rows_from_params.presence || [ default_row ]
  end

  def create
    @recorded_on = batch_params[:recorded_on]&.to_date || Date.current
    @meal_templates = Current.user.meal_templates.alphabetical
    @rows = batch_rows_from_params
    @entries = build_entries_from_rows(@rows)

    if @entries.empty?
      flash.now[:alert] = t(".empty")
      render :new, status: :unprocessable_entity
      return
    end

    invalid_entries = @entries.reject(&:valid?)
    if invalid_entries.any?
      render :new, status: :unprocessable_entity
      return
    end

    MealEntry.transaction { @entries.each(&:save!) }
    redirect_to meal_entries_path(date: @recorded_on),
                notice: t(".created", count: @entries.size)
  end

  def edit
  end

  def update
    if @meal_entry.update(meal_entry_params)
      redirect_to meal_entries_path(date: @meal_entry.recorded_on), notice: t(".updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    date = @meal_entry.recorded_on
    @meal_entry.destroy!
    redirect_to meal_entries_path(date: date), notice: t(".destroyed")
  end

  private
    def set_meal_entry
      @meal_entry = Current.user.meal_entries.find(params[:id])
    end

    def set_date
      @date = params[:date].presence&.to_date || Date.current
    end

    def meal_entry_params
      params.require(:meal_entry).permit(:recorded_on, :name, :calories, :quantity, :meal_type)
    end

    def batch_params
      params.fetch(:meal_entry_batch, {}).permit(:recorded_on, rows: [ :name, :calories, :quantity ])
    end

    def batch_rows_from_params
      Array(batch_params[:rows]).map do |row|
        row.to_h.symbolize_keys.slice(:name, :calories, :quantity)
      end.reject { |row| row[:name].blank? && row[:calories].blank? }
    end

    def default_row
      { name: "", calories: "", quantity: 1 }
    end

    def build_entries_from_rows(rows)
      rows.filter_map do |row|
        next if row[:name].blank?

        Current.user.meal_entries.build(
          recorded_on: @recorded_on,
          name: row[:name],
          calories: row[:calories],
          quantity: row[:quantity].presence || 1
        )
      end
    end
end
