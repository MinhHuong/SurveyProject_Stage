var Survey = React.createClass({
    render: function() {
        var survey = this.props.survey;
        var type_survey = this.props.type_survey;
        var type_priority = this.props.type_priority;
        var user_author = this.props.user_author;
        var url_survey = '/employee/surveys/' + survey.id;
        return(
            <div className="survey well">
                <h3><a href={ url_survey }>{ survey.name_survey }</a></h3>
                <p>
                    <span className="survey-label">Created by: </span> { user_author.firstname + ' ' + user_author.lastname }
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
});

var SurveysWidget = React.createClass({
    render: function() {
        var survey = this.props.survey;
        var bonus_info = this.props.bonus_info;
        var label_bonus_info = this.props.label_bonus_info;
        return(
            <div>
                <p>
                    <a href="#">{ survey.name_survey }</a> - <span className="info-bonus"> { label_bonus_info } { new Date(bonus_info).toLocaleDateString() } </span>
                </p>
            </div>
        );
    }
});

var RadioQuestion = React.createClass({
   render: function() {
       var question = this.props.question;
       var choices = this.props.choices;
       var item_choices = [];
       for (var i = 0 ; i < choices.length ; i++) {
           item_choices.push(
               <div className="radio">
                   <label>
                       <input type="radio" name={ question.id } value={ choices[i].id } /> { choices[i].content }
                   </label>
               </div>
           )
       }
       return(
            <div className="question">
                <h4>{ question.numero_question }. { question.content }</h4>
                { item_choices }
            </div>
       );
   }
});

var CheckboxQuestion = React.createClass({
   render: function() {
       var question = this.props.question;
       var choices = this.props.choices;
       var item_choices = [];
       var name_input = question.id + '[]';
       for (var i = 0 ; i < choices.length ; i++) {
           item_choices.push(
               <div className="checkbox">
                   <label>
                       <input type="checkbox" name={ name_input } value={ choices[i].id } /> { choices[i].content }
                   </label>
               </div>
           );
       }
       return(
           <div className="question">
               <h4>{ question.numero_question }. { question.content }</h4>
               { item_choices }
           </div>
       );
   }
});

var DropdownQuestion = React.createClass({
    render: function() {
        var question = this.props.question;
        var choices = this.props.choices;
        var item_choices = [];
        for (var i = 0 ; i < choices.length ; i++) {
            item_choices.push(<option value={ choices[i].id }>{ choices[i].content }</option>)
        }
        return(
            <div classNama="question">
                <h4>{ question.numero_question }. { question.content }</h4>
                <label for={ question.id }>Select one item:</label>
                <select name={ question.id } id={ question.id } className="form-control">
                    { item_choices }
                </select>
            </div>
        );
    }
});