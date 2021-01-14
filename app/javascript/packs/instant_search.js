// $(document).ready(function() {

//   var search = instantsearch({
//     appId: "U9L5TDQXIN",
//     apiKey: "1f741c451c7cb0ffe440766809f77cf5",
//     indexName: 'niches_development',
//     urlSync: true
//   });

//   search.addWidget(
//     instantsearch.widgets.searchBox({
//       container: '#q',
//       placeholder: 'Search for niches...',
//       autofocus: true
//     })
//   );

//   search.addWidget(
//     instantsearch.widgets.hits({
//       container: '#hits',
//       templates: {
//         empty: 'No results',
//         item: '<strong>Hit {{objectID}}</strong>: {{{_highlightResult.name.value}}}'
//       },
//       hitsPerPage: 6
//     })
//   );



//   search.start();
// });


// require("selectize");
// import 'selectize/dist/js/selectize.min.js';
// import 'selectize/dist/css/selectize.css';





$( document ).on('turbolinks:load', function() {

  var item_template = '<div>'+
            '  <div class="aspect-w-16 aspect-h-9">'+
            '    <img class="object-cover" src="{{ product.thumbnail_url }}">'+
            '  </div>'+
            '  <div class="px-3 leading-none flex items-start justify-between w-full mt-2" sm="px-1">'+
            '    <div>'+
            '      <div class="font-semibold leading-5 text-gray-900 text-md-two-lines">'+
            '        {{ title }}' +
            '      </div>'+
            '      <div class="mt-1 text-sm flex items-end justify-between">'+
            '        <div class="flex items-center text-gray-600 text-sm">'+
            '          <div class="text-xs inline-flex items-center">'+
            '            <div class="text-xs-one-line">'+
            '              {{ user.name }}'+
            '            </div>'+
            '            <div class="ml-1">'+
            '              •'+
            '            </div>'+
            '            <div class="ml-1 font-bold text-primary">'+
            '              {{rating}}'+
            '            </div>'+
            '            <div class="ml-0.5 text-gray-600 leading-none">'+
            '              ({{nb_reviews}})'+
            '            </div>'+
            '          </div>'+
            '        </div>'+
            '      </div>'+
            '    </div>'+
            '    <div class="flex-shrink-0 ml-4 text-xl text-gray-800 font-semibold leading-tight">'+
            '      \${{price}}'+
            '    </div>'+
            '  </div>'+
            '</div>';



  // var search = instantsearch({
  //   appId: "A2N0OALIND",
  //   apiKey: "13524966e85ff124cfb5870579d344cb",
  //   indexName: 'Product_development',
  //   urlSync: true
  // });

//   search.addWidget(
//     instantsearch.widgets.searchBox({
//       container: '#q',
//       placeholder: 'Search for products...',
//       autofocus: true
//     })
//   );

//   search.addWidget(
//     instantsearch.widgets.hits({
//       container: '#hits',
//       templates: {
//         empty: 'No results for <q>{{ query }}</q>',
//         item: item_template
//       },
//       hitsPerPage: 6
//     })
//   );



//   search.start();

  // const autocomplete = instantsearch.connectors.connectAutocomplete(
  //   ({ indices, refine, widgetParams }, isFirstRendering) => {
  //     // We get the onSelectChange callback from the widget params
  //     const { container, onSelectChange } = widgetParams;

  //     if (isFirstRendering) {
  //       container.html('<select id="ais-autocomplete"></select>');
  //       // $(function() {

  //       container.find('select').selectize({
  //         // ...
  //         options: [],
  //         valueField: 'title',
  //         labelField: 'title',
  //         searchField: "title",
  //         // highlight: true,
  //         onType: refine,
  //         onBlur() {
  //           refine(this.getValue());
  //         },
  //         score() {
  //           return function() {
  //             return 1;
  //           };
  //         },
  //         onChange(value) {
  //           // We call the provided callback each time a value is selected
  //           onSelectChange(value);
  //           refine(value);
  //         },
  //       });
  //       // });

  //       return;
  //     }

  //     const [select] = container.find('select');

  //     indices.forEach(index => {
  //       select.selectize.clearOptions();
  //       index.results.hits.forEach(hit => select.selectize.addOption(hit));
  //       select.selectize.refreshOptions(select.selectize.isOpen);
  //     });
  //   }
  // );

  const searchClient = algoliasearch(
    'U9L5TDQXIN',
    '1f741c451c7cb0ffe440766809f77cf5'
  );

  const search = instantsearch({
    searchClient,
    indexName: 'niches_development',
    urlSync: true
  });

  search.addWidgets([
    instantsearch.widgets.configure({
      hitsPerPage: 10
    }),
    instantsearch.widgets.hits({
      container: '#hits',
      templates: {
        item: '<strong>Hit {{objectID}}</strong>: {{{_highlightResult.title.value}}}',
      },
    })
  ]);

  const suggestions = instantsearch({
    searchClient,
    indexName: 'niches_development',
    urlSync: true
  });

  suggestions.addWidgets([
    instantsearch.widgets.configure({
      hitsPerPage: 5
    }),
    autocomplete({
      container: $('#autocomplete'),
      onSelectChange(value) {
        // Now we can trigger the search on our main instance
        // each time the value inside the dropdown is selected
        search.helper.setQuery(value).search();
      },
    })
  ]);

  suggestions.start();
  search.start();
});

