module.exports = {
  plugins: [
    require('postcss-import'),
    require('postcss-flexbugs-fixes'),
    require('postcss-preset-env')({
      autoprefixer: {
        flexbox: 'no-2009'
      },
      features: {
        'nesting-rules': true,
        'custom-media-queries': true,
      },
      stage: 3
    })
  ]
}
