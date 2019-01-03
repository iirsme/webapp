	
// Controls the icon to display under Audit result grid
function changeAuditIcon (btn) {
  if ($(btn).hasClass('fa-angle-double-down')) {
    $(btn).removeClass(' fa fa-angle-double-down').addClass(' fa fa-angle-double-up');
  } else {
  	$(btn).removeClass(' fa fa-angle-double-up').addClass(' fa fa-angle-double-down');
  }
}

function getLocalDate (index) {
  var strDate = $('.done_at')[index].innerHTML;
  var date = moment(strDate);
  strDate = date.format("DD/MM/YYYY h:mm:ss a");
  $('.done_at')[index].innerHTML = strDate;
}