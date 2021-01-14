$(document).on('turbolinks:load', function() {
  const searchClient = algoliasearch(
    'U9L5TDQXIN',
    '1f741c451c7cb0ffe440766809f77cf5'
  );

  const search = instantsearch({
    searchClient,
    indexName: 'niches_development',
    urlSync: true,
    searchFunction(helper) {
      const container = document.querySelector('#results');
      container.style.display = helper.state.query === '' ? 'none' : '';

      const empty_search = document.querySelector('#app_body');
      empty_search.style.display = helper.state.query === '' ? '' : 'none';

      helper.search();
    }
  });

  search.addWidgets([
    instantsearch.widgets.configure({
      attributesToSnippet: ['description'],
    }),
    instantsearch.widgets.searchBox({
      container: '#searchbox',
      placeholder: "Search for an indsutry or occupation"
    }),

    instantsearch.widgets.hits({
      container: '#hits',
      templates: {
        empty: 'No results have been found for {{ query }}',
        // item: '<strong>Hit {{objectID}}</strong>: {{{_highlightResult.title.value}}}',
        item: '<a href={{{url}}}>' +
                '<div class="flex flex-wrap">' +
                  '<div class="w-full text-xs text-black">' +
                    '{{{type}}}'+
                  '</div>' +
                  '<div class="w-full font-semibold text-black leading-tight text-sm">' +
                    '{{{_highlightResult.title.value}}}'+
                  '</div>' +
                  '<div class="w-full text-sm mt-1">' +
                    '{{#helpers.snippet}}{ "attribute": "description", "highlightedTagName": "mark" }{{/helpers.snippet}}' +
                  '</div>' +
                '</div>' +
              '</a>'
      },
    })
  ]);

  search.start();
});
