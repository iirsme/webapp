$(document).on('ready turbolinks:load', function () {
  var entity = 'variable(s)';

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
    lengthMenu: [10, 20, 50, 100],
    columns: [
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


  // Listeners
  $('.field-type').change(function () {
    fieldFormLogic();
  });
  $('#field_form').submit(function () {
    buildOptions();
  });


  // Drag&Drop table
  $(".table-sortable tbody").sortable({
    helper: fixHelperModified,
    update: updatee
  }).disableSelection();

  $(".table-sortable thead").disableSelection();

});

function fixHelperModified (e, tr) {
  var $originals = tr.children();
  var $helper = tr.clone();
  $helper.children().each(function (index) {
    $(this).width($originals.eq(index).width())
  });
  return $helper;
};

function updatee () {
  $('tbody').find('tr').each(function (k,v) {
  	// Do Nothing
    // console.log($(v)[0].children[0].dataset.id)
  });
};

function fieldFormLogic () {
  var type = $('.field-type').val();
  if (type === 'text_field') {
    $('.field-validation-section').show();
  } else {
    $('.field-validation-section').hide();
  }
  if (type === 'select' || type === 'multi_select') {
    $('.field-values-section').show();
  } else {
    $('.field-values-section').hide();
  }
};

function buildOptions () {
  var json = "[";
  var id, ids = $('._ids');
  var val, values = $('._values');
  for (var i = 0; i < ids.length; i++) {
    id = $(ids[i]).val();
    val = $(values[i]).val();
    if (i > 0) {
      json += ", ";
    }
    json += '{"id": "';
    json += id;
    json += '", "value": "'
    json += val;
    json += '"}';
  }
  json += "]";
  $('#field_values').val(json);
};

function addFieldOption (event) {
  var next_opt = $('.field_options').length;
  var curr_opt = next_opt - 1;
  var row = "<td class='col col-xs-1' align='center'></td>";
  row += ("<td class='col col-xs-2'><input type='text' name='id_" + curr_opt + "' id='id_" + curr_opt + "' class='form-control form-style _ids'></td>");
  row += ("<td class='col col-xs-4'><input type='text' name='val_" + curr_opt + "' id='val_" + curr_opt + "' class='form-control form-style _values'></td>");
  row += ("<td class='col col-xs-1' align='center'><a class='btn btn-default btn-action' onclick='removeFieldOption(event, " + curr_opt + ");' href><i class='glyphicon glyphicon-trash'></i></a></td>");

  $('#field_option_' + curr_opt).append(row);
  $('#field_options_table').append('<tr id="field_option_'+ next_opt + '" class="field_options"></tr>');
  event.preventDefault();
};

function removeFieldOption (event, idx) {
  var row = $('#field_option_' + idx);
  var inputs = $('#field_option_' + idx + ' td input');
  inputs.removeClass('_ids');
  inputs.removeClass('_values');
  row.hide();
  event.preventDefault();
};
