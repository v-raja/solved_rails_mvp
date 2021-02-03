document.addEventListener("turbolinks:load", function() {

  if (gon.user_singed_in) {
    analytics.identify(
      meta_tag.content,
      {
        id: gon.current_user_id,
        name: gon.current_user_name,
        email: gon.current_user_email,
      }
    );
  }

  analytics.page();
})
