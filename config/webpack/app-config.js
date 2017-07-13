const webpack = require('webpack');

module.exports = {
  // production: {
  //   plugins: [
  //     // ... Add plugins
  //   ]
  // },
  //
  development: {
    plugins: [
      new webpack.HotModuleReplacementPlugin()
    ]
  },
  shared: {
    plugins: [
      new webpack.ProvidePlugin({
        _: 'lodash',
      }),
    ]
  }
}
