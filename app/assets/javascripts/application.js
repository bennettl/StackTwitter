// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .

(function(){

    jQuery(document).ready(function($){
        startApp();
    });

    jQuery(document).on('page:change', 'page:load', startApp);

    function startApp(){
        initApp();

        setupUsers();

        setupTweets();
    }

}());

// Global helper singleton
var _helper = {
    
    // Show alert message
    showAlert: function(type, message){
        $(".alert").removeClass('alert-success').removeClass('alert-error').addClass('alert-'+type).html(message).show();
        setTimeout(function(){
            $(".alert").fadeOut(500);
        }, 5000);
    }
};

// Validation object
var _validator = {
    
    // Return wheather or not a name is valid
    isValidName: function(name){
        var regex   = /^[a-zA-Z]{2,}$/;
        return regex.test(name);
    },

    // Are the text keys value
    validTextInputs: function(textInputs){

        // Validate visible text keys
        for (var i = 0; i < textInputs.length; i++){
            var textInput = $('[type="text"][name="'+textInputs[i]+'"]:visible');

            // If text input doesn't exist, continue
            if (textInput.length == 0){
                continue;
            // Else if it doesn't have a value, tell the user
            } else if (textInput.val().length == 0){
                _helper.showAlert('error', 'Please fill out all require fields');
                return false;
            }
        }

        return true;
    },

    // Are the number keys valid
    validNumberInputs: function(numberInputs){
        
        // Validate visible number keys
        for (var i = 0; i < numberInputs.length; i++){
            var numberInput = $('[type="number"][name="'+numberInputs[i]+'"]:visible');

            // If text input doesn't exist, continue
            if (numberInput.length == 0){
                continue;
            // Else if it doesn't have a value, tell the user
            } else if (numberInput.val().length == 0){
                _helper.showAlert('error', 'Please fill out all require fields');
                return false;
            } else if (!_helper.isNumber(numberInput.val())){
                _helper.showAlert('error', 'Please enter a valid number');
                return false;
            }
        }

        return true;

    },

    validFileInputs: function(fileInputs){

        // Validate visible number keys
        for (var i = 0; i < fileInputs.length; i++){
            var fileInput = $(fileInputs[i] + ':visible');

            // If text input doesn't exist, continue
            if (fileInput.length == 0){
                continue;
            // Else if it doesn't have a value, tell the user
            } else if (fileInput.val().length == 0){
                _helper.showAlert('error', 'Please fill out all require fields');
                return false;
            }
        }

        return true;
    }

};

// Initialize application wide functionality
function initApp(){
    
    // Fade out alerts when they are visible
    if ($(".alert").css("display") == "block"){
        setTimeout(function(){
            $(".alert").fadeOut(500);
        }, 5000);
    }

    /************************** AJAX SORTABLE HEADER (INDEX PAGES) **************************/
        
    // If .sortable-header exists
    if ($('.sortable-header').length > 0){
        // When the sortable-links are clicked, upate the hidden fields with the appropriate values and subit AJAX request to reload form
        $('.sortable-header').on('click', '.sortable-link', function(){
            var column_name     = $(this).data('column-name'); 
            var direction       = $(this).data('direction') == 'asc' ? 'desc' : 'asc'; // toggled direction

            // Update hidden fields with the column name and direction
            $('input#sort_name[type="hidden"]').val(column_name);
            $('input#sort_direction[type="hidden"]').val(direction);

            // Make sure everything is decending
            $('.sortable-link .caret').removeClass('asc');
            $('.sortable-link .caret').data('direction', 'desc');

            // Update the toggled data-direction attribute
            $(this).data('direction', direction);
            // then add the ascending class to the sortablelink
            if (direction == 'asc'){
                $(this).find('.caret').addClass('asc');
            }

            // Submit an get AJAX request with the forms paramters
            var form = $(this).parents("form");
            $.get(form.attr('action'), form.serialize(), null, "script");

            return false;
        });
    }

    // If .header-dropdown-checkbox exists
    if ($('.header-dropdown-checkbox').length > 0){
        // When the dropdown is hidden, submit an get AJAX request with the forms paramters
        $('.header-dropdown-checkbox').on('hide.bs.dropdown', function(){
            var form = $('.index-form');
            $.get(form.attr('action'), form.serialize(), null, "script");
        });
    }
    
    // AJAX for pagination
    $('.box').on('click', '.pagination a', function(){
        $.get($(this).attr('href'), null, null, "script");
        return false;
    });

    // Auto strech textarea height to fit text
    if ($("textarea").length > 0){
        $("textarea").height( $("textarea")[0].scrollHeight );      
    }

    /************************** DROPDOWN **************************/
    // Dropdown menus with .dropdown.hover class will be open upon hover event
    $('.dropdown.hover').hover(function() {
        $(this).addClass('open');
    }, function() {
        /* Stuff to do when the mouse leaves the element */
        $(this).removeClass('open');
    });

    // Prevents clicking on input from hiding dropdown menu
    $('.dropdown').on('click','input, select', function (e) {
        e.stopPropagation();
    });
    
    /************************** SEARCH CONTAINER **************************/
  
    // Reloads list in real time every time the user types
    $(document).on('keyup', 'input[name="index_search"]', function(event) {
        var type =  $(this).attr('data-type');
        var path = '/' + type +'/';
        var data = {};

        // Depending on which type we're searching for, modify the data accordingly
        switch (type){
            case 'facts':
                data.filter_data = { message: $(this).val() };
                break;
            case 'users':
                data.name = $(this).val();
                break;
            case 'buckets':
                data.filter_data = { title:  $(this).val() };
                break;
            default:
                break;
        }

        $.get(path, data, null, "script");
    });

    $("#header-links-list a.index-link").click(function(e){

        if ($(this).attr('href').indexOf('/') > -1){
            return true;
        }

         e.preventDefault();
         //calculate destination place
         var dest=0;
         if ($(this.hash).offset().top > $(document).height()-$(window).height()){
              dest=$(document).height()-$(window).height();
         }else{
              dest=$(this.hash).offset().top;
         }
         //go to destination
         $('html,body').animate({scrollTop:dest}, 1000,'swing');
     });

    /************************** CHECKBOX / RADIO **************************/

    // When an option label is clicked, click the previous input as well
    $(document).off('click', '.option-label').on('click', '.option-label', function(){
        $(this).prev('input').click();
    });
}


