$(document).on("page:change",function() {
    // $("body").on("change",".start-date",function() {

    // });
    $("body").on("click",".will-close-on-click",function() {
        var day = parseInt($(this).text());
        var month = parseInt($(".hidden-month-in-number").text());
        var year = parseInt($(".year-to-append").text());

        $(".dropdown-start-date").text(year + "/" + month + "/" + day);
        var for_form_start_date = $(".dropdown-start-date").text();

        var close_text = $(".dropdown-end-date").text();
        var array_of_close_text = close_text.split("/");
        var day_2 = parseInt(array_of_close_text[2]);
        var month_2 = parseInt(array_of_close_text[1]);
        var year_2 = parseInt(array_of_close_text[0]);

        $("input[name='begin[date]']").val(for_form_start_date); // Here we set value for begin[date] input

        if (year > year_2 || month > month_2 && year >= year_2 || day > day_2 && month >= month_2 && year >= year_2) {   
            $(".dropdown-end-date").text(year + "/" + month + "/" + day); 
            var for_form_end_date = $(".dropdown-end-date").text(); 
            $("input[name='end[date]']").val(for_form_end_date);  // Here we set value for end[date] input
        }

        $(".ajax-start-date").remove();
        $(".hidden-month-in-number").remove();
    });

    $("body").on("click",".will-close-on-click-end",function() {
        var day = $(this).text();
        var month = $(".hidden-month-in-number-end").text();
        var year = $(".year-to-append").text();

        $(".dropdown-end-date").text(year + "/" + month + "/" + day)
        var for_form_end_date = $(".dropdown-end-date").text();

        var close_text = $(".dropdown-start-date").text();
        var array_of_close_text = close_text.split("/");
        var day_2 = parseInt(array_of_close_text[2])
        var month_2 = parseInt(array_of_close_text[1])
        var year_2 = parseInt(array_of_close_text[0])

        $("input[name='end[date]']").val(for_form_end_date); // Here we set value for end[date] input

        if (year < year_2 || month < month_2 && year <= year_2 || day < day_2 && month <= month_2 && year <= year_2) {   
            $(".dropdown-start-date").text(year + "/" + month + "/" + day);     
            var for_form_start_date = $(".dropdown-start-date").text();
            $("input[name='begin[date]']").val(for_form_start_date); // Here we set value for start[date] input
        }

        $(".ajax-end-date").remove();
        $(".hidden-month-in-number-end").remove();
    });

    $(document).ajaxComplete(function() {
        var d = $("select > option.new-task-time-start:first-of-type").prop("selected",true);  // FOR NEW TASK
        var e = $("select > option.new-task-time-end:first-of-type").prop("selected",true);  // FOR NEW TASK

        var catchStartTime = $(".start-time-helper").text();
        var catchEndTime = $(".end-time-helper").text();

        $("select > option.edit-time-start[value='" + catchStartTime +"']").prop("selected",true);
        $("select > option.edit-time-end[value='" + catchEndTime +"']").prop("selected",true);

        var for_form_start_date = $(".dropdown-start-date").text();   // Here we set input of start[date] and end[date] with ajax completed to have default value
        var for_form_end_date = $(".dropdown-end-date").text();
        $("input[name='end[date]']").val(for_form_end_date)
        $("input[name='begin[date]']").val(for_form_start_date);

        var startTagText = $(".o-t-b:selected").text(); // Here we set input of begin[time] and end[time] with default value
        var endTagText = $(".o-t-e:selected").text();
        $("input[name='begin[time]']").val(startTagText);
        $("input[name='end[time]']").val(endTagText);
    });

    $("body").on("click",".o-t-b",function() {
        $(".o-t-b:selected").prop("selected",false);
        $(this).prop('selected',true);
        var clickedTagText = $(this).text();
        var endTagText = $(".o-t-e:selected").text();
        var clickedSplit = clickedTagText.split(":");
        var endSplit = endTagText.split(":");

        $("input[name='begin[time]']").val(clickedTagText);

        var start_date = $("#start").text();
        var end_date = $("#end").text();
        
        if (start_date === end_date) {
            if (parseInt(clickedSplit[0]) > parseInt(endSplit[0]) || parseInt(clickedSplit[0]) === parseInt(endSplit[0]) && parseInt(clickedSplit[1]) > parseInt(endSplit[1])) {
                $(".o-t-e:selected").prop("selected",false);
                var a = $(".o-t-e[value='" + clickedSplit[0] + ":" + clickedSplit[1] + "']");
                $(a).prop("selected",true);
                $("input[name='end[time]']").val(a.text());
            };
        };
    });    

    $("body").on("click",".o-t-e",function() {
        $(".o-t-e:selected").prop("selected",false);
        $(this).prop('selected',true);
        var clickedTagText = $(this).text();
        var startTagText = $(".o-t-b:selected").text();
        var clickedSplit = clickedTagText.split(":");
        var startSplit = startTagText.split(":");

        $("input[name='end[time]']").val(clickedTagText);

        var start_date = $("#start").text();
        var end_date = $("#end").text();

        if (start_date === end_date) {
            if (parseInt(clickedSplit[0]) < parseInt(startSplit[0]) || parseInt(clickedSplit[0]) === parseInt(startSplit[0]) && parseInt(clickedSplit[1]) < parseInt(startSplit[1])) {
                $(".o-t-b:selected").prop("selected",false);
                var a = $(".o-t-b[value='" + clickedSplit[0] + ":" + clickedSplit[1] + "']");
                $(a).prop("selected",true);
                $("input[name='begin[time]']").val(a.text());
            };
        };
    });

    $("body").on("click",".check-box-submit",function() {
        $(this).closest("form").submit();
    });
    $("body").on("click",".edit-submit",function() {
        $(this).parent().children("form:first-of-type").submit();
    });
});