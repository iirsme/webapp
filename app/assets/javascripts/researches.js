


$(document).on('ready turbolinks:load', function () {
  // Show Tooltips
  $('.nav-tabs > li a[title]').tooltip();
  
  // Disable Password field onChange
  $('.research-is-private-field').on('change', function () {
    researchFormLogic();
  });

  // Allow clicks only on Enabled tabs
  $('a[data-toggle="tab"]').on('show.bs.tab', function (e) {
    var $target = $(e.target);
    if ($target.parent().hasClass('disabled')) {
      return false;
    }
  });

  // ------------- Pending to use -----------------------
  $(".next-step").click(function (e) {
    var $active = $('.wizard .nav-tabs li.active');
    $active.next().removeClass('disabled');
    nextTab($active);
  });
  $(".prev-step").click(function (e) {
    var $active = $('.wizard .nav-tabs li.active');
    prevTab($active);
  });
  // ----------------------------------------------------

});

function nextTab (elem) {
  $(elem).next().find('a[data-toggle="tab"]').click();
}

function prevTab (elem) {
  $(elem).prev().find('a[data-toggle="tab"]').click();
}

function researchFormLogic () {
  var isPrivate = $('.research-is-private-field');
  var password = $('.research-password-field'); 
  password.prop("disabled", !isPrivate.is(':checked'));
}