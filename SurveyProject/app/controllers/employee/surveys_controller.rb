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

    data = nil
    name_list_surveys = ''
    case session[:type_list_surveys]
      # all surveys
      when 0
        data = Survey.all
        name_list_surveys = 'All surveys'
      # recently created surveys
      when 1
        now = Date.today
        seven_day_ago = (now - 7)
        data = Survey
                   .where(:status => true)
                   .where(:created_at => seven_day_ago.beginning_of_day..now.end_of_day)
        name_list_surveys = 'Recently created surveys'
      # recently done surveys
      when 2
        # codes
      # high priority surveys
      when 3
        # codes
      # surveys that will be closed today
      when 4
        # codes
      else
        data = Survey.all
        name_list_surveys = 'All surveys'
    end

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
        name_list_surveys: name_list_surveys,
        filter_criteria: to_readable_name(filter_criteria),
        filter_code: filter_criteria
    }
    render 'index'
  end

  # Show survey and all the questions contained within
  def show
  end

  # display all surveys that are recently created
  def index_recently_created
    session[:type_list_surveys] = 1
    index_typed_surveys
  end

  def index_recently_done
    session[:type_list_surveys] = 2
    index_typed_surveys
  end

  def index_typed_surveys
    results = Survey.where(:status => true)
    case session[:type_list_surveys]
      when 1
        now = Date.today
        seven_day_ago = (now - 7)
        results = results
                      .where(:created_at => seven_day_ago.beginning_of_day..now.end_of_day)
        name_list_surveys = 'Recently created surveys'
      when 2
        results = results.where(:id => recently_done_surveys_of(session[:user_id]))
        name_list_surveys = 'Recently done surveys'
      when 3
        name_list_surveys = 'High priority'
      when 4
        name_list_surveys = 'Surveys that will be closed today'
      else
        name_list_surveys = 'All surveys'
    end
    @surveys = results
                   .includes(:priority, :type_survey, :user)
                   .order(:name_survey)
                   .group_by{ |survey| survey.name_survey[0] }
    @supply_info = {
        total: results.length,
        name_list_surveys: name_list_surveys,
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

  def recently_done_surveys_of(user_id)
    now = Date.today
    seven_day_ago = (now - 7)
    items = []
    FinishSurvey
        .where(:user_id => user_id)
        .where(:created_at => seven_day_ago.beginning_of_day..now.end_of_day)
        .each do |item|
      items << item.survey_id
    end
    items
  end
end
