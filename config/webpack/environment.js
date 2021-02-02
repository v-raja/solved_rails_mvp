const { environment } = require('@rails/webpacker')

if (process.env.WEBPACK_ANALYZE === "true") {
  const BundleAnalyzerPlugin = require('webpack-bundle-analyzer').BundleAnalyzerPlugin
  environment.plugins.append('BundleAnalyzerPlugin', new BundleAnalyzerPlugin())
}

const webpack = require('webpack')
environment.plugins.prepend('Provide',
  new webpack.ProvidePlugin({
    $: 'jquery/src/jquery',
    jQuery: 'jquery/src/jquery',
    "window.jQuery": "jquery"
  })
)

environment.splitChunks()


// environment.plugins.append(
//   'Provide',
//   new webpack.ProvidePlugin({
//     $: 'jquery',
//     jQuery: 'jquery',
//     jquery: 'jquery',
//   }),
// )

module.exports = environment



// const { basename, join, resolve } = require('path')
// const { existsSync } = require('fs')

// const { environment } = require('@rails/webpacker')

// const webpack = require('webpack')
// environment.plugins.prepend('Provide',
//   new webpack.ProvidePlugin({
//     $: 'jquery/src/jquery',
//     jQuery: 'jquery/src/jquery',
//     "window.jQuery": "jquery"
//   })
// )

// if (process.env.WEBPACK_ANALYZE === "true") {
//   const BundleAnalyzerPlugin = require('webpack-bundle-analyzer').BundleAnalyzerPlugin
//   environment.plugins.append('BundleAnalyzerPlugin', new BundleAnalyzerPlugin())
// }


// const { ManifestPlugin } = require('webpack-manifest-plugin')

// const { paths, publicPath } = require('./configuration.js')

// const manifestName = join(resolve(paths.output, paths.entry), 'manifest.json')
// const manifest = existsSync(manifestName) ? require(manifestName) : {}

// const vendorManifestName = join(resolve(paths.output, paths.entry), 'vendor-dll-manifest.json')
// const vendorManifest = existsSync(vendorManifestName) ? require(vendorManifestName) : {}

// environment.plugins.prepend(
//   'Manifest',
//    new ManifestPlugin({ fileName: 'manifest.json', publicPath, writeToFileEmit: true, cache: manifest })
// );

// environment.plugins.prepend(
//   'DLL',
//   new webpack.DllReferencePlugin({
//     context: resolve(paths.output, paths.entry),
//     manifest: vendorManifest
//   })
// );

// module.exports = environment
