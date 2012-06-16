// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require_tree .


function fade_elements($elements, index) {
    if (index < $elements.size()) {
        var $element = $elements.eq(index);
        $element.fadeIn(1000);

        var $header = $('h1.header');
        if (index == 2) {
            $header.html("And you've done a lot..");
            $header.humanTypist({ 'speed': 'secretary' });
        }
        if (index == $elements.size() - 1) {
            $('h1.header').html("What else will you do??");
            $header.humanTypist({ 'speed': 'secretary' });
        }
        setTimeout(function() {
            $element.fadeIn(1000, function() {
                $element.hide();
                fade_elements($elements, index + 1);
            });
        }, 3000);
    }
}