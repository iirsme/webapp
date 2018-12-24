$(document).on('ready turbolinks:load', function () {
  var entity = 'candidato(s)';

  // Candidates table
  $('.candidates-table').DataTable({
    retrieve: true,
    ordering: true,
    searching: true,
    scrollY: 250,
    select: {
      style: "single",
      blurable: true
    },
    processing: true,
    paging: true,
    lengthMenu: [10, 20, 50],
    columns: [
      null,
      null,
      null,
      null,
      null,
      { orderable: false },
      { orderable: false },
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
  $('.candidate-occupation-field').change(function () {
    candidateFormLogic();
  });

});

var candidateFormLogic = function () {
  var occupation = $('.candidate-occupation-field').val();
  if (occupation === 'Otro') {
    $('.candidate-other-occupation-field').show();
  } else {
    $('.candidate-other-occupation-field').hide();
  }
};
