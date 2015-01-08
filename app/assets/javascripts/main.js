$(document).ready(function() {
    $('[data-toggle="tooltip"]').tooltip();

    $("#navbar_changer").click(function() {
        if (!($("a button").hasClass("btn-block m-t-10"))) {
            $("a button").addClass("btn-block m-t-10").removeClass("m-r-20");

        } else {
            $("#collapse").on('hidden.bs.collapse', function() {
                $("a button").removeClass("btn-block m-t-10").addClass("m-r-20");                  
            });
        }
    });

    // $("body").on("input","textarea",function() {
    //     $(this).height(this.scrollHeight);
    //     console.log(this.scrollHeight);
    // });

    // $("body").on("click",".container-480.well.m-t-50",function() {
    //     $(".container-480.well.m-t-50").append("hello");
    // })

    function forMobile() {
        if (document.body.clientWidth < 300) {
            $("#taskmaster").removeClass("col-xs-6")
            $("#taskmaster").addClass("text-center")
            $("#dropdown-menu").removeClass("col-xs-6")
            $("#dropdown1").addClass("btn-block");
            $("#dropdown1").css("margin-right","0");
            $("#dropdown-menu").css("margin-left","10px")
            $("#dropdown-menu").css("margin-right","10px")
            $("#ul-dropdown").css("right","0");
            $("#ul-dropdown").css("width","100%");
        } else if (document.body.clientWidth >= 300) {
            $("#taskmaster").addClass("col-xs-6")
            $("#taskmaster").removeClass("text-center");
            $("#dropdown-menu").addClass("col-xs-6");
            $("#dropdown1").removeClass("btn-block");
            $("#dropdown1").css("margin-right","20px");
            $("#dropdown-menu").css("margin-right","0")
            $("#dropdown-menu").css("margin-left","0")
            $("#ul-dropdown").css("right","0");
            $("#ul-dropdown").css("width","initial");
        }
    }

    function checker() {
        var elem = $(".overflowing-text");
        var part2 = elem.height();
        var part3 = elem.width();
        console.log("Height is: " + part2 + " , Width is: " + part3);
    }

    $(document).ajaxComplete(function() {
        documentHeight = document.body.clientHeight;
        documentWidth = document.body.clientWidth;
        $(".pop-up").css("height",documentHeight);
        $(".pop-up").css("width",documentWidth);
        forMobile() 

        if ($(".flexible-margin-pop-up").length > 0) { // Fix for pop ups that overflow whole body element when they appear
            var popUp = $(".flexible-margin-pop-up");
            var offset = popUp.offset();

            var top = offset.top;
            var left = offset.left;

            var bottom = top + popUp.outerHeight();
            var right = left + popUp.outerWidth();

            if ($("body").outerHeight() < bottom) {
                $("body").css("height",bottom + 30);
                $(".pop-up").css("height",$("body").outerHeight());

                $(".disable-popup").on("click",function() {
                    $("body").css("height","auto");
                });
            };
        };


    });

    $(window).resize(function() {
        documentHeight = document.body.clientHeight;
        documentWidth = document.body.clientWidth;
        $(".pop-up").css("height",documentHeight);
        $(".pop-up").css("width",documentWidth);
        forMobile()
    })

    $(document).on("page:change",function() {
        forMobile()     
    })

    $("body").on("click","*",function() {
        $(".flash-to-delete").remove();
    });

    $("body").on("mouseover",".on-mouse-over-2",function() {
        $(this).children(".todo-pencil").removeClass("display-none");
    });

    $("body").on("click",".todo-pencil",function() {
        $(this).siblings("form").submit();
    });

    // $('.prevent-double-submit').live('ajax:beforeSend', function(evt, xhr, settings){
    //   // prevent double submit
    //   $(':submit', this).click(function() {
    //     return false;
    //   });
    // });
});