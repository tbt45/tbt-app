class MealEntriesController < ApplicationController
  before_action :set_meal_entry, only: %i[ edit update destroy ]
  before_action :set_date, only: %i[ index summary from_template ]

  def index
    @meal_entries = Current.user.meal_entries.on_date(@date).order(:id)
    @daily_total = Current.user.meal_calories_on(@date)
    @meal_templates = Current.user.meal_templates.alphabetical
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
    @meal_entry = Current.user.meal_entries.build(
      recorded_on: params[:recorded_on]&.to_date || Date.current
    )
  end

  def create
    @meal_entry = Current.user.meal_entries.build(meal_entry_params)

    if @meal_entry.save
      redirect_to meal_entries_path(date: @meal_entry.recorded_on), notice: t(".created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def from_template
    template = Current.user.meal_templates.find(params[:meal_template_id])
    @meal_entry = Current.user.meal_entries.build(
      recorded_on: @date,
      name: template.name,
      calories: template.calories
    )

    if @meal_entry.save
      redirect_to meal_entries_path(date: @date), notice: t(".from_template")
    else
      redirect_to meal_entries_path(date: @date), alert: @meal_entry.errors.full_messages.to_sentence
    end
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
      params.require(:meal_entry).permit(:recorded_on, :name, :calories, :meal_type)
    end
end
