const path = require('path')

module.exports = {
  resolve: {
    alias: {
      '@application': path.resolve(__dirname, '..', '..', 'app/javascript/application'),
    },
  },
}
