import $ from 'jquery';
import 'select2';
import 'select2/dist/css/select2.css'

$(document).on('turbolinks:load', function() {
  if (document.getElementById("select_community")) {

    var algolia;
    if (gon.pxmalz) {
      algolia = algoliasearch(
        process.env.ALGOLIA_APP_ID,
        process.env.ALGOLIA_SEARCH_KEY, {
          headers: {
            'X-Algolia-UserToken': atob(gon.pxmalz)
          }
        }
      );
    } else {
      algolia = algoliasearch(
        process.env.ALGOLIA_APP_ID,
        process.env.ALGOLIA_SEARCH_KEY
      );
    }

    var index = algolia.initIndex('niches_' + process.env.RAILS_ENV);

    $('#general_tags').select2({
      placeholder: 'marketing, sales, crm, team management, engineering, human resources',
      multiple: true,
      tags: true
    });

    $('#platform_select').select2({
      placeholder: 'Web App, macOS, Slack, Shopify, Chrome Extension',
      multiple: true,
      tags: true
    });

    $('#group_select').select2({
      placeholder: 'Small and Medium-sized Businesses, Indie Hackers',
      multiple: true,
      tags: true
    });


    $('#niche_specific_tags').select2({
      placeholder: 'design request management, classroom management, online learning',
      multiple: true,
      tags: true,
      language: {
        noResults: function() {
          return 'No tags yet';
        },
      },
    });

    $('#select_community').select2({
      language: {
        inputTooShort: function() {
          return 'Please enter 3 or more character to search';
        },
      },
      closeOnSelect: true,
      placeholder: 'Search for an industry / occupation',
      multiple: true,
      maximumSelectionLength: 8,
      ajax: {
        // Custom transport to call Algolia's API
        transport: function(params, success, failure) {
          var queryParams = params.data;
          var q = queryParams.query;
          delete queryParams.query;
          index.search(q, queryParams).then(success, failure);
        },
        // build Algolia's query parameters (with page starting at 0)
        data: function(params) {
          return { query: params.term, hitsPerPage: 8, page: (params.page || 1) - 1, highlightPreTag: '<strong>', highlightPostTag: '</strong>' };
          // filters: `is_postable=1`
        },

        // return Algolia's results
        processResults: function(data) {
          return {
            results: data.hits.map(function(item) {
                    return {...item,
                            id : item.objectID,
                    };
                  }),
            pagination: {
              more: data.page + 1 < data.nbPages
            }
          };
        }
      },
      escapeMarkup: function (markup) { return markup; },
      // minimumInputLength: 3,
      cache: false,
      templateSelection: function(contact) {
        if (contact.text == 'Choose a contact'){
          return "Choose a contact";
        } else {
          return contact.title;
        }
        // return contact._highlightResult.title.value;
      },
      templateResult: function(contact) {
        if (contact.text == 'Searching…'){
          return contact.text;
        } else {
          return "<div class='select2-user-result'>" +
                contact._highlightResult.title.value +
                '<br />' +
                '<small class="text-muted">' + contact.type + '</small>' +
                "</div>";
        }
      }
    });




    // function updatePreview(data) {
    //   $("#product_builder").hide();
    //   document.getElementById("product_name").textContent = data.name;
    //   document.getElementById("product_logo").src = data.thumbnail_url;
    //   document.getElementById('product-name').value = '';
    //   document.getElementById('thumbnail-url').value = '';
    //   $("#solution_plan_id").children().remove();
    //   var listitems = [];
    //   listitems += `<option value>Add a new plan</option>`;
    //   $.each(data.plans,function(key, value) {
    //     listitems += '<option value="' + value.id + '">' + value.name + '</option>';
    //   });
    //   $("#solution_plan_id").append(listitems);
    // }

    // var product_index = algolia.initIndex('products_' + process.env.RAILS_ENV);
    // var $product_select = $('#solution_product_id');
    // $product_select.select2({
    //   language: {
    //     inputTooShort: function() {
    //       return 'Please enter 2 or more character to search';
    //     },
    //   },
    //   // minimumInputLength: 2,
    //   // allowClear: true,
    //   // placeholder: 'Search for a product',
    //   ajax: {
    //     // Custom transport to call Algolia's API
    //     transport: function(params, success, failure) {
    //       var queryParams = params.data;
    //       var q = queryParams.query;
    //       delete queryParams.query;
    //       product_index.search(q, queryParams).then(success, failure);
    //     },
    //     // build Algolia's query parameters (with page starting at 0)
    //     data: function(params) {
    //       return { query: params.term, hitsPerPage: 6, page: (params.page || 1) - 1, highlightPreTag: '<strong>', highlightPostTag: '</strong>' };
    //       // filters: `is_postable=1`
    //     },

    //     // return Algolia's results
    //     processResults: function(data) {
    //       data.hits.unshift({thumbnail_url: "https://user-images.githubusercontent.com/101482/29592647-40da86ca-875a-11e7-8bc3-941700b0a323.png", text: "Add a new product", objectID: 0});
    //       return {
    //         results: data.hits.map(function(item) {
    //                 return {...item,
    //                         id : item.objectID,
    //                 };
    //               }),
    //         pagination: {
    //           more: data.page + 1 < data.nbPages
    //         }
    //       };
    //     }
    //   },
    //   escapeMarkup: function (markup) { return markup; },
    //   cache: false,
    //   templateSelection: function(option) {

    //     if (option.text) {
    //       $("#product_builder").show()
    //       document.getElementById("product_name").textContent = "Product name";
    //       document.getElementById("product_logo").src = option.thumbnail_url;
    //       return option.text;
    //     } else {
    //       updatePreview(option);
    //       return option.name;
    //     }
    //   },
    //   templateResult: function(product) {
    //     if (product.text){
    //       return "<div class='select2-user-result'>" +
    //             product.text +
    //           "</div>";
    //     } else {
    //       return "<div class='select2-user-result'>" +
    //               product._highlightResult.name.value +
    //             "</div>";
    //     }
    //   }
    // })


  }
});
