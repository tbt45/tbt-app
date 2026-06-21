class ExerciseTemplatesController < ApplicationController
  before_action :set_exercise_template, only: %i[ edit update destroy ]

  def index
    @exercise_templates = Current.user.exercise_templates.alphabetical
  end

  def new
    @exercise_template = Current.user.exercise_templates.build
  end

  def create
    @exercise_template = Current.user.exercise_templates.build(exercise_template_params)

    if @exercise_template.save
      redirect_to exercise_templates_path, notice: t(".created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @exercise_template.update(exercise_template_params)
      redirect_to exercise_templates_path, notice: t(".updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @exercise_template.destroy!
    redirect_to exercise_templates_path, notice: t(".destroyed")
  end

  private
    def set_exercise_template
      @exercise_template = Current.user.exercise_templates.find(params[:id])
    end

    def exercise_template_params
      params.require(:exercise_template).permit(:name, :calories_burned, :duration_minutes)
    end
end