// Set up users related functionality
function setupUsers(){

    // When user creates a new user, perform validation
    $(document).on('submit', 'form#new_user', function(){
        var email       = $('input[name="user[email]"]').val();
        var firstName   = $('input[name="user[first_name]"]').val();
        var lastName    = $('input[name="user[last_name]"]').val();

        if (email.trim().length == 0){
            _helper.showAlert('error', 'Please enter an email');
            return false;
        }

        if (!_validator.isValidName(firstName)){
            _helper.showAlert('error', 'First name is invalid');
            return false;
        }

        if (!_validator.isValidName(lastName)){
            _helper.showAlert('error', 'Last name is invalid');
            return false;
        }

        if ($('input[name="user[password]"]').val().length < 4){
            _helper.showAlert('error', 'Password must be at least 4 characters');
            return false;
        }

        // Make sure password and password confirmation matches
        if ($('input[name="user[password_confirmation]"]:visible').length > 0){
            if ($('input[name="user[password]"]').val() != $('input[name="user[password_confirmation]"]').val()){
                _helper.showAlert('error', 'Passwords do not match');
                return false;
            }
        }

    });

    // When user updates a new user, perform validation
    $(document).on('submit', 'form#edit_user', function(){
        var email       = $('input[name="user[email]"]').val();
        var firstName   = $('input[name="user[first_name]"]').val();
        var lastName    = $('input[name="user[last_name]"]').val();

        if (email.trim().length == 0){
            _helper.showAlert('error', 'Please enter an email');
            return false;
        }

        if (!_validator.isValidName(firstName)){
            _helper.showAlert('error', 'First name is invalid');
            return false;
        }

        if (!_validator.isValidName(lastName)){
            _helper.showAlert('error', 'Last name is invalid');
            return false;
        }

    });
}


function setupTweets(){

    // When the user hits enter
    $(document).on('keyup', 'input[name="twitter-handle"]', function(evt){
        
        if (evt.which == 13){

            // Submit the twitter handle
            submitHandle();
        }

    });

    // When the user clicks on submit
    $(document).on('click', 'input[name="twitter-submit"]', function(){

        // Submit the twitter handle
        submitHandle();

        return false;

    });


    // Grab the handle, and submit a GET request
    function submitHandle(){
        var handle  = $('input[name="twitter-handle"]').val();
        var regex   = /^[a-zA-Z0-9_\.]+$/;

        // Only execute GET request if handle is valid
        if (regex.test(handle)){
    
            var data = { handle: handle };

            $.get('/tweets', data, function(){}, 'script');

        } else{
            _helper.showAlert('error', 'Please provide a valid handle');
        }

    }
}