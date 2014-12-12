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
    // $("body").on("click",".container-480.well.m-t-50",function() {
    //     $(".container-480.well.m-t-50").append("hello");
    // })

    $(document).ajaxComplete(function() {
        documentHeight = document.body.clientHeight;
        documentWidth = document.body.clientWidth;
        $(".pop-up").css("height",documentHeight);
        $(".pop-up").css("width",documentWidth);
    })

    $(window).resize(function() {
        documentHeight = document.body.clientHeight;
        documentWidth = document.body.clientWidth;
        $(".pop-up").css("height",documentHeight);
        $(".pop-up").css("width",documentWidth);
    })

});

