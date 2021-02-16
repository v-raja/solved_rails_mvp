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
  windowTitle(state) {

    const query = state.q;

    const queryTitle = query ? `Results for "${query}" | solved` : 'Search | solved';

    return queryTitle;
  },

  createURL({ qsModule, routeState, location }) {
    const urlParts = location.href.match(/^(.*?)\/search\/solutions/);
    const baseUrl = `${urlParts ? urlParts[1] : ''}/`;

    const queryParameters = {};

    if (routeState.query) {
      queryParameters.query = encodeURIComponent(routeState.query);
    }
    if (routeState.page !== 1) {
      queryParameters.page = routeState.page;
    }
    if (routeState.tags) {
      queryParameters.tags = routeState.tags.map(encodeURIComponent);
    }
    if (routeState.communities) {
      queryParameters.communities = routeState.communities.map(encodeURIComponent);
    }
    if (routeState.platforms) {
      queryParameters.platforms = routeState.platforms.map(encodeURIComponent);
    }
    if (routeState.product) {
      queryParameters.product = routeState.product.map(encodeURIComponent);
    }

    const queryString = qsModule
      .stringify(queryParameters, {
        addQueryPrefix: true,
        arrayFormat: 'repeat',
      })
      .replace('query', 'q');
    return `${baseUrl}search/solutions${queryString}`;
  },

  parseURL({ qsModule, location }) {

    const { q = '', page, tags = [], communities = [], platforms = [], product = [] } = qsModule.parse(
      location.search.slice(1)
    );


    // `qs` does not return an array when there's a single value.
    const allTags = Array.isArray(tags) ? tags : [tags].filter(Boolean);
    const allCommunities = Array.isArray(communities) ? communities : [communities].filter(Boolean);
    const allPlatforms = Array.isArray(platforms) ? platforms : [platforms].filter(Boolean);
    const allProducts = Array.isArray(product) ? product : [product].filter(Boolean);

    return {
      q: decodeURIComponent(q),
      page,
      tags: allTags.map(decodeURIComponent),
      communities: allCommunities.map(decodeURIComponent),
      platforms: allPlatforms.map(decodeURIComponent),
      product: allProducts.map(decodeURIComponent)
    };
  },
});

const indexName = "solutions_" + process.env.NODE_ENV;

const stateMapping = {
  stateToRoute(uiState) {
    uiState = uiState[indexName]
    return {
      query: uiState.query,
      tags: uiState.refinementList && uiState.refinementList._tags,
      communities: uiState.refinementList && uiState.refinementList["communities.title"],
      platforms: uiState.refinementList && uiState.refinementList["platforms"],
      product: uiState.refinementList && uiState.refinementList["product.name"]
    };
  },

  routeToState(routeState) {
    if (process.env.NODE_ENV == "development") {
      return {
        "solutions_development": {
          query: routeState.q,
          page: routeState.page,
          refinementList: {
            "communities.title": routeState.communities,
            _tags: routeState.tags,
            platforms: routeState.platforms,
            "product.name": routeState.product
          },
        }
      };
    } else {
      return {
        "solutions_production": {
          query: routeState.q,
          page: routeState.page,
          refinementList: {
            "communities.title": routeState.communities,
            _tags: routeState.tags,
            platforms: routeState.platforms,
            "product.name": routeState.product
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
