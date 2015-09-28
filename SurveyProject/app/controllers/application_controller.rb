class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_user_id
  def set_user_id
    unless current_user.nil?
      session[:link_picture]= (current_user.link_picture != nil ? current_user.link_picture : 'default_user.jpg')
    end
  end

  helper_method :current_user

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def require_employee
    redirect_to '/login' unless current_user.employee?
  end

  def require_leader
    redirect_to '/login' unless current_user.leader?
  end

  def all_to_int(obj)
    if obj.is_a? Array
      result = []
      obj.each do |item|
        number = item.to_i
        result << number
      end
    else
      result = obj.to_i
    end
    result
  end

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
end
