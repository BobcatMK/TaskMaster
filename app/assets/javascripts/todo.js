$(document).ajaxComplete(function() {
    var todoListId = $(".todo-list-id").text();
    $("select .todo-selector[value='" + todoListId + "']").prop("selected",true);
});
