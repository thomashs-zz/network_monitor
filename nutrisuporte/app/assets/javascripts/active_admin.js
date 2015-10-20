//= require active_admin/base
$(function(){
	if($("#admin_users") != null && $("#current_user")){
    $("#admin_users").hide();
    $("#current_user a").first().attr("href",$("#admin_users a").first().attr("href"));
  }
  $(".admin_admin_users .action_items").hide();
});