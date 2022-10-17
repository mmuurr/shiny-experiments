shinyjs.question_timer_init = function() {
    question_timer = new easytimer.Timer();
    question_timer.netrivia = {
	duration_seconds = 0;
    };
}

shinyjs.question_timer_reset = function(params) {
    if(question_timer.isRunning()) {
	return;
    } else {
	question_timer.netrivia.duration_seconds = params.duration_seconds;
    }
}

shinyjs.question_timer_start = function() {
    question_timer.
}
