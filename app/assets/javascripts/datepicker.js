$(document).on('ready turbolinks:load', function () { 
  $(function() {
  	$('#datepicker').datepicker({
      format: 'dd/mm/yyyy',
      language: 'es',
      clearBtn: true,
      // todayBtn: 'linked',
      todayHighlight: true,
      autoclose: true,
      enableOnReadonly: false,
      orientation: 'bottom'      
    });
  });
});
