class Leader::SurveysController < SurveysController
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

  def new
    @survey = Survey.new
  end

  def create
    @survey = Survey.new(survey_params)
    if @survey.save
      # add records to QUESTIONS
      arr_questions = JSON.parse(params[:hidden_questions])
      arr_questions.each do |value|
        Question.create(
          :content => value['content'],
          :numero_question => value['no_question'],
          :type_question_id => TypeQuestion.find_by(:code_type_question => value['type_question']).id,
          :survey_id => @survey.id)
      end

      # add records to CHOICES
      arr_choices = JSON.parse(params[:hidden_choices])
      arr_choices.each do |value|
        Choice.create(
          :content => value['content'],
          :question_id => Question.find_by(
            :numero_question => value['no_question'],
            :survey_id => @survey.id).id
          )
      end

      # render another page
      render 'leader/leaders/index'
    else
      redirect_to '/leader/surveys/new'
    end
  end

  def show
    @menubar = 'leader/leaders/menubar'
    super('surveys/confirm_fail')
  end

  def submit_survey
    @menubar = 'leader/leaders/menubar'
    super('surveys/confirm_success')
  end

  private
  def survey_params
    params.require(:survey).permit(
        :name_survey,
        :date_closed,
        :type_survey_id,
        :priority_id,
        :user_id,
        :status => true
    )
  end
end
