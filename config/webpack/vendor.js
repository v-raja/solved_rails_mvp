/* eslint global-require: 0 */

const { join, resolve } = require('path')
const webpack = require('webpack')
const WebpackManifestPlugin = require('webpack-manifest-plugin')

// const environment = require('./environment')
const { environment } = require('@rails/webpacker')
const { paths } = require('./configuration.js')

environment.plugins.prepend(
  'DLL',
  new webpack.DllPlugin({
    path: join(resolve(paths.output, paths.entry), 'vendor-dll-manifest.json'),
    name: '[name]',
    context: resolve(paths.output, paths.entry)
  })
)

const config = environment.toWebpackConfig()

// list of packages that will be served from vendor.js
config.entry = {
  vendor: [
    'jquery',
    'select2'
  ]
}

// set library name to 'vendor'
config.output.library = '[name]'
config.stats = 'errors-only'

module.exports = config

