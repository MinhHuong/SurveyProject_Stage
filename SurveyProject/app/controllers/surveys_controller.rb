class SurveysController < ApplicationController
  before_action :require_employee, only: [:index, :show]

  def index
    @surveys = Survey.includes(:priority, :type_survey, :user)
  end

  def show
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
