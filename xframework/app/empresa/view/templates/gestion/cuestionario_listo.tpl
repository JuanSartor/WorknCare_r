<link href="{$url}xframework/app/themes/dp02/css/pass_esante_registro.css?v={$smarty.now|date_format:"%j"}" rel="stylesheet">

<style>
    .dim-btns{
        width: 280px;
        margin-top: 15px;
    }
    .btn-sig-etapa{
        background: white;
        color: #3DB4C0;
        border: solid;
    }
    .btn-generarQR{
        background: #007d8b;
        color: white;
    }
    .btn-generarQR:hover {
        background: #007d8b !important;
        opacity: 0.9;
        color: white;
    }
    .btn-imprimirFlayer{
        background: #F5C370;
        color: white;
    }
    .btn-imprimirFlayer:hover {
        background: #F5C370 !important;
        opacity: 0.9;
        color: white;
    }
    .btn-imprimirFlayer:focus {
        background: #F5C370 !important;
        opacity: 0.9;
        color: white;
    }
    .btn-imprimirFlayer:active {
        background: #F5C370 !important;
        opacity: 0.9;
        color: white;
    }
    .btn-imprimirFlayer:visited {
        background: #F5C370 !important;
        opacity: 0.9;
        color: white;
    }
    .btn-finalizarCuest{
        background: #ec407a;
        color: white;
    }
    .btn-finalizarCuest:hover {
        background: #ec407a !important;
        opacity: 0.9;
        color: white;
    }

    .font-iconos{
        font-size: 20px;
    }
    .btn-tarjeta:hover {
        background: #469df7 !important;
        opacity: 0.5;
    }
    .btn-factura:hover {
        background: #F5C370 !important;
        opacity: 0.5;
    }
    .label-personalizar{
        margin-bottom: 15px;
        font-size: 15px;
        font-weight: 600;
    }
    .input-personalizar{
        margin-bottom: 15px;
        padding-left: 10px;
    }
    .title-preguntas{
        font-size: 18px;
        margin-top: 55px;
    }
    .container-btn{
        margin-top:70px;
    }
    .input-title{
        width: 433px !important;
    }
    .ubicacion-checkbox{
        position: relative;
        top: -35px;
        left: 150px;
    }
    .label-presupuesto{
        position: relative;
        top: -33px;
        left: 120px;
    }
    .borde-sombra{
        box-shadow: 1px 1px 10px 2px #ccc;
        height: 210px;
        width: 300px;
        border-radius: 8px;
    }
    #Main{
        background: #02b8c1;
    }
