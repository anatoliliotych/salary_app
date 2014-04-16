$(document).ready(function  () {
  $("#users").chosen(function(){
    allow_single_deselect: true
  });
  $("#periods").chosen(function(){
    allow_single_deselect: true
  });

  $('#complain_form').hide();
  $('#complain').click(function() {
    $('#complain_form').toggle();
  });

  $('#complain_button').click(function(){
    body = $('#body').val()
    pass = $('#password').val()

    if (body.length != 0) {
      disable_button('#complain_button')
      $.ajax({
        type: "POST",
        url: '/complain',
        data: {pass:pass,body:body}
      }).done(function(){
        add_complain_message('Письмо отправлено', 'success')
        $('#body').val('');
        $('#password').val('');
      }).fail(function() {
        add_complain_message('Проверьте пароль и попробуйте снова!');
      }).always(function(){
        enable_button('#complain_button', 'Отправить')
      })
    }
    else {
      add_complain_message('Введите сообщение');
    }
  });

  $('#set-period').click(function(){
    period = $('#periods').val();
    disable_button('#set-period')
    $.ajax({
      type: "POST",
      url: '/period',
      data: {period:period}
    }).done(function(){
      location.reload(true);
    }).always(function(){
      enable_button('#set-period', 'Установить')
    })
  });

  $('#set-user').click(function(){
    name = $('#users').val();
    disable_button('#set-user')
    $.ajax({
      type: "POST",
      url: '/user',
      data: {name:name}
    }).done(function(){
      $('#main').load('/ #user_info')
    }).always(function(){
      enable_button('#set-user', 'Установить')
    })
  });
})

function add_complain_message(msg, color) {
  color = color || 'danger'
  $('#messages').append("<span class='label label-" + color + " margin-l15' id='message'>" + msg + "</span>")
  setTimeout(function(){
    $("#message").remove();
  }, 3000);
}

function enable_button(id, value) {
  $(id).prop('disabled', false)
  $(id).val(value)
}

function disable_button(id, value) {
  value = value || 'Отправляется...'
  $(id).prop('disabled', true)
  $(id).val(value)
}
