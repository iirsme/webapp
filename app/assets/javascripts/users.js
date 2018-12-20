$(document).on('ready turbolinks:load', function () {
  var entity = 'usuario(s)';

  // Users table
  $('.users-table').DataTable({
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

});