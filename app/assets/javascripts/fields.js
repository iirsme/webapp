$(document).on('ready turbolinks:load', function () {
  var entity = 'campo(s)';

  // Fields table
  $('.fields-table').DataTable({
    retrieve: true,
    ordering: true,
    searching: true,
    scrollY: '40vh',
    select: {
      style: "single",
      blurable: true
    },
    processing: true,
    paging: true,
    lengthMenu: [5, 10, 20],
    columns: [
      null,
      null,
      null,
      { orderable: false },
      { orderable: false }
    ],
    language: {
      emptyTable: "Vacio",
      lengthMenu: "Mostrar _MENU_ resultados",
      loadingRecords: "Cargando...",
      processing: "Cargando...",
      zeroRecords: "No se encontraron resultados",
      search: "Buscar:",
      info: "_TOTAL_ " + entity + " encontrado(s)",
      infoEmpty: "",
      infoFiltered: "",
      select: {
      	rows: {
      	  _: "",
      	  1: ""
      	}
      },
      paginate: {
        next: "Siguiente >",
        previous: "< Anterior"
      }
    }
  });


  // Validations
  $('.field-type').change(function () {
    fieldFormLogic();
  });

});


function fieldFormLogic () {
  var type = $('.field-type').val();
  if (type === 'text_field') {
    $('.field-validation-section').show();
  } else {
    $('.field-validation-section').hide();
  }
};
