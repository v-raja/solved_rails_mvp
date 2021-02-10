$(document).on("turbolinks:load", function(event) {

  if (gon.ffi) {
      analytics.identify(
        atob(gon.pxmalz),
        JSON.parse(atob(gon.ffi))
      );
    }
})
