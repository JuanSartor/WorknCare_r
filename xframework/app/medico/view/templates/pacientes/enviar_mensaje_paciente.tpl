<style>
    .enviar_mensaje .data-paciente{
        margin-bottom:10px
    }
    .enviar_mensaje .data-paciente img{
        width: 50px;
        display: inline;
    }

    .enviar_mensaje .data-paciente p{
        display: inline;
        font-size: 20px;
        margin-left:20px;
    }
    .enviar_mensaje .more-data{
        margin-bottom:10px;
    }
    .enviar_mensaje textarea {
        height: 150px;
    }
</style>

<div class="modal fade male enviar_mensaje" id="enviar_mensaje_paciente">
    <div class="modal-dialog">
        <div class="modal-content">

            <div class="modal-body">
                <span class="close-btn" data-dismiss="modal" aria-label="Close"><i class="fui-cross"></i></span>	
                <form action="{$url}medico-paciente-mensaje.do" method="post" id="form_enviar_mensaje" >
                    <div class="form-content">
                        <div class="data-paciente">
                            <input type="hidden" name="paciente_idpaciente" id="idpaciente_mensaje" value="">
                            <img class="img-circle" id="imagen_paciente_mensaje" src="" >
                            <p id="nombre_paciente_mensaje"></p>
                        </div>
                        <div class="more-data">
                            <textarea name="cuerpo" class="form-control flat" id="text_mensaje" placeholder='{"Mensaje"|x_translate}' maxlength="100"></textarea>
                        </div>
                        <div id="div_archivos_mensaje">
                        </div>


                        <div class="row">
                            <div class="col-xs-12 text-center">
                                <a href="javascript:;" class="btn-primary btn-xs btn-default" id="send_mensaje_a_paciente">{"Enviar mensaje"|x_translate}</a>

                            </div>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
{literal}
    <script>
        $(function () {

            //enviar mensaje
            $("#send_mensaje_a_paciente").click(function () {

                var idpaciente = $("#idpaciente_mensaje").val();
                //carga de imagenes en proces
                if ($("#dropzone_mensaje .dz-complete").length != $("#dropzone_mensaje .dz-preview").length) {
                    x_alert(x_translate("Aguarde mientras se cargan los archivos adjuntos"));
                    return false;
                }
                $("#text_mensaje").parent().css("border", "none");
                if (parseInt(idpaciente) > 0) {
                    if ($("#text_mensaje").val() == "") {

                        x_alert(x_translate("Ingrese el texto del mensaje"));
                        $("#text_mensaje").parent().css("border", "1px solid red");
                        return false;
                    } else if ((parseInt($("#total_filesize").val()) / 1024 / 1024) > 20) {
                        x_alert(x_translate("Los archivos adjuntos superan el limite de 20MB"));
                        return false;
                    } else {
                        $("body").spin("large");
                        x_doAjaxCall(
                                'POST',
                                $("#form_enviar_mensaje").attr("action"),
                                $("#form_enviar_mensaje").serialize(),
                                function (data) {
                                    $("body").spin(false);
                                    x_alert(data.msg);
                                    if (data.result) {
                                        $("#enviar_mensaje_paciente").modal("hide");
                                    }
                                }
                        );
                    }
                }

            });

            //cuando se cierra el modal de mensaje limpiamos el texto
            $("#enviar_mensaje_paciente").on('hidden.bs.modal', function () {
                $("#text_mensaje").val("");
                $("#idpaciente_mensaje").val("");
                $("#nombre_paciente_mensaje").val("");
                $("#imagen_paciente_mensaje").attr("src", "");
                $("#div_archivos_mensaje").empty();

                //elimiminar imagenes dropzone
                //Dropzone.forElement('#dropzone_mensaje').removeAllFiles(true);
            });
            $("#enviar_mensaje_paciente").on('show.bs.modal', function () {
                x_loadModule('pacientes', 'enviar_mensaje_paciente_add_archivos', '', 'div_archivos_mensaje');
            });

        });
    </script>
{/literal}