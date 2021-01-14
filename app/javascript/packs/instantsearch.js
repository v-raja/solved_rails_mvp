$(document).ready(function() {

  var search = instantsearch({
    appId: "U9L5TDQXIN",
    apiKey: "1f741c451c7cb0ffe440766809f77cf5",
    indexName: 'Product_development',
    urlSync: true
  });

  search.addWidget(
    instantsearch.widgets.searchBox({
      container: '#q',
      placeholder: 'Search for products...',
      autofocus: true
    })
  );

  search.addWidget(
    instantsearch.widgets.hits({
      container: '#hits',
      templates: {
        empty: 'No results',
        item: '<strong>Hit {{objectID}}</strong>: {{{_highlightResult.name.value}}}'
      },
      hitsPerPage: 6
    })
  );



  search.start();
});
