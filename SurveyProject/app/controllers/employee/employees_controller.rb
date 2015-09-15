class Employee::EmployeesController < UsersController
  # Show surveys in corresponding widgets
  def index
    # recently created surveys
    recent_created = Survey.recently_created.limit(5)

    # recently done surveys
    recent_done = Survey.recently_done(session[:user_id]).limit(5)

    # high priority surveys
    high_prio = Survey.high_prio.limit(5)

    # surveys that will be closed today
    closed_today = Survey.closed_today.limit(5)

    @content_widgets = {
        recent_created: recent_created,
        high_prio: high_prio,
        closed_today: closed_today,
        recent_done: recent_done
    }
  end
end
