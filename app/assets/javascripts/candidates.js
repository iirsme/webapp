$(document).on('ready turbolinks:load', function () {
  var entity = 'candidato(s)';

  // Candidates table
  $('.candidates-table').DataTable({
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
    lengthMenu: [10, 20, 50],
    columns: [
      null,
      null,
      null,
      null,
      null,
      null,
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
  $('.candidate-bcountry-field').change(function () {
  	$('.candidate-bstate-field').val("");
  	$('.candidate-bstate-field').empty();
  	$('.candidate-bcity-field').val("");
  	$('.candidate-bcity-field').empty();
    getBirthdayStates(true);
  });
  $('.candidate-bstate-field').change(function () {
  	$('.candidate-bcity-field').val("");
  	$('.candidate-bcity-field').empty();  	
    getBirthdayCities(true);
  });
  $('.candidate-acountry-field').change(function () {
  	$('.candidate-astate-field').val("");
    $('.candidate-astate-field').empty();
    $('.candidate-acity-field').val("");
  	$('.candidate-acity-field').empty();
    getAddressStates(true);
  });
  $('.candidate-astate-field').change(function () {
    $('.candidate-acity-field').val("");
  	$('.candidate-acity-field').empty();
    getAddressCities(true);
  });
});

function candidateFormLogic () {
  var occupation = $('.candidate-occupation-field').val();
  if (occupation === 'Otro') {
    $('.candidate-other-occupation-field').show();
  } else {
    $('.candidate-other-occupation-field').hide();
  }
};

function getInitialCombosData () {
  if ($('#request_sent').val() == "false") {
    if ($('#is-new-candidate').val() === "true") {
      getCountries();
    } else {
      getCountries();
      getStates();
      getCities();
    }
    $('#request_sent').val(true);
  }
};

function getCountries () { console.log("Loading countries...");
  var values = {};
  var aCountry = $(".candidate-acountry-field");
  var ahCountry = $("#candidate-acountry-field");
  var bCountry = $(".candidate-bcountry-field");
  var bhCountry = $('#candidate-bcountry-field');

  aCountry.empty();
  bCountry.empty();
  $.ajax({
    type: "GET",
    url: "http://api.geonames.org/countryInfoJSON?lang=es&formatted=true&style=full&username=sanjish",
    contentType: "application/json; charset=utf-8",
    dataType: "jsonp",
    success: function (data) {
      $(data.geonames).each(function (index, item) {
      	values = { value: item.geonameId, text: item.countryName };
        $(bCountry).append($('<option />', values));
        $(aCountry).append($('<option />', values));
      });
      $(bCountry).val(bhCountry.val());
      $(aCountry).val(ahCountry.val());
    },
    error: function (data) { debugger;
      alert("Error al obtener lista de paises");
    }
  });
}

function getBirthdayStates (showLoading) {
  var country = $(".candidate-bcountry-field").val() || $('#candidate-bcountry-field').val();
  if (country && country !== "") {
  	console.log("Loading birthday states...");
    getChildren(country, $('.candidate-bstate-field'), $('#candidate-bstate-field'), showLoading, $('.candidate-bstate-loading'));
  }
}

function getBirthdayCities (showLoading) {
  var state = $(".candidate-bstate-field").val() || $('#candidate-bstate-field').val();
  if (state && state !== "") { 
  	console.log("Loading birthday cities...");
    getChildren(state, $('.candidate-bcity-field'), $('#candidate-bcity-field'), showLoading, $('.candidate-bcity-loading'));
  }
};

function getAddressStates (showLoading) {
  var country = $(".candidate-acountry-field").val() || $('#candidate-acountry-field').val();
  if (country && country !== "") {
  	console.log("Loading address states...");
    getChildren(country, $('.candidate-astate-field'), $('#candidate-astate-field'), showLoading, $('.candidate-astate-loading'));
  }
}

function getAddressCities (showLoading) {
  var state = $(".candidate-astate-field").val() || $('#candidate-astate-field').val();
  if (state && state !== "") {
    console.log("Loading address cities...");
    getChildren(state, $('.candidate-acity-field'), $('#candidate-acity-field'), showLoading, $('.candidate-acity-loading'));
  }
};

function getStates () {
  getBirthdayStates();
  getAddressStates();
}

function getCities () {
  getBirthdayCities();
  getAddressCities();
}

function getChildren (parentId, field, hiddenField, showLoading, indicator) {
  if (showLoading) {
    $(indicator).show();
  }	
  $.ajax({
    type: "GET",
    url: "http://api.geonames.org/childrenJSON?geonameId=" + parentId + "&username=sanjish&lang=es",
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
