// import searchRouting from '../../src/solutions_routing';


$(document).on('turbolinks:load', function() {
  var indexName = gon.index_name + '_' + process.env.RAILS_ENV;

  const attributeDisplayValue = {
    // "_tags": "tags",
    "communities.title": "communities",
    "product.plan.price": "price",
    "product.plan.price_facet": "price type",
    "product.plan.is_free": "is free",
    "product.name": "product"
  };

  function SolutionListFilteredEventWithItems(items) {
    if (Array.isArray(items) && items.length) {
      const payload = {
        filters: items.map((item) => ({
          type: attributeDisplayValue[item.attribute] ? attributeDisplayValue[item.attribute] : item.attribute,
          value: item.refinements.map((refinement) => (
            refinement.label
          ))
        })),
        index: indexName
      };
      analytics.track("Solution List Filtered (Aggregate)", payload);
    }

  }

  if (document.getElementById("searchbox_posts")) {
    var searchClient;

    if (gon.pxmalz) {
      searchClient = algoliasearch(
        process.env.ALGOLIA_APP_ID,
        process.env.ALGOLIA_SEARCH_KEY, {
          headers: {
            'X-Algolia-UserToken': atob(gon.pxmalz)
          }
        }
      );
    } else {
      searchClient = algoliasearch(
        process.env.ALGOLIA_APP_ID,
        process.env.ALGOLIA_SEARCH_KEY
      );
    }

    // let search;

    import(/* webpackChunkName: "solutions_routing" */ '../../src/solutions_routing').then(module => {
      const search = instantsearch({
        searchClient,
        indexName: indexName,
        // urlSync: true,
        routing: module.default,
      });

      const sessionStorageCache = instantsearch.createInfiniteHitsSessionStorageCache();
      let timerId;
      search.addWidgets([
        instantsearch.widgets.configure({
          // attributesToSnippet: ['description_text:60'],
          clickAnalytics: true,
          hitsPerPage: 15
          // enablePersonalization: true,
        }),
        instantsearch.widgets.searchBox({
          container: '#searchbox_posts',
          showLoadingIndicator: true,
          placeholder: "What daily task do you find painful?",
          queryHook(query, refine) {
            clearTimeout(timerId);
            timerId = setTimeout(() => refine(query), 400);
          },
          searchAsYouType: true,
          cssClasses: {
            form: "relative flex items-center",
            input: "block pl-9 pr-4 py-2 w-full shadow-none hover:shadow-md rounded-lg placeholder-gray-500 bg-white border-0 border-gray-400 hover:border-transparent focus:outline-none focus:shadow-md focus:ring-transparent focus:border-transparent text-gray-900",
            submit: "absolute inset-y-0 left-3 flex items-center",
            submitIcon: "h-4 w-4 text-gray-600 fill-current",
            reset: "hidden"
          }
        }),

        instantsearch.widgets.infiniteHits({
          cache: sessionStorageCache,
          container: '#hits',
          cssClasses: {
            root: "w-full",
            list: "w-full grid grid-cols-2 gap-x-2 gap-y-6 md:grid-cols-3 xl:grid-cols-4",
            item: "",
            loadMore: "focus:outline-none mt-8 w-full underline place-self-center text-sm block text-black"
          },
          transformItems(items) {

            const solutions = items.map(hit => ({
                                        objectID: hit.objectID,
                                      }));

            if  (solutions.length > 0) {
              analytics.track("Solution List Viewed", {
                solutions
              });
            }

            var itemz = items.map(item => ({
              ...item,
              show_votes: item.nb_votes > 0,
              price: item.product.plan.price === 0 ? "Free" : item.product.plan.is_price_per_user ? `\$${item.product.plan.price} /u/mo.` : `\$${item.product.plan.price} /mo.`,
              educational_use: item.product.plan.is_for_education ? "(for Non-profit / Education)" : "",
              product_clicked_payload: encodeURIComponent(
                JSON.stringify({
                  objectID: item.objectID,
                  position: item.__position,
                  title: item.title,
                  index: indexName,
                  queryID: item.__queryID
                })
              ),

            }));



            // console.log(itemz);
            return itemz;
          },
          escapeHTML: false,
          templates: {
            showMoreText: "Show more solutions",
            empty: 'No solutions found for "{{ query }}". Try something else.',
            item: '<div>' +
                    '<div class="">' +
                        `<div class=" flex flex-col">
                          <div class=" video aspect-w-7 aspect-h-4 ">
                            <div class=" flex flex-col w-full h-full overflow-y-auto space-y-2">
                              <div class=" aspect-w-16 aspect-h-9 w-full flex-shrink-0 youtube-player relative">
                                <div class="group" data-id="{{{videos.0.youtube_id}}}" onclick="convertToIframe(event)">
                                  <picture class="btn-video h-full w-full object-cover cursor-pointer" data-product-clicked-payload="{{{product_clicked_payload}}}">
                                    <source srcset="//i.ytimg.com/vi_webp/{{{videos.0.youtube_id}}}/mqdefault.webp" type="image/webp">
                                    <source srcset="//i.ytimg.com/vi/{{{videos.0.youtube_id}}}/mqdefault.jpg" type="image/jpeg">
                                    <img src="//i.ytimg.com/vi/{{{videos.0.youtube_id}}}/mqdefault.jpg" loading="lazy" class="btn-video h-full w-full object-cover cursor-pointer" data-product-clicked-payload="{{{product_clicked_payload}}}">
                                  </picture>
                                </div>
                              </div>
                            </div>
                          </div>
                          <a href="{{{url}}}" data-turbolinks="false" class="btn-favorite" data-product-clicked-payload="{{{product_clicked_payload}}}">
                            <div class=" flex mt-2">
                              <div class=" flex-grow flex flex-wrap ml-1">
                                <div class=" w-full text-xs md:text-xssm font-medium two-lines-only">
                                  <div class=" flex-shrink-0 ">
                                  {{{_highlightResult.title.value}}}
                                  </div>
                                </div>
                              <div class="mt-1 text-xxs md:text-xs text-gray-700 flex items-center md:mr-2 overflow-x-scroll disable-scrollbars">
                                <div class=" flex-shrink-0 ">
                                  {{{product.name}}} · {{{price}}} {{{educational_use}}}
                                </div>
                              </div>
                              <div class=" text-xxs md:text-xs w-full text-gray-700 flex items-center md:mr-2 overflow-x-scroll disable-scrollbars">
                                <div class=" flex-shrink-0 ">
                                  {{{communities.0.title}}}
                                </div>
                              </div>
                            </div>
                          </div>
                        </a>
                      </div>` +


                      // `<div class="pt-2 text-gray-700 text-xs px-2 h-24 overflow-y-auto btn-desc-scroll" data-product-clicked-payload="{{{product_clicked_payload}}}">

                      //   {{{_highlightResult.description_text.value}}}
                      // </div>` +



                      '</div>' +
                    '</div>' +
                  '</div>'
          },
        }),

        // {{#show_votes}}
        //   <div class="absolute right-2 top-2 text-white font-bold text-sm p-2 bg-primary rounded-lg">
        //     <div class="flex items-centerjustify-center place-self-center">
        //       {{{nb_votes}}}
        //       <div class="ml-0.5">
        //         ▲
        //       </div>
        //     </div>
        //   </div>
        // {{/show_votes}}

        // instantsearch.widgets.refinementList({
        //   container: '#tags',
        //   attribute: '_tags',
        //   searchable: true,
        //   showMore: true,
        //   limit: 6,
        //   templates: {
        //   },
        //   placeholder: "Search for a tag",
        //   cssClasses: {
        //     searchableForm: "border-0 flex-shrink-0",
        //     searchableInput: "appearance-none py-1 bg-white text-sm w-full md:w-44 border-0 focus:outline-none focus:ring-0 ",
        //     list: "mt-3 spacey-y-2",
        //     count: "hidden",
        //     item: "flex items-center cursor-pointer",
        //     checkbox: "cursor-pointer appearance-none border-transparent rounded checked:bg-secondary checked:border-transparent  w-4 h-4",
        //     labelText: "ml-1 leading-tight text-xs cursor-pointer hover:underline",
        //     noResults: "text-sm mt-2",
        //     showMore: "ml-6 lowercase text-xs mt-2 underline hover:underline focus:outline-none",
        //     disabledShowMore: "hidden",
        //     searchableSubmit: "hidden",
        //     searchableReset: "hidden"
        //   }
        // }),

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
              // "_tags": "tags",
              "communities.title": "communities",
              "product.plan.price": "price",
              "product.plan.price_facet": "price",
              "product.plan.is_free": "Only free",
              "product.name": "product"
            };

            var itemz = items.map(item => ({
              ...item,
              label: attributeDisplayValue[item.label] ? attributeDisplayValue[item.label] : item.label,
            }));
            SolutionListFilteredEventWithItems(items);
            return itemz;
          },
        }),


        instantsearch.widgets.refinementList({
          container: '#price_facet',
          attribute: 'product.plan.price_facet',
          operator: 'and',
          cssClasses: {
            searchableForm: "border-0 flex-shrink-0",
            searchableInput: "appearance-none py-1 bg-white text-sm w-full md:w-44 border-0 focus:outline-none focus:ring-0 ",
            list: "mt-3",
            count: "hidden",
            item: "flex items-center cursor-pointer",
            checkbox: "cursor-pointer appearance-none border-transparent rounded checked:bg-secondary checked:border-transparent  w-4 h-4",
            labelText: "ml-1 leading-tight text-xs cursor-pointer hover:underline",
            noResults: "text-sm mt-2",
            showMore: "ml-6 lowercase text-xs mt-2 underline hover:underline focus:outline-none",
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
            form: "flex items-center w-56 lg:w-44 justify-between",
            inputMin: "appearance-none py-1 pr-0 w-full flex-grow bg-white text-sm border-0 focus:outline-none focus:ring-0 ",
            label: "w-full",
            inputMax: "appearance-none py-1 pr-0 w-full flex-grow bg-white text-sm border-0 focus:outline-none focus:ring-0 ",
            submit: "text-xs underline p-2 flex-shrink-0 focus:outline-none",
            separator: "text-xs mx-2 flex-shrink-0"
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
          cssClasses: {
            searchableForm: "border-0 flex-shrink-0",
            searchableInput: "appearance-none py-1 bg-white text-sm w-full md:w-44 border-0 focus:outline-none focus:ring-0 ",
            list: "mt-3 space-y-2",
            count: "hidden",
            item: "cursor-pointer",
            label: "flex items-center",
            checkbox: "cursor-pointer appearance-none border-transparent rounded checked:bg-secondary checked:border-transparent  w-4 h-4",
            labelText: "ml-2 text-xs cursor-pointer hover:underline leading-tight",
            noResults: "text-sm mt-2",
            showMore: "ml-6 lowercase text-xs mt-2 underline hover:underline focus:outline-none",
            disabledShowMore: "hidden",
            searchableSubmit: "hidden",
            searchableReset: "hidden"
          }
        }),

        instantsearch.widgets.refinementList({
        container: '#platforms',
          attribute: 'platforms',
          searchable: true,
          showMore: true,
          limit: 4,
          templates: {
            searchableNoResults: `No results`
          },
          placeholder: "Search for a platform",
          cssClasses: {
            searchableForm: "border-0 flex-shrink-0",
            searchableInput: "appearance-none py-1 bg-white text-sm w-full md:w-44 border-0 focus:outline-none focus:ring-0 ",
            list: "mt-3 spacey-y-2",
            count: "hidden",
            item: "flex items-center cursor-pointer",
            checkbox: "cursor-pointer appearance-none border-transparent rounded checked:bg-secondary checked:border-transparent  w-4 h-4",
            labelText: "ml-1 leading-tight text-xs cursor-pointer hover:underline",
            noResults: "text-sm mt-2",
            showMore: "ml-6 lowercase text-xs mt-2 underline hover:underline focus:outline-none",
            disabledShowMore: "hidden",
            searchableSubmit: "hidden",
            searchableReset: "hidden"
          }
        }),

        instantsearch.widgets.refinementList({
          container: '#products',
          attribute: 'product.name',
          searchable: true,
          showMore: true,
          limit: 4,
          templates: {
            searchableNoResults: `No results`
          },
          placeholder: "Search for a product",
          cssClasses: {
            searchableForm: "border-0 flex-shrink-0",
            searchableInput: "appearance-none py-1 bg-white text-sm w-full md:w-44 border-0 focus:outline-none focus:ring-0 ",
            list: "mt-3 spacey-y-2",
            count: "hidden",
            item: "flex items-center cursor-pointer",
            checkbox: "cursor-pointer appearance-none border-transparent rounded checked:bg-secondary checked:border-transparent  w-4 h-4",
            labelText: "ml-1 leading-tight text-xs cursor-pointer hover:underline",
            noResults: "text-sm mt-2",
            showMore: "ml-6 lowercase text-xs mt-2 underline hover:underline focus:outline-none",
            disabledShowMore: "hidden",
            searchableSubmit: "hidden",
            searchableReset: "hidden"
          }
        }),

        instantsearch.widgets.clearRefinements({
          container: '#clear_refinements',
          templates: {
            resetLabel: "clear"
          },
          cssClasses: {
            root: "p-0 m-0 leading-none",
            button: "text-xs underline m-0 p-0 leading-none pl-3 focus:outline-none",
            disabeldButton: "hidden"
          }
        }),

      ]);



      search.start();

      // platform, tags, communities, price_facet
      function SolutionListFilteredEvent(event, type) {
        const elem = event.target;
        if (elem.matches("input[type=checkbox]") && elem.checked) {
          // This sends an event when a filter is checked.
          const payload = {
            filters: [
              {
                type: type,
                value: elem.value
              }
            ],
            index: indexName
          };
          analytics.track("Solution List Filtered", payload);
        }
      }

      // document.querySelector("#tags").addEventListener("click", event => {
      //   SolutionListFilteredEvent(event, "tags");
      // });

      document.querySelector("#communities").addEventListener("click", event => {
        SolutionListFilteredEvent(event, "communities");
      });

      document.querySelector("#platforms").addEventListener("click", event => {
        SolutionListFilteredEvent(event, "platforms");
      });

      document.querySelector("#price_facet").addEventListener("click", event => {
        SolutionListFilteredEvent(event, "price type");
      });

      document.querySelector("#is_free").addEventListener("click", event => {
        SolutionListFilteredEvent(event, "is free");
      });


      document.addEventListener("click", event => {
        const elem = event.target.closest(".btn-favorite");
        if (elem !== null && elem.matches(".btn-favorite")) {
          const payload = JSON.parse(
            decodeURIComponent(
              elem.getAttribute("data-product-clicked-payload")
            )
          );
          analytics.track("Solution Clicked", payload);
        } else if (event.target !== null && event.target.matches(".btn-video")) {
          const payload = JSON.parse(
            decodeURIComponent(
              event.target.getAttribute("data-product-clicked-payload")
            )
          );
          analytics.track("Video Clicked", payload);
        }
      });
    });
  }

})

