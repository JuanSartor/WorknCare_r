<style>
    .checkbox .icon-unchecked:before {
        content: "\e60b";
    }
    .checkbox .icon-checked:before {
        content: "\e60c";
    }
    .btn-sig-etapa{
        background: white;
        color: #3DB4C0;
        border: 2px solid;
    }
    .icono-pdf{
        margin-right: 20px;
        font-size: 20px;
        color: red;
    }
    .icono-pdf:hover {
        color: #e37a7a;
    }
    .icono-excel{
        margin-right: 20px;
        font-size: 20px;
        color: #38d338;
    }
    .icono-excel:hover {
        color: #9ce19c;
    }
    .icono-eliminar{
        margin-right: 20px;
        font-size: 20px;
        color: black;
    }
    .icono-eliminar:hover {
        color: #9b9595;
    }
    .ajuste-cuestionario{
        border: none;
        border-bottom: solid 1px #c5c5c5;
        border-radius: 0px !important;
    }
    .icono-qr{
        margin-right: 20px;
        font-size: 20px;
        color: #3DB4C0;  
    }
    .icono-qr:hover {
        color: #97b4b7;
    }
    .icono-gift{
        margin-right: 20px;
        font-size: 20px;
        color: #ED799E;
    }
    .icono-gift:hover {
        color: #f10c80;
    }
    .titulo-creado{
        font-size: 16px;
        position: relative;
        left: 170px;
        top: 25px;
        color: #3DB4C0;
    }
    .icono-flyer{
        margin-right: 20px;
        font-size: 20px;
        color: #F5C370;
    }
