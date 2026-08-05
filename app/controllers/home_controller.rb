class HomeController < ApplicationController
  CHART_DAYS = 29

  def index
    @date = parse_date(params[:date]) || Date.current
    @month = parse_month(params[:month]) || @date.beginning_of_month
    @calorie_period = params[:calorie_period].presence_in(%w[daily weekly]) || "daily"

    user = Current.user
    @goal = user.current_goal
    @latest_weight = user.latest_weight_entry
    @weight_gap = user.weight_gap_to_target
    @intake = user.meal_calories_on(@date)
    @burned = user.exercise_calories_burned_on(@date)
    @balance = user.calorie_balance_on(@date)
    @calorie_target = @goal&.daily_calorie_target
    @calorie_gap = user.calorie_gap_to_target(@date)

    chart_from = @date - CHART_DAYS.days
    @weight_points = user.weight_series(from: chart_from, to: @date)
    intake_totals = MealEntry.daily_totals_for(user, from: chart_from, to: @date)
    burned_totals = ExerciseEntry.daily_totals_for(user, from: chart_from, to: @date)
    @calorie_chart = build_calorie_chart(intake_totals, burned_totals, chart_from, @date)

    month_range = @month.beginning_of_month..@month.end_of_month
    @recorded_dates = user.recorded_dates_in(month_range).to_set
  end

  private
    def parse_date(value)
      return if value.blank?

      Date.parse(value.to_s)
    rescue Date::Error, TypeError
      nil
    end

    def parse_month(value)
      return if value.blank?

      Date.parse("#{value}-01")
    rescue Date::Error, TypeError
      nil
    end

    def build_calorie_chart(intake_totals, burned_totals, from, to)
      if @calorie_period == "weekly"
        weekly_calorie_series(intake_totals, burned_totals, from, to)
      else
        daily_calorie_series(intake_totals, burned_totals, from, to)
      end
    end

    def daily_calorie_series(intake_totals, burned_totals, from, to)
      labels = []
      intake = []
      burned = []

      (from..to).each do |day|
        labels << I18n.l(day, format: :short)
        intake << intake_totals[day].to_i
        burned << burned_totals[day].to_i
      end

      { labels: labels, intake: intake, burned: burned }
    end

    def weekly_calorie_series(intake_totals, burned_totals, from, to)
      weeks = Hash.new { |hash, key| hash[key] = { intake: 0, burned: 0, days: 0 } }

      (from..to).each do |day|
        week_start = day.beginning_of_week
        weeks[week_start][:intake] += intake_totals[day].to_i
        weeks[week_start][:burned] += burned_totals[day].to_i
        weeks[week_start][:days] += 1
      end

      labels = []
      intake = []
      burned = []

      weeks.sort_by(&:first).each do |week_start, values|
        labels << I18n.l(week_start, format: :short)
        intake << (values[:intake].to_f / values[:days]).round
        burned << (values[:burned].to_f / values[:days]).round
      end

      { labels: labels, intake: intake, burned: burned }
    end
end
