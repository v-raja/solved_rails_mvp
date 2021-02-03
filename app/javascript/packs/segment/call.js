document.addEventListener("turbolinks:load", function() {
  console.log(gon);
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
