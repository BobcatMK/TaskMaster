$(document).ready(function() {
    $("#navbar_changer").click(function() {
        if (!($("a button").hasClass("btn-block m-t-10"))) {
            $("a button").addClass("btn-block m-t-10").removeClass("m-r-20");

        } else {
            $("#collapse").on('hidden.bs.collapse', function() {
                $("a button").removeClass("btn-block m-t-10").addClass("m-r-20");                  
            });
        }
    });
});