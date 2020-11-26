$(function () {
    $('#ask-button').click(function () {
        $('#ask-form').slideToggle(300);
        return false;
    });
});

const webpack = require('webpack')
environment.plugins.prepend('Provide',
  new webpack.ProvidePlugin({
    $: 'jquery/src/jquery',
    jQuery: 'jquery/src/jquery'
  })
)
