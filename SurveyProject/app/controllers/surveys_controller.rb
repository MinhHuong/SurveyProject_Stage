class SurveysController < ApplicationController
  # Show survey and all the questions contained within
  def show(confirm_fail_page)
    if survey_is_not_finished(params[:id], session[:user_id])
      @survey = Survey.includes(:user, :priority, :type_survey, :questions).find(params[:id])
      if current_user.permission == 'employee'
        @menubar = 'employee/employees/menubar'
      elsif current_user.permission == 'leader'
        @menubar = 'leader/leaders/menubar'
      end
      render 'surveys/show'
    else
      render confirm_fail_page
    end
  end

  def submit_survey(confirm_success_page)
    questions = Survey.includes(:questions).find(params[:id]).questions.order(:numero_question)
    questions.each do |q|
      param = q.id.to_s.to_sym
      choices_id = all_to_int(params[param])
      choices = get_choices(choices_id)
      add_response(q.id, choices, session[:user_id])
    end
    close_survey_of(session[:user_id], params[:id])
    render confirm_success_page
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