</style>
<section class="okm-container">
    {include file="gestion/modal_compartir_cuestionario_listo.tpl"}
    <div class="col-xs-12 programas-incluidos">
        <div  style="display: flex;" class="titulos">
            <h2 class="title">
                <button onclick="location.href = '{$url}entreprises/'"  class="btn btn-transparen go-back-button btn-volver"><i class="fa fa-chevron-left"></i></button>
                    {"Cuestionarios Finalizados"|x_translate} 
            </h2>
            {if $usuario_empresa_logueado.tipo_usuario!='5'}
                <h2 class="titulo-creado">
                    {"Creador"|x_translate} 
                </h2>
            {/if}

        </div>
        {foreach from=$listado_cuestionarios item=cuestionario}
            <div class="programa-item ">
                <div style="width: 100%; display: flex;" class="btn btn-white programa-header ajuste-cuestionario" role="button"  >
                    <div style="{if $cuestionario.pago_pendiente !='2' && $cuestionario.cantidad >0 && $cuestionario.cantidad !='' && $cuestionario.fecha_sorteo==''}width: 80.3%;{elseif $cuestionario.cantidad <=0 || $cuestionario.cantidad =='' } width: 80.2%;
                         {elseif $cuestionario.fecha_sorteo!=''} width:84%;{else} width: 75%;{/if} text-align: left;">
                                    {$cuestionario.titulo}    {if $usuario_empresa_logueado.tipo_usuario!='5'}<span style="position: absolute; left: 400px;">  {$cuestionario.nombre}   {$cuestionario.apellido}   </span> {/if}
                                </div>
                                <div>
                                    <a>
                                        <i  data-id="{$cuestionario.idcuestionario}" title="Retirer"  class="fa fa-trash pull-right icono-eliminar btnEliminar"></i>         
                                    </a> 
                                    {if $cuestionario.pago_pendiente !='2'}
                                        <a target="_blank"  href="{$url}empresa.php?action=1&modulo=gestion&submodulo=cuestionario_pass_flayer_finalizado&id={$cuestionario.idcuestionario}">
                                            <i title="Flyer"   class="fa fa-print  pull-right icono-flyer"></i>
                                        </a> 

                                        {**     {if ($cuestionario.fecha_sorteo!=''&& $cuestionario.cantidad > 0) || ($cuestionario.cantidad == 0 || $cuestionario.cantidad =='')} **}
                                        <a  href="{$url}empresa.php?action=1&modulo=gestion&submodulo=informe_cuestionario_xls&id={$cuestionario.idcuestionario}">
                                            <i title="Excel"   class="fa fa-file-excel  pull-right icono-excel"></i>
                                        </a> 

                                        <a  href="{$url}empresa.php?action=1&modulo=gestion&submodulo=generar_pdf_informe_cuestionario&id={$cuestionario.idcuestionario}" target="_blank">
                                            <i title="PDF"  class="fa fa-file-pdf  pull-right icono-pdf"> </i>
                                        </a>
                                        {**   {/if} **}
                                    {else}
                                        <span style="margin-right: 10px; color: #e38080; font-weight: 600;">
                                            {if $cuestionario.fecha_envio_factura!=''}
                                                <a  href="{$url}xframework/files/entities/facturas_cuestionario/{$cuestionario.empresa_idempresa}/fac-quest-{$cuestionario.idpago_recompensa_encuesta}.pdf" target="_blank">  {"Posee el pago pendiente"|x_translate} </a>
                                            {else}
                                                <a class="pago-pendiente" href="{$cuestionario.invoice_pdf}" target="_blank">  {"Posee el pago pendiente"|x_translate} </a>
                                            {/if}
                                        </span>
                                    {/if}

                                    {if $cuestionario.fecha_sorteo ==''}
                                        <i  data-id="{$cuestionario.idcuestionario}"title="QR" class="fa fa-qrcode pull-right icono-qr btnGenerarQR"></i>         
                                        <a href="javascript:;" id="btnGenerarQROculto"  data-toggle="modal" data-target="#modal-compartir-cuestionario" class="btn btn-xs btn-default  btn-guardar dim-btns btn-generarQR hidden" >{"Generar codigo QR"|x_translate}</a>
                                    {/if}
                                    {if $cuestionario.cantidad >0 && $cuestionario.cantidad !='' && $cuestionario.pago_pendiente !='2' }
                                        <a>
                                            <i title="gift" data-id="{$cuestionario.idcuestionario}" data-fecha="{$cuestionario.fecha_fin}" data-fechasorteo="{$cuestionario.fecha_sorteo}"  class="fa fa-gift  pull-right icono-gift btnSortear" {if $cuestionario.fecha_sorteo !=''}style='color: #dfd2d6;' {/if}> </i>
                                        </a>
                                    {/if}


                                </div>
                            </div>
                        </div>
                        {/foreach}
                        </div>


                        <div class="clearfix">&nbsp;</div>
                        <div class="modal modal-plan-contratado" tabindex="-1" role="dialog" id="modal-ganadores" data-keyboard="false" data-backdrop="static">
                            <div class="modal-dialog"  role="document" >
                                <div class="modal-content" style="width: 550px;" >
                                    <button id="btnclosemodal" type="button" class="dp-dismiss custom close" data-dismiss="modal" aria-label="Close"></button>
                                    <div class="modal-body" id="modal-plan-contratado-body">
                                        <div class="pass-sante-registro-planes">
                                            <div class="creacion-cuenta">
                                                <div class="header-container text-center" style="margin-top: 0px;">
                                                    <div class="logo-container">
                                                        <img src="{$IMGS}logo_pass_bienetre.png"/>
                                                    </div>
                                                </div>  
                                                <div class="planes-wrapper"> 

                                                    <div class="okm-row" >
                                                        <div class="col-xs-12" style="text-align: center; font-weight: 600; color: #3DB9C6;">
                                                            <span>  {"Ganadores"|x_translate} </span>
                                                        </div>
                                                        <br><hr><br>
                                                        <table id="tablaGanadores"style="width: 100%;">
                                                            <tr>
                                                                <th style="width: 33%; text-align: center; font-size: 15px;"> {"Nombre"|x_translate}</th>
                                                                <th style="width: 33%; text-align: center; font-size: 15px;">{"Apellido"|x_translate}</th>
                                                                <th style="width: 33%; text-align: center; font-size: 15px;"> {"Email"|x_translate}</th>
                                                            </tr>

                                                        </table>


                                                    </div>

                                                    </span>
                                                </div>

                                            </div>         
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>  
                    </section>

                    {literal}
                        <script>
                            $(function () {

                                $("#btnclosemodal").click(function () {
                                    window.location.href = BASE_PATH + "entreprises/questionnairelistacheve.html";
                                });
                                $(".btnEliminar").click(function () {

                                    idcuestionario = $(this).data("id");
                                    jConfirm({
                                        title: x_translate("Eliminar cuestionario"),
                                        text: x_translate('Una vez eliminado no podrá ser visualizado!'),
                                        confirm: function () {


                                            x_doAjaxCall(
                                                    'POST',
                                                    BASE_PATH + "empresa.php?action=1&modulo=gestion&submodulo=eliminar_cuestionario_finalizado",
                                                    'idcuestionario=' + idcuestionario,
                                                    function (data) {
                                                        if (data.result) {
                                                            window.location.href = BASE_PATH + "entreprises/questionnairelistacheve.html";
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
                                $(".btnGenerarQR").click(function () {
                                    idcuestionarioQR = $(this).data("id");
                                    x_doAjaxCall(
                                            'POST',
                                            BASE_PATH + "empresa.php?action=1&modulo=gestion&submodulo=obtener_hash_cuestionario",
                                            'idcuestionario=' + idcuestionarioQR,
                                            function (data) {
                                                //  console.log(data);
                                                if (data.result) {
                                                    x_loadModule('gestion', 'lista_cuestionarios_finalizados', 'id=' + data.hash, 'Main').then(function () {
                                                        $('#btnGenerarQROculto').click();
                                                    });
                                                }
                                            }

                                    );
                                });
                                $(".btnSortear").click(function () {
                                    idcuestionario = $(this).data("id");
                                    fechaSorteo = $(this).data("fechasorteo");
                                    if (fechaSorteo != '' && fechaSorteo != '0000-00-00') {
                                        x_doAjaxCall(
                                                'POST',
                                                BASE_PATH + "empresa.php?action=1&modulo=gestion&submodulo=obtener_ganadores_sorteo",
                                                'idcuestionario=' + idcuestionario,
                                                function (data) {
                                                    if (data.result) {
                                                        // console.log(data.ganadores);
                                                        if (data.ganadores) {
                                                            for (let i = 0; i < data.ganadores.length; i++) {
                                                                $("#tablaGanadores").append("  <tr><td style='width:33 % ; text-align:center; font-size:12px;'>" + data.ganadores[i].nombre + "</td><td style='width:33 % ; text-align:center; font-size:12px;'>" + data.ganadores[i].apellido + "</td><td style='width:33 % ; text-align:center; font-size:12px;'>" + data.ganadores[i].email + "</td> </tr>");
                                                                //console.log(i);
                                                                //console.log(data.ganadores[i].nombre);
                                                            }
                                                            $("#modal-ganadores").show();
                                                        } else {
                                                            x_alert(x_translate("No se puede realizar el sorteo, no posee participantes registrados"));
                                                        }


                                                    }
                                                }

                                        );

                                    } else {

                                        fechaFin = $(this).data("fecha");
                                        let fecha = new Date(),
                                                formateada = fecha.toLocaleDateString('es-ES', {
                                                    year: 'numeric',
                                                    month: 'numeric',
                                                    day: 'numeric'
                                                });
                                        arregloFecha = fechaFin.split('-');
                                        const diaActual = fecha.getDate();
                                        const mesActual = fecha.getMonth() + 1;
                                        const anioActual = fecha.getFullYear();
                                        //  console.log(arregloFecha[2]); //dia


                                        banderaFechaActualMenor = 0;
                                        if (anioActual < arregloFecha[0]) {
                                            banderaFechaActualMenor = 1;
                                        } else if (anioActual == arregloFecha[0] && mesActual < arregloFecha[1]) {
                                            banderaFechaActualMenor = 1;
                                        } else if (anioActual == arregloFecha[0] && mesActual == arregloFecha[1] && diaActual < arregloFecha[2]) {
                                            banderaFechaActualMenor = 1;
                                        } else {
                                            banderaFechaActualMenor = 0;
                                        }

                                        if (banderaFechaActualMenor == 1) {
                                            // aca aviso que esta finalizando la oportunidad de contestar el cuestionario
                                            // antes de la fecha indicada en el cuestionario
                                            jConfirm({
                                                title: x_translate("Sortear recompensa"),
                                                text: x_translate('Su fecha de finalizacion es posterior, al realizar el sorteo ya no se podra seguir encuestando'),
                                                confirm: function () {
                                                    $("body").spin("large");

                                                    x_doAjaxCall(
                                                            'POST',
                                                            BASE_PATH + "empresa.php?action=1&modulo=gestion&submodulo=realizar_sorteo_recompensas",
                                                            'idcuestionario=' + idcuestionario,
                                                            function (data) {
                                                                if (data.result) {
                                                                    if (data.ganadores) {
                                                                        for (let i = 0; i < data.ganadores.length; i++) {
                                                                            $("#tablaGanadores").append("  <tr><td style='width:33 % ; text-align:center; font-size:12px;'>" + data.ganadores[i].nombre + "</td><td style='width:33 % ; text-align:center; font-size:12px;'>" + data.ganadores[i].apellido + "</td><td style='width:33 % ; text-align:center; font-size:12px;'>" + data.ganadores[i].email + "</td> </tr>");
                                                                            //console.log(i);
                                                                            //console.log(data.ganadores[i].nombre);
                                                                        }
                                                                        $("body").spin(false);
                                                                        $("#modal-ganadores").show();
                                                                    } else {
                                                                        $("body").spin(false);
                                                                        x_alert(x_translate("No se puede realizar el sorteo, no posee suficientes participantes registrados"));
                                                                    }


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
                                            jConfirm({
                                                title: x_translate("Sortear recompensa"),
                                                text: x_translate('Relizar sorteo de recompensa.'),
                                                confirm: function () {
                                                    $("body").spin("large");

                                                    x_doAjaxCall(
                                                            'POST',
                                                            BASE_PATH + "empresa.php?action=1&modulo=gestion&submodulo=realizar_sorteo_recompensas",
                                                            'idcuestionario=' + idcuestionario,
                                                            function (data) {
                                                                if (data.result) {
                                                                    if (data.ganadores) {
                                                                        for (let i = 0; i < data.ganadores.length; i++) {
                                                                            $("#tablaGanadores").append("  <tr><td style='width:33 % ; text-align:center; font-size:14px;'>" + data.ganadores[i].nombre + "</td><td style='width:33 % ; text-align:center; font-size:14px;'>" + data.ganadores[i].apellido + "</td><td style='width:33 % ; text-align:center; font-size:14px;'>" + data.ganadores[i].email + "</td> </tr>");
                                                                            //console.log(i);
                                                                            //console.log(data.ganadores[i].nombre);
                                                                        }
                                                                        $("body").spin(false);
                                                                        $("#modal-ganadores").show();
                                                                    } else {
                                                                        $("body").spin(false);
                                                                        x_alert(x_translate("No se puede realizar el sorteo, no posee suficientes participantes registrados"));
                                                                    }
                                                                }


                                                            }

                                                    );
                                                },
                                                cancel: function () {

                                                },
                                                confirmButton: x_translate("Si"),
                                                cancelButton: x_translate("No")
                                            });
                                        }

                                    }

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