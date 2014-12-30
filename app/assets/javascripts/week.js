$(document).on("page:change",function() {
    $("body").on("click",".change-me-temp",function() {
        $(this).siblings("a").css("display","inline");
        $(this).css("display","none");
        $(".particular-day-tasks").remove();
    });

    $("body").on("click",".anchor-week-view",function() {
        var clicked_element = $(this);
        var all_anchors = $(".anchor-week-view");
        all_anchors.each(function(index) {
            if ($(this).is(clicked_element)) {
                all_anchors.splice(index,1);
            };
        });
        all_anchors.each(function(index) {
            $(this).siblings(".change-me-temp").css("display","none");
            $(this).css("display","inline");
        });
    });
});