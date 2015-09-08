class Employee::SurveysController < ApplicationController
  before_action :require_employee, only: [:index, :show]

  # display all surveys, ordered by Name (default)
  def index
    results = Survey.all
                   .where(:status => true)
    @surveys = results
                   .includes(:priority, :type_survey, :user)
                   .order(:name_survey)
                   .group_by{ |survey| survey.name_survey[0] }
    @supply_info = {
        total: results.length,
        name_list_surveys: 'All surveys',
        filter_criteria: 'Name'
    }
    session[:type_list_surveys] = 0
    render 'index'
  end

  # Filter all surveys based on a selected criteria (chosen from radio button)
  # allow only one criterias, because applying multiple criterias would require to use RECURSIVE function
  # to display data on views, which is very complicated, especially when we use web components
  def filter
    filter_criteria = params[:filter_criteria]
    order_asc_desc = ( filter_criteria == 'date_closed' || filter_criteria == 'created_at' ) ? 'DESC' : 'ASC'
    order_rule = filter_criteria + ' ' + order_asc_desc

    typed_surveys = get_data_of_typed_surveys(session[:type_list_surveys])
    data = typed_surveys[:data]

    @surveys = data.where(:status => true).includes(:priority, :type_survey, :user).order(order_rule).group_by do |survey|
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
        total: data.length,
        name_list_surveys: typed_surveys[:name_list_surveys],
        filter_criteria: to_readable_name(filter_criteria),
        filter_code: filter_criteria
    }
    render 'index'
  end

  # Show survey and all the questions contained within
  def show
    @survey = Survey.includes(:user, :priority, :type_survey).find(params[:id])
  end

  def index_typed_surveys
    typed_surveys = get_data_of_typed_surveys(params[:type])
    results = typed_surveys[:data]
    @surveys = results
                   .includes(:priority, :type_survey, :user)
                   .order(:name_survey)
                   .group_by{ |survey| survey.name_survey[0] }
    @supply_info = {
        total: results.length,
        name_list_surveys: typed_surveys[:name_list_surveys],
        filter_criteria: 'Name'
    }
    render 'index'
  end

  private
  # Change code of filter to some readable name
  # eg: name --> Name, dateclosed --> Date closed
  # used to displat the selected critaria in views
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

  def get_data_of_typed_surveys(type)
    case type
      when '0'
        data = Survey.opened
        name_list = 'All surveys'
        session[:type_list_surveys] = '0'
      when '1'
        data = Survey.recently_created
        name_list = 'Recently created surveys'
        session[:type_list_surveys] = '1'
      when '2'
        data = Survey.recently_done(session[:user_id])
        name_list = 'Recently done surveys'
        session[:type_list_surveys] = '2'
      when '3'
        data = Survey.high_prio
        name_list = 'High priority surveys'
        session[:type_list_surveys] = '3'
      when '4'
        data = Survey.closed_today
        name_list = 'Surveys that will be closed today'
        session[:type_list_surveys] = '4'
      else
        data = Survey.opened
        name_list = 'All surveys'
    end

    results = {
        data: data,
        name_list_surveys: name_list
    }
  end
end
