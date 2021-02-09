import searchRouting from '../../src/search_routing';


$(document).on('turbolinks:load', function() {
  if (document.getElementById("searchbox_posts")) {
    var searchClient;
    if (gon.ffi) {
      searchClient = algoliasearch(
        process.env.ALGOLIA_APP_ID,
        process.env.ALGOLIA_SEARCH_KEY, {
          headers: {
            'X-Algolia-UserToken': gon.current_user_id
          }
        }
      );
    } else {
      searchClient = algoliasearch(
        process.env.ALGOLIA_APP_ID,
        process.env.ALGOLIA_SEARCH_KEY
      );
    }

    const search = instantsearch({
      searchClient,
      indexName: gon.index_name + '_' + process.env.RAILS_ENV,
      // urlSync: true,
      routing: searchRouting,
    });

    search.addWidgets([
      instantsearch.widgets.configure({
        attributesToSnippet: ['description_text:60'],
      }),
      instantsearch.widgets.searchBox({
        container: '#searchbox_posts',
        placeholder: "What daily task do you find painful?",
        searchAsYouType: true,
        cssClasses: {
          form: "relative flex items-center",
          input: "block pl-9 pr-4 py-2 w-full shadow-none hover:shadow-md rounded-lg placeholder-gray-500 bg-white border-0 border-gray-400 hover:border-transparent focus:outline-none focus:shadow-md focus:ring-transparent focus:border-transparent text-gray-900",
          submit: "absolute inset-y-0 left-3 flex items-center",
          submitIcon: "h-4 w-4 text-gray-600 fill-current",
          reset: "hidden"
        }
      }),

      instantsearch.widgets.hits({
        container: '#hits',
        cssClasses: {
          root: "w-full",
          list: "w-full grid grid-cols-1 gap-x-2 gap-y-6 sm:grid-cols-2 md:grid-cols-3 xl:grid-cols-4",
          item: ""
        },
        transformItems(items) {
          var itemz = items.map(item => ({
            ...item,
            show_votes: item.nb_votes > 0,
            price: item.product.plan.price === 0 ? "Free" : item.product.plan.is_price_per_user ? `\$${item.product.plan.price} /u/mo.` : `\$${item.product.plan.price} /mo.`,
            educational_use: item.product.plan.is_for_education ? "(for Non-profit / Education)" : "",
          }));
          console.log(itemz);
          return itemz;
        },
        escapeHTML: false,
        templates: {
          empty: 'No solutions have been found for "{{ query }}"',
          item: '<a href={{{url}}} target="_blank">'+
                  '<div class="">' +
                      `<div class=" flex flex-col">
                        <div class=" video aspect-w-7 aspect-h-4 ">
                          <div class=" flex flex-col w-full h-full overflow-y-auto space-y-2">
                            <div class=" aspect-w-16 aspect-h-9 w-full flex-shrink-0 youtube-player relative">
                              <div class="group" data-id="{{{videos.0.youtube_id}}}" onclick="convertToIframe(event)">
                                {{#show_votes}}
                                  <div class="absolute right-2 top-2 text-white font-bold text-sm p-2 bg-primary rounded-lg">
                                    <div class="flex items-centerjustify-center place-self-center">
                                      {{{nb_votes}}}
                                      <div class="ml-0.5">
                                        ▲
                                      </div>
                                    </div>
                                  </div>
                                {{/show_votes}}
                                <img src="//img.youtube.com/vi/{{{videos.0.youtube_id}}}/sddefault.jpg" class="h-full w-full object-cover cursor-pointer"/>
                              </div>
                            </div>
                          </div>
                        </div>
                        <a href="{{{url}}}">
                          <div class=" flex mt-2">
                            <div class=" flex-shrink-0">
                              <img class="w-8 h-8 object-cover rounded-full" src="{{{product.thumbnail_url}}}">
                            </div>
                            <div class=" flex-grow flex flex-wrap ml-2">
                              <div class=" w-full text-xs md:text-sm font-medium two-lines-only">
                                <div class=" flex-shrink-0 ">
                                  {{{_highlightResult.title.value}}}
                                </div>
                              </div>
                            <div class=" mt-1 text-xxs md:text-xs w-full text-gray-700 flex items-center md:mr-2 overflow-x-scroll disable-scrollbars">
                              <div class=" flex-shrink-0 ">
                                {{{communities.0.title}}}
                              </div>
                            </div>
                            <div class=" text-xxs md:text-xs text-gray-700 flex items-center md:mr-2 overflow-x-scroll disable-scrollbars">
                              <div class=" flex-shrink-0 ">
                                {{{user.name}}} · {{{price}}} {{{educational_use}}}
                              </div>
                            </div>
                          </div>
                        </div>
                      </a>
                    </div>` +


                    `<div class="pt-2 text-gray-700 text-xs px-2 h-24 overflow-y-auto">

                    {{{_highlightResult.description_text.value}}}
                    </div>` +



                    '</div>' +
                  '</div>' +
                '</a>'
        },
      }),

      instantsearch.widgets.refinementList({
        container: '#tags',
        attribute: '_tags',
        searchable: true,
        showMore: true,
        limit: 8,
        templates: {
          item: `
          <div class="{{#isRefined}}font-medium{{/isRefined}} flex items-center cursor-pointer">
            <input type="checkbox" class="cursor-pointer appearance-none border-transparent rounded checked:bg-secondary checked:border-transparent  w-4 h-4" value="{{value}}" {{#isRefined}}checked="true"{{/isRefined}}/>
            <span class="ml-1 text-xs hover:underline">{{label}}  ({{count}})</span>
          </div>
        `,
        },
        placeholder: "Search for a tag",
        cssClasses: {
          searchableForm: "border-0 flex-shrink-0",
          searchableInput: "appearance-none py-1 bg-white text-sm w-full md:w-44 border-0 focus:outline-none focus:ring-0 ",
          list: "mt-3 space-y-2",
          item: "",
          label: "",
          noResults: "text-sm mt-2",
          showMore: "text-sm mt-4 underline font-medium hover:underline focus:outline-none",
          disabledShowMore: "hidden",
          searchableSubmit: "hidden",
          searchableReset: "hidden"
        }
      }),

      instantsearch.widgets.currentRefinements({
        container: '#current-refinements',
        cssClasses: {
          root: '',
          item: 'text-sm rounded-md bg-gray-800 text-white font-semibold border px-3 py-2',
          category: "ml-2",
          label: "text-xs uppercase",
          categoryLabel: "text-xs ml-1",
          delete: "ml-1 text-xxs font-bold pt-1 pl-1 pr-3 focus:outline-none"
        },
        transformItems(items) {
          const attributeDisplayValue = {
            "_tags": "tags",
            "communities.title": "communities",
            "product.plan.price": "price",
            "product.plan.price_facet": "price",
            "product.plan.is_free": "Only free"
          };

          var itemz = items.map(item => ({
            ...item,
            label: attributeDisplayValue[item.label] ? attributeDisplayValue[item.label] : item.label,
          }));
          return itemz;
        },
      }),


      instantsearch.widgets.refinementList({
        container: '#price_facet',
        attribute: 'product.plan.price_facet',
        operator: 'and',

        templates: {
          item:  `
            <div class="{{#isRefined}}font-medium{{/isRefined}} flex items-center cursor-pointer">
              <input type="checkbox" class="cursor-pointer appearance-none border-transparent rounded checked:bg-secondary checked:border-transparent  w-4 h-4" value="{{value}}" {{#isRefined}}checked="true"{{/isRefined}}/>
              <span class="ml-1 text-xs hover:underline">{{{label}}}</span>
            </div>
          `
        },
        cssClasses: {
          searchableForm: "border-0 flex-shrink-0",
          searchableInput: "appearance-none py-1 bg-white text-sm w-full md:w-44 border-0 focus:outline-none focus:ring-0 ",
          list: "mt-3 space-y-2",
          item: "",
          noResults: "text-sm mt-2",
          showMore: "text-sm mt-4 underline font-medium hover:underline focus:outline-none",
          disabledShowMore: "hidden",
          searchableSubmit: "hidden",
          searchableReset: "hidden"

        }
      }),

      instantsearch.widgets.rangeInput({
        container: '#price_range',
        attribute: 'product.plan.price',
        templates: {
          separatorText: 'to',
          submitText: 'go',
        },
        cssClasses: {
          form: "flex items-center",
          inputMin: "appearance-none py-1 pr-0 flex-grow  bg-white text-sm w-full border-0 focus:outline-none focus:ring-0 ",
          // label: "text-xs mx-5 flex-shrink-0",
          inputMax: "appearance-none py-1 pr-0 flex-grow bg-white text-sm w-full border-0 focus:outline-none focus:ring-0 ",
          submit: "text-xs p-2 flex-shrink-0 focus:outline-none",
          separator: "text-xs mx-1 flex-shrink-0"
          // submit: the submit button.
        }
      }),

      instantsearch.widgets.toggleRefinement({
        container: '#is_free',
        attribute: 'product.plan.is_free',
        templates: {
          labelText:  "Show only free"
        },
        cssClasses: {
          checkbox: "cursor-pointer appearance-none border-transparent rounded checked:bg-secondary hover:bg-white checked:border-transparent  w-4 h-4",
          labelText: "ml-1 text-xs hover:underline",
          root: "flex items-center cursor-pointer",
        }
      }),



      instantsearch.widgets.refinementList({
        container: '#communities',
        attribute: 'communities.title',
        searchable: true,
        showMore: true,
        limit: 6,
        templates: {
          item: `
          <div class="{{#isRefined}}font-medium{{/isRefined}} flex items-center cursor-pointer">
            <input type="checkbox" class="cursor-pointer appearance-none border-transparent rounded checked:bg-secondary checked:border-transparent  w-4 h-4" value="{{value}}" {{#isRefined}}checked="true"{{/isRefined}}/>
            <span class="ml-1 text-xs hover:underline">{{label}}  ({{count}})</span>
          </div>
        `,
        },
        placeholder: "Search for a community",
        cssClasses: {
          searchableForm: "border-0 flex-shrink-0",
          searchableInput: "appearance-none py-1 bg-white text-sm w-full md:w-44 border-0 focus:outline-none focus:ring-0 ",
          list: "mt-3 space-y-3",
          item: "leading-tight",
          label: "leading-none",
          noResults: "text-sm mt-2",
          showMore: "text-sm mt-4 underline font-medium hover:underline focus:outline-none",
          disabledShowMore: "hidden",
          searchableSubmit: "hidden",
          searchableReset: "hidden",
        }
      }),

      instantsearch.widgets.refinementList({
        container: '#platforms',
        attribute: 'platforms',
        searchable: true,
        showMore: true,
        limit: 4,
        templates: {
          item: `
          <div class="{{#isRefined}}font-medium{{/isRefined}} flex items-center cursor-pointer">
            <input type="checkbox" class="cursor-pointer appearance-none border-transparent rounded checked:bg-secondary checked:border-transparent  w-4 h-4" value="{{value}}" {{#isRefined}}checked="true"{{/isRefined}}/>
            <span class="ml-1 text-xs hover:underline">{{label}}  ({{count}})</span>
          </div>
        `,
        searchableNoResults: `noResults`
        },
        placeholder: "Search for a platform",
        cssClasses: {
          searchableForm: "border-0 flex-shrink-0",
          searchableInput: "appearance-none py-1 bg-white text-sm w-full md:w-44 border-0 focus:outline-none focus:ring-0 ",
          list: "mt-3 space-y-2",
          item: "",
          noResults: "text-sm mt-2",
          showMore: "text-sm mt-4 underline font-medium hover:underline focus:outline-none",
          disabledShowMore: "hidden",
          searchableSubmit: "hidden",
          searchableReset: "hidden"
        }
      }),

    ]);

    search.start();
  }

})

