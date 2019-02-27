$(document).on('ready turbolinks:load', function () {
  // Do Nothing...
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
  Sortable.create($('#research_fields_table')[0], {
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
};
