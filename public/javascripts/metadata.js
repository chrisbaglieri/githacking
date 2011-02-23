function empty_role_fields() {
    return $('\
<div class="field role"> \
    Name: \
    <input class=​"role-role" name="metadata[needs][roles][][role]" type="text"> \
    <br> \
    Language: \
    <input class=​"role-language" name="metadata[needs][roles][][langauge]" type="text"> \
    <br> \
    Description: \
    <input class=​"role-description" name="metadata[needs][roles][][description]" type="text"> \
</div>');
}

function empty_category_field() {
    return "<div class='field category'><input name='metadata[categories][]' type='text'/></div>";
}

function append_empty_category_field() {
    var last_category_value = $('#categories input:last').val();
    if (last_category_value != '') {
        $('#categories').append(empty_category_field);
    }
    var categories = $('#categories .category');
    for(var i = categories.length-2; i >= 0; i--){
        var cat = $(categories[i]);
        var input = $(cat.find('input'));
        if (input.val() == '' && !input.hasClass('active')) {
            cat.remove();
        }
    }
}

function set_inactive(){
    $(this).removeClass('active');
}

function set_active(){
    $(this).addClass('active');
}

$(document).ready(function(){
                      $('#categories').bind('keyup', append_empty_category_field);
                      $('input').live('blur', set_inactive);
                      $('input').live('focus', set_active);
                  });
