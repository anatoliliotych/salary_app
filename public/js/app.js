$(document).ready(function  () {
  $("#users").chosen({
    allow_single_deselect: true
  });
  $("#periods").chosen({
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
      $('#complain_button').prop('disabled', true)
      $('#complain_button').val('Отправляется...')
      $.ajax({
        type: "POST",
        url: '/complain',
        data: {pass:pass,body:body}
      }).done(function(){
        add_complain_message('Письмо отправлено', 'success')
        $('#complain_button').prop('disabled', false)
        $('#complain_button').val('Отправить')
        $('#body').val('');
        $('#password').val('');
      }).fail(function () {
        add_complain_message('Проверьте пароль и попробуйте снова!');
        $('#complain_button').prop('disabled', false)
        $('#complain_button').val('Отправить')
      })
    }
    else {
      add_complain_message('Введите сообщение');
    }
  });
})

function add_complain_message(msg,color) {
  color = color || 'danger'
  $('#messages').append("<span class='label label-" + color + " margin-l15' id='message'>" + msg + "</span>")
  setTimeout(function(){
    $("#message").remove();
  }, 3000);
}
