(function() {
  $.ajaxSetup({
    headers: {
      'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
    }
  });

  $("*").on("ajax:beforeSend", function(e, xhr, settings) {
    return xhr.setRequestHeader("X-CSRF-Token", $('meta[name="csrf-token"]').attr('content'));
  });

  $.fn.sameHeight = function() {
    return $(this).each(function() {
      var height, siblings, t;

      t = $(this);
      height = t.height();
      siblings = t.siblings();
      return siblings.each(function() {
        if ($(this).height < height) {
          return $(this).height(height);
        }
      });
    });
  };

}).call(this);
