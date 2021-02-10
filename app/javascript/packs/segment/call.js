document.addEventListener("turbolinks:load", function(event) {
  // if (gon.ffi) {
  //   analytics.identify(
  //     atob(gon.page_id),
  //     {
  //       name: atob(gon.ldap),
  //       email: atob(gon.udap),
  //     }
  //   );
  // }
  if (event.data.timing.visitStart) {

    if (gon.page_id) {
      analytics.identify(
        atob(gon.page_id),
        JSON.parse(atob(gon.test))
      );
    }

    analytics.page();
  }
})
