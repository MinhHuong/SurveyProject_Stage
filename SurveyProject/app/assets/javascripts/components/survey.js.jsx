var Survey = React.createClass({
    render: function() {
        var survey = this.props.survey;
        var type_survey = this.props.type_survey;
        var type_priority = this.props.type_priority;
        var user_author = this.props.user_author;
        return(
            <div className="survey well">
                <h3>{ survey.name_survey }</h3>
                <p>
                    <span className="survey-label">Created by: </span> { "Anonymous" || user_author }
                </p>
                <p>
                    <span className="survey-label">From: </span> { new Date(survey.created_at).toLocaleDateString() } - <span className="survey-label">To: </span> { new Date(survey.date_closed).toLocaleDateString() }
                </p>
                <p>
                    <span className="survey-label">Type: </span> { type_survey.name_type_survey }
                </p>
                <p>
                    <span className="survey-label">Priority: </span> { type_priority.name_priority }
                </p>
            </div>
        )
    }
})