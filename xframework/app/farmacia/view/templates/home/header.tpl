
{literal}

<script>



    $(function () {

        $("#enviar_codigo_verificacion_login").click(function () {
            var password = $.trim($('#password_form_input').val());

            var valor = Base64.encode(SHA1(password));
            $("#password_form").val(valor);

            x_sendForm($('#frm_login_form'), true, alert_resultado_step1);

        });

        $("#submit_login_form").click(function () {


            $("#frm_login_form_step2 input[name='password']").val($("#password_form").val());
            $("#frm_login_form_step2 input[name='email']").val($("#email_form").val());

            x_sendForm($('#frm_login_form_step2'), true, alert_resultado_step2);

        });

        $(".reenviar_codigo_verificacion_login").click(function () {


            x_sendForm($('#frm_login_form'), true, function (data) {
                x_alert(data.msg);

            });

        });

        function alert_resultado_step1(data) {
            if (data.result) {
                $("#frm_login_form").hide();
                $("#frm_login_form_step2").show();
            } else {

                if (!data.hasOwnProperty('field')) {
                    x_alert(x_translate(data.msg));
                } else {
                    if (data.field == "0") {

                        $("#password_form_input").data("title", x_translate(data.msg)).tooltip("show");


                    }
                    if (data.field == "1") {
                        $("#email_form").data("title", x_translate(data.msg)).tooltip("show");
                    }
                }
            }
        }
        function alert_resultado_step2(data) {
            if (data.result) {


                if (data.redirect !== "" && data.redirect !== null) {
                    window.location.href = BASE_PATH + data.redirect;
                } else {

                    if (data.usuario == "paciente") {
                        window.location.href = BASE_PATH + "panel-paciente/";
                    } else if (data.usuario == "medico") {
                        window.location.href = BASE_PATH + "panel-medico/";
                    }
                }
            } else {
                $("#frm_login_form_step2 input").val("");
                $("#frm_login_form_step2").hide();
                  $("#frm_login_form").show();
                
                x_alert(data.msg);

            }
        }



        $("#frm_reset_pass_drop_down").validate({
            showErrors: function (errorMap, errorList) {

                // Clean up any tooltips for valid elements
                $.each(this.validElements(), function (index, element) {
                    var $element = $(element);

                    $element.data("title", "") // Clear the title - there is no error associated anymore
                            .removeClass("error")
                            .tooltip("destroy");
                });

                // Create new tooltips for invalid elements
                $.each(errorList, function (index, error) {
                    var $element = $(error.element);

                    $element.tooltip("destroy") // Destroy any pre-existing tooltip so we can repopulate with new tooltip content
                            .data("title", error.message)
                            .addClass("error")
                            .tooltip(); // Create a new tooltip based on the error messsage we just set in the title
                });
            },
            submitHandler: function (form) {


                x_sendForm($('#frm_reset_pass_drop_down'), true, alert_resultado_reset);

                return false;


            }
        });

        function alert_resultado_reset(data) {
            if (data.result) {
                x_alert(x_translate("Se ha enviado un email para que recupere su contraseña"));

                $("#email_recuperar_drop_down").val("");
                $(".login").modal("hide");
            } else {
                x_alert(x_translate(data.msg));
            }
        }






        $('#loginbtn,#loginbtn2,#loginbtn3').on('click', function (e) {

            $("#frm_login_form").show();
            $("#frm_login_form_step2").hide();
            $("#codigo_verificacion_login_form").val("");
            $('#login').show();
            $('#passrecovery').hide();
            $('#recoverytext').hide();

        });



        $('.ForgotPassTrigger').on('click', function (e) {
            e.preventDefault();
            $('#login').hide();

            $('#passrecovery').fadeIn();

        });

        $('#sendpass').on('click', function (e) {
            e.preventDefault();
            $('#passrecovery').hide();
            $('#recoverytext').fadeIn();
        });


    });
</script>
{/literal}