const { environment } = require('@rails/webpacker')
const { VueLoaderPlugin } = require('vue-loader')
const vue = require('./loaders/vue')
const pug = require('./loaders/pug-plain')
const webpack = require('webpack')

environment.loaders.append('vue', vue)

environment.plugins.prepend(
  'Provide',
  new webpack.ProvidePlugin({
    _: 'lodash',
  })
)

environment.plugins.prepend('VueLoaderPlugin', new VueLoaderPlugin())
environment.loaders.prepend('pug-plain', pug)
environment.loaders.prepend('vue', vue)

module.exports = environment
