$(document).on('ready turbolinks:load', function () {

  // Listeners
  // $('.tab_fields_form').submit(function () {
    // buildOptions();
  // });

});

function createSortableLists () {
  Sortable.create($('#available_fields_list')[0], {
    group: "research_fields",
    animation: 200,
    sort: false,
    onAdd: function (evt) {
      var item = $(evt.item);
      if (item.hasClass('col-md-4')) {
        item.removeClass('col-md-4');
      }
    }
  });

  var tables = $('.tab_fields_table');
  for (var i = 0; i < tables.length; i++) {
    Sortable.create(tables[i], {
      group: "research_fields",
      animation: 200,
      sort: true,
      onAdd: function (evt) {
        var item = $(evt.item); 
        if (!item.hasClass('col-md-4')) {
          item.addClass('col-md-4');
        }
      }
    });
  }
};
