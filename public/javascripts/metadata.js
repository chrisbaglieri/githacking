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

function empty_field(units, unit) {
    return "<div class='field "+ unit +"'><input name='metadata["+ units +"][]' type='text'/></div>";
}

function empty_mention_field() {
    return "<div class='field mention'><input name='metadata[mentions][]' type='text'/></div>";
}

function append_empty_field(units, unit) {
    var last_value = $('#' + units + ' input:last').val();
    if (last_value != '') {
        $('#' + units).append(empty_field(units, unit));
    }
    var dom_units = $('#'+ units + ' .'+ unit);
    // -2 because we want the last empty field to stick around
    for(var i = dom_units.length-2; i >= 0; i--){
        var dom_unit = $(dom_units[i]);
        var input = $(dom_unit.find('input'));
        if (input.val() == '' && !input.hasClass('active')) {
            dom_unit.remove();
        }
    }
}

function append_empty_category_field() {
    append_empty_field('categories', 'category');
}

function append_empty_mention_field() {
    append_empty_field('mentions', 'mention');
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
                      $('#mentions').bind('keyup', append_empty_mention_field);
                      $('#roles').bind('keyup', append_empty_role_fields);
                      $('input').live('blur', set_inactive);
                      $('input').live('focus', set_active);
                  });
