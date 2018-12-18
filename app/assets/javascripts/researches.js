
function researchFormLogic () {
  var isPrivate = $('#is_private');
  var password = $('#research_password'); 
  password.prop("disabled", !isPrivate.is(':checked'));
};