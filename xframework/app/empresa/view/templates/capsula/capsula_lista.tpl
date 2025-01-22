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
    <input  id="idcapsula" hidden value='{$capsula_lista.idcapsula}'>
    <input  id="estadoQR" hidden value='{$capsula_lista.genero_qr}'>


    <div class="col-xs-12 programas-incluidos">  
        <button onclick="location.href = '{$url}entreprises/'"  class="btn btn-transparen go-back-button btn-volver"><i class="fa fa-chevron-left"></i></button>  
        <div style="text-align: center; margin-left: 37%; margin-bottom: 30px; width: 300px; background: white; border-radius: 8px;">

            <div class="borde-sombra">
                <div class="container-inputs" style="margin-top: 20px;">
                    <div class="col-xs-12" style="margin-top: 30px;">
                        {if $capsula_lista.tipo_capsula == '1'}
                            <label style="    font-size: 24px; color: #02b8c1;"  class="mapc-label label-personalizar"> {"PPT.DOC"|x_translate}</label>
                            <img style="margin-top: 20px; height: 90px;" class="tam-img-file"  src="{$IMGS}icons/Icon-awesome-file-upload.png" />  
                        {else if $capsula_lista.tipo_capsula == '2'}
                            <label style="    font-size: 24px; color: #02b8c1;"  class="mapc-label label-personalizar"> {"LINK"|x_translate}</label>
                            <img style="margin-top: 30px; height: 60px;" class="tam-img-link"  src="{$IMGS}icons/Icon-awesome-link.png" />    
                        {else if $capsula_lista.tipo_capsula == '3'}
                            <label style="font-size: 24px; color: #02b8c1;"  class="mapc-label label-personalizar"> {"VIDEO"|x_translate}</label>
                            <img style="height: 50px; margin-top: 25px; margin-left: 20px;" class="tam-img-video" src="{$IMGS}icons/Icon-awesome-video.png" />   
                        {else}
                            <label style="font-size: 24px; color: #02b8c1;"  class="mapc-label label-personalizar"> {"GRABACION"|x_translate}</label>
                            <img style="margin-top: 25px; height: 60px;" class="tam-img-ondemand-video"  src="{$IMGS}icons/Icon-material-ondemand-video.png" />   
                        {/if}
                    </div>

                </div>
            </div>
        </div>

        <div class="okm-row text-center ">
            <!-- esto es porque si genre un QR ya no puede modificar ni eliminar el cuestionario
            xq al eliminar le reintegro el dinero -->
            {if $capsula_lista.genero_qr!='1'}
                <!--    <div class="col-xs-12" id='divModificar'>
                        <a href="{$url}entreprises/questionnaireslist/personalizar/{$capsula_lista.idcapsula}.html" id="btnModificar" class="btn btn-xs btn-default  btn-guardar dim-btns btn-sig-etapa" >{"Modificar"|x_translate}</a>
                    </div> -->
                <div class="col-xs-12" id="divEliminar">
                    <a href="javascript:;" id="btnEliminar" class="btn btn-xs btn-default  btn-guardar dim-btns btn-sig-etapa" >{"Eliminar"|x_translate}</a>
                </div>
            {/if}

            <div class="col-xs-12">
                <a href="javascript:;" id="btnGenerarQR"   class="btn btn-xs btn-default  btn-guardar dim-btns  btn-generarQR" >{"Generar codigo QR"|x_translate}</a>
                <a href="javascript:;" id="btnGenerarQROculto"  data-toggle="modal" data-target="#modal-compartir-capsula" class="btn btn-xs btn-default  btn-guardar dim-btns btn-generarQR hidden" >{"Generar codigo QR"|x_translate}</a>

            </div>
            <div class="col-xs-12" id='divFlayer' {if $capsula_lista.genero_qr!='1'} hidden  {/if} >
                <a href="javascript:;"  data-toggle="modal" data-target="#modal-flyer-capsula" class="btn btn-xs btn-default  btn-guardar dim-btns btn-agregar-pregunta btn-imprimirFlayer" >{"Folleto Imprimible"|x_translate} <i style="margin-left: 10px;" class="fa fa-print"></i></a>

            </div> 

            <div class="col-xs-12" id='divFinalizar' {if $capsula_lista.genero_qr!='1'} hidden  {/if} >
                <a  id="btnFinalizarCapsula" class="btn btn-xs btn-default  btn-guardar dim-btns btn-agregar-pregunta btn-finalizarCuest" >{"Finalizar capsula"|x_translate}</a>

            </div>

        </div>
        <div class="col-xs-12" style="margin-top: 50px;">
            <label style="color: white; font-size: 14px; text-align: center;"  class="mapc-label label-personalizar">{"Una vez generado el QR no podra modificar ni eliminar la capsula"|x_translate}</label>
        </div>
    </div>
    {include file="capsula/modal_compartir_capsula.tpl"}
    {include file="capsula/modal_flyer.tpl"}
</section>


{literal}
    <script>
        $(function () {

            $("#btnGenerarQR").click(function () {

                idcapsula = $("#idcapsula").val();
                //  console.log($("#estadoQR").val());
                if ($("#estadoQR").val() != '1') {

                    jConfirm({
                        title: x_translate("Generar QR"),
                        text: x_translate('Una vez generado el QR no podra editar ni elimar mas su capsula'),
                        confirm: function () {

                            $('#btnGenerarQROculto').click();
                            x_doAjaxCall(
                                    'POST',
                                    BASE_PATH + "empresa.php?action=1&modulo=capsula&submodulo=actualizar_columna_generoQR",
                                    'idcapsula=' + idcapsula,
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
                    x_doAjaxCall(
                            'POST',
                            BASE_PATH + "empresa.php?action=1&modulo=capsula&submodulo=sumar_visita_capsula_link",
                            'idcapsula=' + idcapsula,
                            function (data) {


                            }

                    );
                    $('#btnGenerarQROculto').click();

                }

            });


            $("#btnEliminar").click(function (e) {
                $("body").spin("large");
                idcapsula = $("#idcapsula").val();
                x_doAjaxCall(
                        'POST',
                        BASE_PATH + "empresa.php?action=1&modulo=capsula&submodulo=eliminar_capsula",
                        'idcapsula=' + idcapsula,
                        function (data) {
                            if (data.result) {
                                $("body").spin(false);
                                x_alert(x_translate('Capsula eliminada'), function () {

                                    window.location.href = BASE_PATH + "entreprises/";

                                });

                            } else {
                                $("body").spin(false);
                                x_alert(x_translate("Ha ocurrido no se pudo eliminar la capsula"));

                            }
                        }
                );

            });


            $("#btnFinalizarCapsula").click(function () {

                idcapsula = $("#idcapsula").val();
                //  console.log($("#estadoQR").val());
                jConfirm({
                    title: x_translate("Finalizar Capsula"),
                    text: x_translate('¿Desea finalizar la etapa de la capsula?'),
                    confirm: function () {

                        x_doAjaxCall(
                                'POST',
                                BASE_PATH + "empresa.php?action=1&modulo=capsula&submodulo=finalizar_capsula",
                                'idcapsula=' + idcapsula,
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