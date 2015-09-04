require 'json'

class SurveysController < ApplicationController
  before_action :require_employee, only: [:index, :show]

  # Not showing surveys that are already CLOSED
  def index
    @surveys = Survey.all.where(:status => true).includes(:priority, :type_survey, :user).order(:name_survey).group_by{ |survey| survey.name_survey[0] }
    total = Survey.all.where(:status => true).length
    name_list_surveys = 'All surveys'
    @supply_info = {
        total: total,
        name_list_surveys: name_list_surveys,
        filter_criteria: 'Name'
    }
  end

  def filter
    filter_criteria = params[:filter_criteria]
    order_asc_desc = ( filter_criteria == 'date_closed' || filter_criteria == 'created_at' ) ? 'DESC' : 'ASC'
    order_rule = filter_criteria + ' ' + order_asc_desc

    @surveys = Survey.all.where(:status => true).includes(:priority, :type_survey, :user).order(order_rule).group_by do |survey|
      case filter_criteria
        when 'name_survey' then survey.name_survey[0].upcase
        when 'priority_id' then survey.priority.name_priority
        when 'type_survey_id' then survey.type_survey.name_type_survey
        when 'date_closed' then survey.date_closed.strftime('%d-%m-%Y')
        when 'created_at' then survey.created_at.strftime('%d-%m-%Y')
        else survey.name_survey
      end
    end

    @supply_info = {
        total: Survey.all.where(:status => true).length,
        name_list_surveys: 'All surveys',
        filter_criteria: to_readable_name(filter_criteria),
        filter_code: filter_criteria
    }
    render 'index'
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

  private
  def to_readable_name(name)
    case name
      when 'name_survey' then 'Title of survey'
      when 'created_at' then 'Date created'
      when 'date_closed' then 'Date closed'
      when 'status' then 'Status'
      when 'priority_id' then 'Priority'
      when 'type_survey_id' then 'Category'
      else 'Undefined'
    end
  end
end
