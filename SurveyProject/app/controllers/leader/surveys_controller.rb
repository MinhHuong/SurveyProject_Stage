class Leader::SurveysController < ApplicationController
  before_action :require_leader

  # display all surveys, ordered by Name (default)
  def index
    results = Survey.all
    @surveys = results
                   .includes(:priority, :type_survey, :user, :finish_surveys)
                   .order(:name_survey)
                   .group_by{ |survey| survey.name_survey[0] }
    @supply_info = {
        total: results.length,
        name_list_surveys: 'All surveys',
        filter_criteria: 'Name'
    }
    render 'index'
  end

  # Filter all surveys based on a selected criteria (chosen from radio button)
  # allow only one criterias, because applying multiple criterias would require to use RECURSIVE function
  # to display data on views, which is very complicated, especially when we use web components
  def filter
    filter_criteria = params[:filter_criteria]
    if filter_criteria == 'status'
      data = Survey.where(:status => true)
      @surveys = {
          'Opened' => data
      }
    else
      order_asc_desc = ( filter_criteria == 'date_closed' || filter_criteria == 'created_at' ) ? 'DESC' : 'ASC'
      order_rule = filter_criteria + ' ' + order_asc_desc

      data = Survey.all

      @surveys = data.includes(:priority, :type_survey, :user).order(order_rule).group_by do |survey|
        case filter_criteria
          when 'name_survey' then survey.name_survey[0].upcase
          when 'priority_id' then survey.priority.name_priority
          when 'type_survey_id' then survey.type_survey.name_type_survey
          when 'date_closed' then survey.date_closed.strftime('%d-%m-%Y')
          when 'created_at' then survey.created_at.strftime('%d-%m-%Y')
          when 'status' then survey.status
          else survey.name_survey
        end
      end
    end

    @supply_info = {
        total: data.length,
        name_list_surveys: 'All surveys',
        filter_criteria: to_readable_name(filter_criteria),
        filter_code: filter_criteria
    }
    render 'index'
  end

  # Show survey and all the questions contained within
  def show
    if survey_is_not_finished(params[:id], session[:user_id])
      @survey = Survey.includes(:user, :priority, :type_survey, :questions).find(params[:id])
      @questions = @survey.questions.order(:numero_question)
    else
      render 'leader/surveys/confirm_fail'
    end
  end

  def submit_survey
    questions = Survey.includes(:questions).find(params[:id]).questions.order(:numero_question)
    questions.each do |q|
      param = q.id.to_s.to_sym
      choices_id = all_to_int(params[param])
      choices = get_choices(choices_id)
      add_response(q.id, choices, session[:user_id])
    end
    close_survey_of(session[:user_id], params[:id])
    render 'leader/surveys/confirm_success'
  end

  private
  def survey_is_not_finished(survey_id, user_id)
    done_survey = FinishSurvey.where(:survey_id => survey_id).where(:user_id => user_id)
    done_survey.length == 0
  end

  def get_choices(choices_array)
    Choice.where(:id => choices_array)
  end

  def add_response(question_id, choices, user_id)
    choices.each do |choice|
      Response.create(:question_id => question_id, :choice_id => choice.id, :user_id => user_id)
    end
  end

  def close_survey_of(user_id, survey_id)
    FinishSurvey.create(:survey_id => survey_id, :user_id => user_id)
  end
end