</style>
<section class="okm-container" id="personalizadsec">
    <!-- primer columna -->
    <input  id="idcuestionario" hidden value='{$cuestionario_listo.idcuestionario}'>
    <input  id="estadoQR" hidden value='{$cuestionario_listo.genero_qr}'>
    <input  id="estadoPagoPendiente" hidden value='{$pago.pago_pendiente}'>

    <div class="col-xs-12 programas-incluidos">  
        <button onclick="location.href = '{$url}entreprises/'"  class="btn btn-transparen go-back-button btn-volver"><i class="fa fa-chevron-left"></i></button>  
        <div style="text-align: center; margin-left: 37%; margin-bottom: 30px; width: 300px; background: white; border-radius: 8px;">

            <div class="borde-sombra">
                <div class="container-inputs" style="margin-top: 20px;">
                    <div class="col-xs-12" style="margin-top: 30px;">
                        <label  class="mapc-label label-personalizar"> {"Encuesta - Barometro"|x_translate}</label>
                    </div>
                    <div class="col-xs-12">
                        <div style="background-color: #ebebeb;  height: 30px; margin-top: 10px;">
                            <label style="line-height: 1.8"  class="mapc-label label-personalizar"> {if $cuestionario_listo.cantidad > 0 } {$cuestionario_listo.cantidad} {/if}  {"Preguntas"|x_translate}</label>
                        </div>
                    </div>
                    <div class="col-xs-12" style="display: flex;    margin-top: 20px;">
                        <label style="line-height: 2;"  class="mapc-label label-personalizar"> {"Fin:"|x_translate}</label>
                        <input style="width: 120px; height: 30px; margin-left: 115px;"  disabled value="{$cuestionario_listo.fecha_fin}"  class="input-personalizar" />
                    </div>
                    <div class="col-xs-12" style="margin-top: 10px;">
                        <label style="color: #ED799E; font-size: 13px;"  class="mapc-label label-personalizar">{$cuestionario_listo.cantidad}  {"Prestations offertes, tirage aléatoire"|x_translate}</label>
                    </div>

                </div>
            </div>
        </div>

        <div class="okm-row text-center ">
            <!-- esto es porque si genre un QR ya no puede modificar ni eliminar el cuestionario
            xq al eliminar le reintegro el dinero -->
            {if $cuestionario_listo.genero_qr!='1'}
                <div class="col-xs-12" id='divModificar'>
                    <a href="{$url}entreprises/questionnaireslist/personalizar/{$cuestionario_listo.idcuestionario}.html" id="btnModificar" class="btn btn-xs btn-default  btn-guardar dim-btns btn-sig-etapa" >{"Modificar"|x_translate}</a>
                </div>
                <div class="col-xs-12" id="divEliminar">
                    <a href="javascript:;" id="btnEliminar" class="btn btn-xs btn-default  btn-guardar dim-btns btn-sig-etapa" >{"Eliminar"|x_translate}</a>
                </div>
            {/if}

            <div class="col-xs-12">
                <a href="javascript:;" id="btnGenerarQR"   class="btn btn-xs btn-default  btn-guardar dim-btns  btn-generarQR" >{"Generar codigo QR"|x_translate}</a>
                <a href="javascript:;" id="btnGenerarQROculto"  data-toggle="modal" data-target="#modal-compartir-cuestionario" class="btn btn-xs btn-default  btn-guardar dim-btns btn-generarQR hidden" >{"Generar codigo QR"|x_translate}</a>

            </div>
            <div class="col-xs-12" id='divFlayer' {if $cuestionario_listo.genero_qr!='1'} hidden  {/if} >
                <a href="javascript:;" data-toggle="modal" data-target="#modal-flyer-cuestionario"     class="btn btn-xs btn-default  btn-guardar dim-btns btn-agregar-pregunta btn-imprimirFlayer"   >{"Folleto Imprimible"|x_translate} <i style="margin-left: 10px;" class="fa fa-print"></i></a>
            </div> 

            <div class="col-xs-12" id='divFinalizar' {if $cuestionario_listo.genero_qr!='1'} hidden  {/if} >
                <a  id="btnFinalizarCuestionario" class="btn btn-xs btn-default  btn-guardar dim-btns btn-agregar-pregunta btn-finalizarCuest" >{"Finalizar cuestionario"|x_translate}</a>

            </div>

        </div>
        <div class="col-xs-12" style="margin-top: 50px;">
            <label style="color: white; font-size: 14px; text-align: center;"  class="mapc-label label-personalizar">{"Una vez generado el QR no podra modificarlo ni eliminarlo"|x_translate}</label>
        </div>
    </div>
    {include file="gestion/modal_compartir_cuestionario.tpl"}
    {include file="gestion/modal_cuestionario.tpl"}
</section>


