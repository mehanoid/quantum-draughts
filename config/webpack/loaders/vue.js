module.exports = {
  test: /.vue$/,
  loader: 'vue-loader',
  options: {
    extractCSS: true,
    loaders: {
      js: 'babel-loader',
      file: 'file-loader',
      postcss: 'vue-style-loader!css-loader!postcss-loader?sourceMap=true'
    }
  }
}
