const { environment } = require('@rails/webpacker')
const { VueLoaderPlugin } = require('vue-loader')
const vue = require('./loaders/vue')
const pug = require('./loaders/pug-plain')
const webpack = require('webpack')
const customConfig = require('./custom')

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

environment.config.merge(customConfig)
console.log(environment.config)

module.exports = environment
