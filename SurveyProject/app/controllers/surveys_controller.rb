require 'json'

class SurveysController < ApplicationController
  before_action :require_employee, only: [:index, :show]

  def index
    #@surveys = Survey.includes(:priority, :type_survey, :user).order(:name_survey)
    @surveys = Survey.all.includes(:priority, :type_survey, :user).order(:name_survey).group_by{ |survey| survey.name_survey[0] }
    total = Survey.all.length
    name_list_surveys = 'All surveys'
    filter_criteria = 'Name'
    @supply_info = {
        total: total,
        name_list_surveys: name_list_surveys,
        filter_criteria: filter_criteria
    }
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
