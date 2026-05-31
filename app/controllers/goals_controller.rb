class GoalsController < ApplicationController
  before_action :set_goal, only: %i[ edit update ]

  def index
    @goals = Current.user.goals.latest_first
  end

  def show
    @goal = Current.user.current_goal
  end

  def new
    @goal = Current.user.goals.build(effective_on: Date.current)
  end

  def create
    @goal = Current.user.goals.build(goal_params)

    if @goal.save
      redirect_to goal_path, notice: t(".created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @goal.update(goal_params)
      redirect_to goal_path, notice: t(".updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
    def set_goal
      @goal = Current.user.current_goal
      redirect_to new_goal_path, alert: t("goals.show.empty") if @goal.nil?
    end

    def goal_params
      params.require(:goal).permit(:effective_on, :target_weight, :daily_calorie_target)
    end
end
