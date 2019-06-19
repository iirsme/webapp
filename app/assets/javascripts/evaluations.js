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
      ul: '<ul class="multiselect-container col-xs-12 col-md-12 dropdown-menu" style="font-size: smaller; max-height: 350px; overflow: auto auto !important;"></ul>'
    }
  });
});