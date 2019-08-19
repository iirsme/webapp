$(document).on('ready turbolinks:load', function () {
  $('.multi_select').multiselect({
    buttonWidth: '100%',
    buttonClass: 'form-control',
    includeSelectAllOption: true,
    maxHeight: 350,
    disableIfEmpty: true,
    selectAllText: 'Seleccionar todo',
    nonSelectedText: 'Ninguno selecionado...',
    allSelectedText: 'Todos seleccionados...',
    numberDisplayed: 0,
    templates: {
      ul: '<ul class="multiselect-container col-xs-12 col-md-12 dropdown-menu" style="font-size: smaller; max-height: 350px; overflow: auto auto; "></ul>',
      li: '<li><a><label style="white-space:normal; padding-left:15px; "></label></a></li>'
    }
  });
});

var validate_field = function (type, field) {
  var error = false;
  var value = $(field).val();
  if (value === "" || value == null) {
    return;
  }

  if (type === 'alpha') {
    regexp = /^[A-Za-z]+$/;
  } else if (type === 'alphanumeric') {
    regexp = /^[\w\-\s]+$/;
  } else if (type === 'numeric') {
    regexp = /^\d+(\.\d{1,2})?$/;
  }
  error = !regexp.test(value);
  field.setCustomValidity(error ? 'Valor incorrecto' : '');
};
