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
});


$(document).ready(function () {
  // Validations
  $('.candidate-occupation-field').change(function () {
    candidateFormLogic();
  });

  $('#candidate_birth_country').change(function () {
  	setValues('#candidate_birth_country');
    resetValues('#candidate_birth_state');
    resetValues('#candidate_birth_city');
    getBirthdayStates(true);
  });

  $('#candidate_birth_state').change(function () {
  	setValues('#candidate_birth_state');
    resetValues('#candidate_birth_city');
    getBirthdayCities(true);
  });

  $('#candidate_birth_city').change(function () {
  	setValues('#candidate_birth_city');
  });

  $('#candidate_address_country').change(function () {
    setValues('#candidate_address_country');
    resetValues('#candidate_address_state');
    resetValues('#candidate_address_city');
    getAddressStates(true);
  });

  $('#candidate_address_state').change(function () {
    setValues('#candidate_address_state');
    resetValues('#candidate_address_city');
    getAddressCities(true);
  });

  $('#candidate_address_city').change(function () {
  	setValues('#candidate_address_city');
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
  var aCountry = $("#candidate_address_country");
  var ahCountry = $("#candidate_address_country_id");
  var bCountry = $("#candidate_birth_country");
  var bhCountry = $("#candidate_birth_country_id");

  aCountry.empty();
  bCountry.empty();
  $.ajax({
    type: "GET",
    url: "http://api.geonames.org/countryInfoJSON?lang=es&formatted=true&style=full&username=sanjish",
    contentType: "application/json; charset=utf-8",
    dataType: "jsonp",
    success: function (data) {
      $(bCountry).append($('<option />', { value: null, text: '' }));
      $(aCountry).append($('<option />', { value: null, text: '' }));
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
  var country = $('#candidate_birth_country_id').val();
  if (country && country !== "") {
  	console.log("Loading birthday states...");
    getChildren(country, $('#candidate_birth_state'), $('#candidate_birth_state_id'), showLoading, $('.candidate-bstate-loading'));
  }
}

function getBirthdayCities (showLoading) {
  var state = $('#candidate_birth_state_id').val();
  if (state && state !== "") { 
  	console.log("Loading birthday cities...");
    getChildren(state, $('#candidate_birth_city'), $('#candidate_birth_city_id'), showLoading, $('.candidate-bcity-loading'));
  }
};

function getAddressStates (showLoading) {
  var country = $('#candidate_address_country_id').val();
  if (country && country !== "") {
  	console.log("Loading address states...");
    getChildren(country, $('#candidate_address_state'), $('#candidate_address_state_id'), showLoading, $('.candidate-astate-loading'));
  }
}

function getAddressCities (showLoading) {
  var state = $('#candidate_address_state_id').val();
  if (state && state !== "") {
    console.log("Loading address cities...");
    getChildren(state, $('#candidate_address_city'), $('#candidate_address_city_id'), showLoading, $('.candidate-acity-loading'));
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
      $(field).append($('<option />', { value: null, text: '' }));
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

function setValues (strField) {
  var id = $(strField + " option:selected").val();
  var name = $(strField + " option:selected").text();
  $(strField + '_id').val(id);
  $(strField + '_name').val(name);
}

function resetValues (strField) {
  $(strField).val('');
  $(strField).empty();
  $(strField + '_id').val('');
  $(strField + '_name').val('');
}
