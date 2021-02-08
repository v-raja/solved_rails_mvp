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
        // stateMapping: instantsearch.stateMappings.simple(),
        // router: router
      //   searchRouting
      // }
      // searchFunction(helper) {
      //   if (helper.state.query.length < 2) {
      //     document.querySelector('#app_body').style.display = '';
      //     document.querySelector('#results').style.display = 'none';
      //     return; // no search if less than 2 character
      //   }

      //   const container = document.querySelector('#results');
      //   container.style.display = helper.state.query === '' ? 'none' : '';

      //   const empty_search = document.querySelector('#app_body');
      //   empty_search.style.display = helper.state.query === '' ? '' : 'none';

      //   helper.search();
      // }
    });

    search.addWidgets([
      instantsearch.widgets.configure({
        attributesToSnippet: ['description_text:60'],
        // highlightedTagName: "mark",
        // hitsPerPage: 12,
        // filters: 'NOT categories:"Cell Phones"'
      }),
      instantsearch.widgets.searchBox({
        container: '#searchbox_posts',
        placeholder: "Search for a problem by keywords",
        searchAsYouType: true,
        cssClasses: {
          form: "relative flex items-center",
          input: "block pl-9 pr-4 py-2 w-full shadow-none hover:shadow-md rounded-lg placeholder-gray-700 bg-white border-0 border-gray-400 hover:border-transparent focus:outline-none focus:shadow-md focus:ring-transparent focus:border-transparent text-gray-900",
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
          // item: "m-0 p-0 px-5 bg-white overflow-x-auto border border-gray-400 w-full hover:border-gray-900 group",
          item: ""
        },
        transformItems(items) {
          var itemz = items.map(item => ({
            ...item,
            show_votes: item.nb_votes > 0,
            // keyword_list: handleKeywords(item._highlightResult.keyword_list),
            // other_keyword_list: otherKeywords(item._highlightResult.keyword_list),
            // display_other_keywords: other_keywords !== "",
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
                            <div class=" text-xxs md:text-xs text-gray-700 flex items-center mr-6 overflow-x-scroll disable-scrollbars">
                              <div class=" flex-shrink-0 ">
                                {{{user.name}}}
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
      //{{#helpers.snippet}}{ "attribute": "description_text", "highlightedTagName": "mark" }{{/helpers.snippet}}

    //   `<div class=" video aspect-w-7 aspect-h-4 mt-6 hidden">
    //   <div class=" flex flex-col w-full h-full overflow-y-auto space-y-2">
    //     <div class=" aspect-w-16 aspect-h-9 w-full flex-shrink-0 youtube-player" data-id="{{{videos.0.youtube_id}}}">

    //       <div class="group" data-id="{{{videos.0.youtube_id}}}" onclick="convertToIframe(event)">
    //         <img src="//img.youtube.com/vi/{{{videos.0.youtube_id}}}/sddefault.jpg" class="h-full w-full object-cover cursor-pointer"/>
    //         <div class="absolute w-16 inset-1/2 h-16 -m-8 cursor-pointer">
    //           <svg xmlns="http://www.w3.org/2000/svg" class="fill-current text-black opacity-80 group-hover:opacity-100 group-hover:text-red-yt" viewBox="0 -77 512.00213 512">
    //             <path d="m501.453125 56.09375c-5.902344-21.933594-23.195313-39.222656-45.125-45.128906-40.066406-10.964844-200.332031-10.964844-200.332031-10.964844s-160.261719 0-200.328125 10.546875c-21.507813 5.902344-39.222657 23.617187-45.125 45.546875-10.542969 40.0625-10.542969 123.148438-10.542969 123.148438s0 83.503906 10.542969 123.148437c5.90625 21.929687 23.195312 39.222656 45.128906 45.128906 40.484375 10.964844 200.328125 10.964844 200.328125 10.964844s160.261719 0 200.328125-10.546875c21.933594-5.902344 39.222656-23.195312 45.128906-45.125 10.542969-40.066406 10.542969-123.148438 10.542969-123.148438s.421875-83.507812-10.546875-123.570312zm0 0"></path><path d="m204.96875 256 133.269531-76.757812-133.269531-76.757813zm0 0" fill="#fff"></path>
    //           </svg>
    //         </div>
    //       </div>
    //     </div>
    //   </div>
    // </div>` +



      // <iframe allowfullscreen="1" class=" h-full w-full" frameborder="0" src="https://www.youtube-nocookie.com/embed/{{{videos.0.youtube_id}}}?rel=0"></iframe>
      instantsearch.widgets.refinementList({
        container: '#tags',
        attribute: '_tags',
        searchable: true,
        showMore: true,
        limit: 8,
        templates: {
          item: `
          <a href="{{url}}" class="{{#isRefined}}font-bold{{/isRefined}}">
            <span class="ml-1 hover:underline">{{label}}  ({{count}})</span>
          </a>
        `,
        // searchableNoResults: `noResults`
        },
        placeholder: "Search for a tag",
        cssClasses: {
          searchableForm: "border-0 flex-shrink-0",
          searchableInput: "appearance-none py-1 bg-white text-sm w-full md:w-44 border-0 focus:outline-none focus:ring-0 ",
          // searchableInput: "bg-transparent text-sm w-44 border-0 focus:outline-none focus:ring-0 focus:border-secondary border-b-2 border-secondary",
          // root: the root element of the widget.
          list: "mt-3 space-y-2",
          item: "text-sm",
          // selectedItem: each selected item in the list.
          label: "text-sm",
          noResults: "text-sm mt-2",
          // checkbox: each checkbox element (when using the default template).
          // labelText: each label text element.
          showMore: "text-sm mt-4 underline font-medium hover:underline focus:outline-none",
          disabledShowMore: "hidden",
          // count: each count element (when using the default template).
          // searchableRoot: "flex-shrink-0",
          searchableSubmit: "hidden",
          // searchableSubmitIcon: the reset button icon of the search box.
          searchableReset: "hidden"
          // searchableLoadingIndicator: the submit button element of the search box.
          // searchableLoadingIcon: the submit button icon of the search box.
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
          delete: "ml-1 text-xxs font-bold pt-0.5"
        },
        transformItems(items) {
          var itemz = items.map(item => ({
            ...item,
            label: item.label === "_tags" ? "tags" : "communities",
            // keyword_list: handleKeywords(item._highlightResult.keyword_list),
            // other_keyword_list: otherKeywords(item._highlightResult.keyword_list),
            // display_other_keywords: other_keywords !== "",
          }));
          return itemz;
        },
      }),

      instantsearch.widgets.refinementList({
        container: '#communities',
        attribute: 'communities.title',
        searchable: true,
        showMore: true,
        limit: 6,
        templates: {
          item: `
          <a href="{{url}}" class="{{#isRefined}}font-bold{{/isRefined}}">
            <span class="text-sm hover:underline">{{label}} ({{count}})</span>
          </a>
        `,
        },
        placeholder: "Search for a community",
        cssClasses: {
          searchableForm: "border-0 flex-shrink-0",
          // searchableInput: "bg-transparent text-sm w-44 border-0 focus:outline-none focus:ring-0 focus:border-secondary border-b-2 border-secondary",
          searchableInput: "appearance-none py-1 bg-white text-sm w-full md:w-44 border-0 focus:outline-none focus:ring-0 ",
          // root: the root element of the widget.
          list: "mt-3 space-y-3",
          item: "text-sm leading-tight",
          // selectedItem: each selected item in the list.
          label: "leading-none",
          // checkbox: each checkbox element (when using the default template).
          // labelText: each label text element.
          noResults: "text-sm mt-2",
          showMore: "text-sm mt-4 underline font-medium hover:underline focus:outline-none",
          disabledShowMore: "hidden",
          // count: each count element (when using the default template).
          // searchableRoot: "flex-shrink-0",
          searchableSubmit: "hidden",
          // searchableSubmitIcon: the reset button icon of the search box.
          searchableReset: "hidden",
          // searchableForm: "border-0 flex-shrink-0 w-min",
          // searchableInput: "bg-transparent border-0 focus:outline-none focus:ring-0 focus:border-secondary border-b-3 border-secondary",
          // list: "mt-4 space-y-4",
          // searchableSubmit: "hidden",
          // searchableReset: "hidden",
          // item: "leading-none",
          // showMore: "text-sm mt-4 underline font-medium hover:underline focus:outline-none",
          // disabledShowMore: "hidden"
        }
      }),



    ]);

    search.start();
  }
})

