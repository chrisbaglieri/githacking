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
        $('#categories').append(empty_category_field());
    }
    var categories = $('#categories .category');
    // -2 because we want the last empty field to stick around
    for(var i = categories.length-2; i >= 0; i--){
        var cat = $(categories[i]);
        var input = $(cat.find('input'));
        if (input.val() == '' && !input.hasClass('active')) {
            cat.remove();
        }
    }
}

function append_empty_role_fields() {
    var last_role_fields = $('#roles .role:last input');
    var role_is_dirty = false;
    last_role_fields.each(function(){
                              if($(this).val() !== '') {
                                  role_is_dirty = true;
                              }
                          });
    if (role_is_dirty) {
        $('#roles').append(empty_role_fields());
    }
    var roles = $('#roles .role');
    for(var i = roles.length-2; i >= 0; i--) {
        var role = $(roles[i]);
        role_is_dirty = false;
        var role_is_active = false;
        role.find('input').each(function(){
                                    if($(this).val() !== '') {
                                        role_is_dirty = true;
                                    }
                                    if($(this).hasClass('active')) {
                                        role_is_active = true;
                                    }
                          });
        if(!role_is_dirty && !role_is_active) {
            role.remove();
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
                      $('#roles').bind('keyup', append_empty_role_fields);
                      $('input').live('blur', set_inactive);
                      $('input').live('focus', set_active);
                  });
