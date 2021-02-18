
// contains all segment identify and track events
$(document).on("turbolinks:load", function(event) {

  if (gon.ffi) {
    analytics.identify(
      atob(gon.pxmalz),
      JSON.parse(atob(gon.ffi))
    );
  }


  document.querySelectorAll('.solution').forEach(function(solution) {
    analytics.trackLink(solution, "Solution Clicked", {
      title: solution.dataset.title,
      index: "solutions_" + process.env.RAILS_ENV,
      objectID: solution.dataset.position
    });
  });

  document.querySelectorAll('.learn-more').forEach(function(button) {
    analytics.trackLink(button, "Learn More Clicked", {
      title: button.dataset.title,
      index: "solutions_" + process.env.RAILS_ENV,
      objectID: button.dataset.position
    });
  });

  document.querySelectorAll('.popular-industry').forEach(function(link) {
    analytics.trackLink(link, "Community Clicked", {
      location: "popular_industries",
      title: link.dataset.title,
      index: "niches_" + process.env.RAILS_ENV,
      objectID: link.dataset.position
    });
  });

  document.querySelectorAll('.popular-occupation').forEach(function(link) {
    analytics.trackLink(link, "Community Clicked", {
      location: "popular_occupations",
      title: link.dataset.title,
      index: "niches_" + process.env.RAILS_ENV,
      objectID: link.dataset.position
    });
  });

  document.querySelectorAll('.posted-to').forEach(function(link) {
    analytics.trackLink(link, "Community Clicked", {
      location: "posted_to",
      title: link.dataset.title,
      index: "niches_" + process.env.RAILS_ENV,
      objectID: link.dataset.position
    });
  });

  document.querySelectorAll('.link-to-community').forEach(function(link) {
    analytics.trackLink(link, "Community Clicked", {
      location: "solution_partial",
      title: link.dataset.title,
      index: "niches_" + process.env.RAILS_ENV,
      objectID: link.dataset.position
    });
  });

  document.querySelectorAll('.community-search').forEach(function(link) {
    analytics.trackLink(link, "Search Community Clicked", {
      title: link.dataset.title,
      index: "niches_" + process.env.RAILS_ENV,
      objectID: link.dataset.position
    });
  });

  document.querySelectorAll('.join-wa-chat').forEach(function(link) {
    analytics.trackLink(link, "Join WA Chat Clicked", {
      title: link.dataset.title,
      index: "niches_" + process.env.RAILS_ENV,
      objectID: link.dataset.position
    });
  });

  document.querySelectorAll('.popular').forEach(function(link) {
    analytics.trackLink(link, "Popular Nav Clicked");
  });

  // search-solutions, explore
  document.querySelectorAll('.home').forEach(function(link) {
    analytics.trackLink(link, "Home Nav Clicked");
  });

  document.querySelectorAll('.search-solutions').forEach(function(link) {
    analytics.trackLink(link, "Search Solutions Nav Clicked");
  });

  document.querySelectorAll('.explore').forEach(function(link) {
    analytics.trackLink(link, "Explore Nav Clicked");
  });


})
