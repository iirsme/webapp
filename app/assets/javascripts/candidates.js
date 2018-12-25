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
  // $('.candidate-occupation-field').change(function () {
    // candidateFormLogic();
  // });
  $('.candidate-occupation-field').change(function () {
    getCountries(true);
  });  
  $('.candidate-bcountry-field').change(function () {
  	// TODO: Clean states field
    getStates(true);
  });
  $('.candidate-bstate-field').change(function () {
  	// TODO: Clean cities field
    getCities(true);
  });

  // Loading Combos from WS
  getCountries();
  getStates();
  getCities();
});

candidateFormLogic = function () { console.log("ejecutandome...");
  var occupation = $('.candidate-occupation-field').val();
  if (occupation === 'Otro') {
    $('.candidate-other-occupation-field').show();
  } else {
    $('.candidate-other-occupation-field').hide();
  }
};

function getCountries(showLoading) { console.log("Calling AJAX 1...");
  if (showLoading) {
    $('.birth-country-loading').show();
  }
  $.ajax({
    type: "GET",
    url: "http://api.geonames.org/countryInfoJSON?lang=es&username=sanjish",
    contentType: "application/json; charset=utf-8",
    dataType: "jsonp",
    success: function (data) {
      $(data.geonames).each(function (index, item) {
        $(".candidate-bcountry-field").append($('<option />', { value: item.geonameId, text: item.countryName }));
      });
      var currentValue = $('#birth-country').val();
      $(".candidate-bcountry-field").val(currentValue);
      $(".candidate-bcountry-field").slideDown();
      if (showLoading) {
        $('.birth-country-loading').hide();
      }
    },
    error: function (data) { debugger;
      if (showLoading) {
        $('.birth-country-loading').hide();
      }
      alert("Error al obtener lista de paises");
    }
  });
}

function getStates (showLoading) { console.log("Calling AJAX 2...");
  var country = $(".candidate-bcountry-field").val() || $('#birth-country').val();
  if (country) {
    getChildren(country, $('.candidate-bstate-field'), $('#birth-state'), showLoading, $('.birth-state-loading'));
  }
}

function getCities (showLoading) { console.log("Calling AJAX 3...");
  var state = $(".candidate-bstate-field").val() || $('#birth-state').val();
  if (state) {
    getChildren(state, $('.candidate-bcity-field'), $('#birth-city'), showLoading, $('.birth-city-loading'));
  }
};

function getChildren (parent, field, hiddenField, showLoading, indicator) {
  if (showLoading) {
    $(indicator).show();
  }	
  $.ajax({
    type: "GET",
    url: "http://api.geonames.org/childrenJSON?geonameId=" + parent + "&username=sanjish&lang=es",
    contentType: "application/json; charset=utf-8",
    dataType: "jsonp",
    success: function (data) {
      $(field).empty();
      $(data.geonames).each(function (index, item) {
        $(field).append($('<option />', { value: item.geonameId, text: item.name }));
      });
      var currentValue = $(hiddenField).val();
      $(field).val(currentValue);
      if (showLoading) {
        $(indicator).hide();
      }
    },
    error: function (data) { debugger;
      if (showLoading) {
        $(indicator).hide();
      }
      alert("Error al obtener lista de estados/ciudades");
    }
  });
};
