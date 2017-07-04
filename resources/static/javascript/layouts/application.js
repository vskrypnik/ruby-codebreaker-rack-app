$(function () {
    $("a[href='" + window.location.pathname + "']")
        .parent().addClass("active");
});