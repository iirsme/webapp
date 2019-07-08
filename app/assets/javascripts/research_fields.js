$(document).on('ready turbolinks:load', function () {
  // Do nothing, not yet...
});

function createSortableLists (onlyLabels) {
  Sortable.create($('#available_labels_list')[0], {
    group: "research_fields",
    animation: 200,
    sort: false,
    onAdd: function (evt) {
      var item = $(evt.item);
      item.removeClass('col-md-4');
      item.removeClass('row-triplet')
      item.removeClass('tab-subtitle');
    }
  });

  if (onlyLabels) {
    return;
  }

  Sortable.create($('#available_fields_list')[0], {
    group: "research_fields",
    animation: 200,
    sort: false,
    onAdd: function (evt) {
      var item = $(evt.item);
      item.removeClass('col-md-4');
      item.removeClass('row-triplet')
      item.removeClass('tab-subtitle');
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
        if (item.hasClass('tab-field')) {
          item.addClass('col-md-4');
        } else if (item.hasClass('tab-label')) {
          item.addClass('col-md-12');
          item.addClass('tab-subtitle');
        }
      }
    });
  }
};
