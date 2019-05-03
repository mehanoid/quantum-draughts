var md = require('markdown-it')()
var mila = require('markdown-it-link-attributes')

md.use(mila, {
  pattern: /^https?:/,
  attrs: {
    target: '_blank',
    rel: 'noopener'
  }
})

module.exports = {
  test: /\.pug$/,
  loader: 'pug-plain-loader',
  options: {
    filters: {
      'markdown': function (str, options) {
        return md.render(str);
      }
    },
  }
}
