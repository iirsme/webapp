
// Controls the icon to display under Audit result grid
function changeAuditIcon (btn) {
  if ($(btn).hasClass('fa-angle-double-down')) {
    $(btn).removeClass(' fa fa-angle-double-down').addClass(' fa fa-angle-double-up');
  } else {
  	$(btn).removeClass(' fa fa-angle-double-up').addClass(' fa fa-angle-double-down');
  }
}
