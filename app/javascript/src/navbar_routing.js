/* global instantsearch */

const encodedCategories = {
  Cameras: 'Cameras & Camcorders',
  Cars: 'Car Electronics & GPS',
  Phones: 'Cell Phones',
  TV: 'TV & Home Theater',
};

const decodedCategories = Object.keys(encodedCategories).reduce((acc, key) => {
  const newKey = encodedCategories[key];
  const newValue = key;

  return {
    ...acc,
    [newKey]: newValue,
  };
}, {});

// Returns a slug from the category name.
// Spaces are replaced by "+" to make
// the URL easier to read and other
// characters are encoded.
function getCategorySlug(name) {
  const encodedName = decodedCategories[name] || name;

  return encodedName
    .split(' ')
    .map(encodeURIComponent)
    .join('+');
}

function getIndexName(name) {
  name.toLowerCase();
}

// Returns a name from the category slug.
// The "+" are replaced by spaces and other
// characters are decoded.
function getCategoryName(slug) {
  const decodedSlug = encodedCategories[slug] || slug;

  return decodedSlug
    .split('+')
    .map(decodeURIComponent)
    .join(' ');
}

const router = instantsearch.routers.history({
  // windowTitle(state) {

  //   const query = state.q;

  //   const queryTitle = query ? `Results for "${query}" | solved` : 'Search | solved';

  //   return queryTitle;
  // },

  createURL({ qsModule, routeState, location }) {
    // const urlParts = location.href.match(/^(.*?)/);
    // const baseUrl = `${urlParts ? urlParts[1] : ''}/`;
    const baseUrl = '';

    const queryParameters = {};

    if (routeState.query) {
      queryParameters.query = encodeURIComponent(routeState.query);
    }
    if (routeState.page !== 1) {
      queryParameters.page = routeState.page;
    }
    if (routeState.type) {
      queryParameters.type = routeState.type.map(encodeURIComponent);
    }


    const queryString = qsModule
      .stringify(queryParameters, {
        addQueryPrefix: true,
        arrayFormat: 'repeat',
      })
      .replace('query', 'q');
    return `${baseUrl}${queryString}`;
  },

  parseURL({ qsModule, location }) {

    const { q = '', page, type = [] } = qsModule.parse(
      location.search.slice(1)
    );


    // `qs` does not return an array when there's a single value.
    const allTypes = Array.isArray(type) ? type : [type].filter(Boolean);

    return {
      q: decodeURIComponent(q),
      page,
      type: allTypes.map(decodeURIComponent)
    };
  },
});

const indexName = "niches_" + process.env.NODE_ENV;

const stateMapping = {
  stateToRoute(uiState) {
    uiState = uiState[indexName]
    return {
      query: uiState.query,
      type: uiState.refinementList && uiState.refinementList.type,
    };
  },

  routeToState(routeState) {
    if (process.env.NODE_ENV == "development") {
      return {
        "niches_development": {
          query: routeState.q,
          page: routeState.page,
          refinementList: {
            type: routeState.type,
          },
        }
      };
    } else {
      return {
        "niches_production": {
          query: routeState.q,
          page: routeState.page,
          refinementList: {
            type: routeState.type,
          },
        }
      };
    }
  },
};

const searchRouting = {
  router,
  stateMapping,
};

export default searchRouting;
