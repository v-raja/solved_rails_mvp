document.addEventListener("turbolinks:load", function() {
  if (gon.ffi) {
    analytics.identify(
      atob(gon.page_id),
      {
        name: atob(gon.ldap),
        email: atob(gon.udap),
      }
    );
  }

  analytics.page();
})
