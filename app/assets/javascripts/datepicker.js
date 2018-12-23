$(document).on('ready turbolinks:load', function () { 
  $(function() {
  	$('#datepicker1, #datepicker2, #datepicker3').datepicker({
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
