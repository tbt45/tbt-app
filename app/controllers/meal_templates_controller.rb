class MealTemplatesController < ApplicationController
  before_action :set_meal_template, only: %i[ edit update destroy ]

  def index
    @meal_templates = Current.user.meal_templates.alphabetical
  end

  def new
    @meal_template = Current.user.meal_templates.build
  end

  def create
    @meal_template = Current.user.meal_templates.build(meal_template_params)

    if @meal_template.save
      redirect_to meal_templates_path, notice: t(".created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @meal_template.update(meal_template_params)
      redirect_to meal_templates_path, notice: t(".updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @meal_template.destroy!
    redirect_to meal_templates_path, notice: t(".destroyed")
  end

  private
    def set_meal_template
      @meal_template = Current.user.meal_templates.find(params[:id])
    end

    def meal_template_params
      params.require(:meal_template).permit(:name, :calories)
    end
end
