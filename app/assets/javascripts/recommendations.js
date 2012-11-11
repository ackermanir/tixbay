$(document).ready(function () {

    $("#select_all_keywords").click(function() {
	$(".recommendation_keyword_option").prop("checked", true);
	return false;
    });

    $("#deselect_all_keywords").click(function() {
	$(".recommendation_keyword_option").prop("checked", false);
	return false;
    });
     
});
     