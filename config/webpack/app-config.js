const webpack = require('webpack');

module.exports = {
  // production: {
  //   plugins: [
  //     // ... Add plugins
  //   ]
  // },
  //
  // development: {
  //   output: {
  //     // ... Custom output path
  //   }
  // },
  shared: {
    plugins: [
      new webpack.ProvidePlugin({
        _: 'lodash',
      }),
    ]
  }
}