{literal}
    <script>
        $(function () {

            $("#btnGenerarQR").click(function () {
                estadoPagoPendiente = $("#estadoPagoPendiente").val();
                idcuestionario = $("#idcuestionario").val();
                //  console.log($("#estadoQR").val());
                if ($("#estadoQR").val() != '1') {

                    jConfirm({
                        title: x_translate("Generar QR"),
                        text: x_translate('Una vez generado el QR no podra editar ni elimar mas su cuestionario'),
                        confirm: function () {

                            $('#btnGenerarQROculto').click();
                            x_doAjaxCall(
                                    'POST',
                                    BASE_PATH + "empresa.php?action=1&modulo=gestion&submodulo=actualizar_columna_generoQR",
                                    'idcuestionario=' + idcuestionario + '&estadoPagoPendiente=' + estadoPagoPendiente,
                                    function (data) {
                                        if (data.result) {
                                        }
                                    }

                            );
                        },
                        cancel: function () {

                        },
                        confirmButton: x_translate("Si"),
                        cancelButton: x_translate("No")
                    });
                } else {
                    $('#btnGenerarQROculto').click();

                }

            });


            $("#btnEliminar").click(function (e) {
                $("body").spin("large");
                idcuestionario = $("#idcuestionario").val();
                x_doAjaxCall(
                        'POST',
                        BASE_PATH + "empresa.php?action=1&modulo=gestion&submodulo=eliminar_cuestionario_y_pago",
                        'idcuestionario=' + idcuestionario,
                        function (data) {
                            if (data.result) {
                                $("body").spin(false);
                                x_alert(x_translate('Cuestionario eliminado'), function () {

                                    window.location.href = BASE_PATH + "entreprises/";

                                });

                            } else {
                                $("body").spin(false);
                                x_alert(x_translate("Ha ocurrido no se pudo eliminar el cuestionario"));

                            }
                        }
                );

            });


            $("#btnFinalizarCuestionario").click(function () {

                idcuestionario = $("#idcuestionario").val();
                //  console.log($("#estadoQR").val());
                jConfirm({
                    title: x_translate("Finalizar Encuesta"),
                    text: x_translate('¿Desea finalizar la etapa de encuesta?'),
                    confirm: function () {

                        x_doAjaxCall(
                                'POST',
                                BASE_PATH + "empresa.php?action=1&modulo=gestion&submodulo=finalizar_cuestionario",
                                'idcuestionario=' + idcuestionario,
                                function (data) {

                                    if (data.result) {
                                        window.location.href = BASE_PATH + "entreprises/";
                                    } else {
                                        x_alert(data.msg);
                                    }
                                }
                        );
                    },
                    cancel: function () {

                    },
                    confirmButton: x_translate("Si"),
                    cancelButton: x_translate("No")
                });

            });


// lo que esta de aca para abajos es para la copia
            var copyToClipboard = function (elementId) {
                console.log("copy" + elementId);
                var input = document.getElementById(elementId);
                var isiOSDevice = navigator.userAgent.match(/ipad|iphone/i);
                if (isiOSDevice) {

                    var editable = input.contentEditable;
                    var readOnly = input.readOnly;
                    input.contentEditable = true;
                    input.readOnly = false;
                    var range = document.createRange();
                    range.selectNodeContents(input);
                    var selection = window.getSelection();
                    selection.removeAllRanges();
                    selection.addRange(range);
                    input.setSelectionRange(0, 999999);
                    input.contentEditable = editable;
                    input.readOnly = readOnly;
                } else {
                    input.select();
                }

                document.execCommand('copy');
            };
            function CopyToClipboard2(containerid) {
                if (window.getSelection) {
                    //limpiar seleccion
                    if (window.getSelection().empty) {  // Chrome
                        window.getSelection().empty();
                    } else if (window.getSelection().removeAllRanges) {  // Firefox
                        window.getSelection().removeAllRanges();
                    }

                    var range = document.createRange();
                    range.selectNode(document.getElementById(containerid));
                    window.getSelection().addRange(range);
                    document.execCommand("Copy");
                } else if (document.selection) {
                    document.selection.empty();
                    var range = document.body.createTextRange();
                    range.moveToElementText(document.getElementById(containerid));
                    range.select().createTextRange();
                    document.execCommand("Copy");
                }
                var icon_content = "<div class='text-center'><br><img src='" + BASE_PATH + "xframework/app/themes/dp02/imgs/icon-ctrl-v.png' style='width: 50%;'></div>";
                x_alert(x_translate("Ahora pega este mensaje en el cuerpo de tu correo electrónico presionando las teclas Ctrl + V en tu teclado.") + icon_content);
            }
            $("#btn-copy-contenido").click(function () {
                CopyToClipboard2("content_to_copy");
            });


        });
    </script>
{/literal}