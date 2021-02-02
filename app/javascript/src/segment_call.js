document.addEventListener("turbolinks:load", function() {
  var meta_tag = document.querySelector("meta[name='current-user']")

  if (meta_tag != null) {
    analytics.identify(
      meta_tag.content,
      {
        name: meta_tag.dataset.name,
        email: meta_tag.dataset.email,
      }
    );
  }

  analytics.page();
})
