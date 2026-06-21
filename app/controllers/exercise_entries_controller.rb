class ExerciseEntriesController < ApplicationController
  before_action :set_exercise_entry, only: %i[ edit update destroy ]
  before_action :set_date, only: %i[ index ]

  def index
    @exercise_entries = Current.user.exercise_entries.on_date(@date).order(:id)
    @daily_total = Current.user.exercise_calories_burned_on(@date)
  end

  def new
    @recorded_on = params[:recorded_on]&.to_date || Date.current
    @exercise_templates = Current.user.exercise_templates.alphabetical
    @rows = batch_rows_from_params.presence || [ default_row ]
  end

  def create
    @recorded_on = batch_params[:recorded_on]&.to_date || Date.current
    @exercise_templates = Current.user.exercise_templates.alphabetical
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

    ExerciseEntry.transaction { @entries.each(&:save!) }
    redirect_to exercise_entries_path(date: @recorded_on),
                notice: t(".created", count: @entries.size)
  end

  def edit
  end

  def update
    if @exercise_entry.update(exercise_entry_params)
      redirect_to exercise_entries_path(date: @exercise_entry.recorded_on), notice: t(".updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    date = @exercise_entry.recorded_on
    @exercise_entry.destroy!
    redirect_to exercise_entries_path(date: date), notice: t(".destroyed")
  end

  private
    def set_exercise_entry
      @exercise_entry = Current.user.exercise_entries.find(params[:id])
    end

    def set_date
      @date = params[:date].presence&.to_date || Date.current
    end

    def exercise_entry_params
      params.require(:exercise_entry).permit(:recorded_on, :name, :calories_burned, :duration_minutes)
    end

    def batch_params
      params.fetch(:exercise_entry_batch, {}).permit(:recorded_on, rows: [ :name, :calories_burned, :duration_minutes ])
    end

    def batch_rows_from_params
      Array(batch_params[:rows]).map do |row|
        row.to_h.symbolize_keys.slice(:name, :calories_burned, :duration_minutes)
      end.reject { |row| row[:name].blank? && row[:calories_burned].blank? }
    end

    def default_row
      { name: "", calories_burned: "", duration_minutes: "" }
    end

    def build_entries_from_rows(rows)
      rows.filter_map do |row|
        next if row[:name].blank?

        Current.user.exercise_entries.build(
          recorded_on: @recorded_on,
          name: row[:name],
          calories_burned: row[:calories_burned],
          duration_minutes: row[:duration_minutes].presence
        )
      end
    end
end
