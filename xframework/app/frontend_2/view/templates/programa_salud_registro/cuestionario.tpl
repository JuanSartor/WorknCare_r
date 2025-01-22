<style>
    .textarea-dim{
        width: 606px !important;
        height: 152px !important;
        text-align: left !important;
    }
    body{
        margin-top:20px !important;
    }
    .check-color{
        color: #ED799E;
        margin-right: 15px;
    }
    .card-logo-socio{
        position: relative;
        left: 310px;
        bottom: 30px;
    }
    @media (max-width: 600px){
        .card-pass{
            position: relative;
            right: 90px;
        }
        .card-logo-socio{
            left: 90px;
        }

    }
    .circulo {
        width: 30px;
        height: 30px;
        -moz-border-radius: 50%;
        -webkit-border-radius: 50%;
        border-radius: 50%;
        background: #5cb85c;
        position: absolute;
    }

    .interno:hover {
        border: solid 3px #f5ff61;
    }
    .rectangulo {
        width: 45px;
        height: 16px; 
        position: relative;
        top: 7px;
        margin-left: 26px;
    }
    .label-rta{
        font-size: 12px;
        width: 60px;
        line-height: 1.5;
        font-weight: 600;
        color: #c6cbc6;
    }
    .btn-cuestionario:hover {
        background: #76a8e5 !important;
    }
    .seleccionado{
        border: solid 15px #f5ff61;
    }
    .todoMalSelect{
        color: black !important;
        top: -15px;
        position: relative;
        right: 8px;
    }
    .todoBienSelect{
        color: black !important;
        top: -15px;
        position: relative;
        right: 8px;
    }
    .input-pregunta{
        font-weight: 600;
        width: 750px;
        background-color: #ffffff;
        margin: auto;
        text-align: center;
        border-radius: 4px;
        height: 60px;
        box-shadow: 0 2px 2px 0 rgb(0 0 0 / 10%), 0 2px 10px 0 rgb(0 0 0 / 9%);
    }
    @media (max-width: 600px){
        .input-pregunta{
            font-size: 15px !important;
            width: 320px;
            height: 97px;
        }
    }
    .ceroDeAcuerdoc{
        background: #dddddd; 
        text-align: center;
        left: 390px;
    }
    .rectangulo-ceroDeAcuerdo{
        background: #dddddd; 
        left: 290px;
    }
    .nadaAcuerdoc{
        background: #a9c5a9; 
        margin-left: 69px; 
        left: 390px;
    }
    .rectangulo-nadaAcuerdo{
        background: #a9c5a9; 
        left: 290px;
    }
    .deAcuerdoc{
        background: #88bf88;
        margin-left: 140px;
        left: 390px;
    }
    .rectangulo-deAcuerdo{
        background: #88bf88;
        left: 290px;
    }
    .superDeAcuerdoc{
        background: #82bd82; 
        margin-left: 211px; 
        text-align: center; 
        left: 390px;
    }
    @media (max-width: 600px){
        .ceroDeAcuerdoc{
            left: 60px;
        }
        .rectangulo-ceroDeAcuerdo{
            left: 40px;
        }
        .nadaAcuerdoc{
            left: 60px;
        }
        .rectangulo-nadaAcuerdo{ 
            left: 40px;
        }
        .deAcuerdoc{
            left: 60px;
        }
        .rectangulo-deAcuerdo{
            left: 40px;
        }
        .superDeAcuerdoc{
            left: 60px;
        }
        .textarea-dim{
            width: 300px !important;
            font-size: 12px !important;
        }
    }
    .input-abierta{ 
        width: 750px;
        text-align: center;
        border-radius: 8px; 
    }
    .primer-label{
        margin-right: 16px;
    }
    .div-txtarea-rta{
        margin-top: 20px;
    }
    .div-input-preguntas{
        margin-bottom: 20px; 
        text-align: center;
    }
    .div-botonoes{
        text-align: center; 
        margin-top: 40px;
    }
    @media (max-width: 600px){
        .primer-label{
            position: relative;
            right: 5px;
        }
        .segundo-label{
            position: relative;
            right: 10px;
        }
        .tercer-label{
            position: relative;
            right: 5px;
        }
        .input-abierta{
            width: 325px;
            font-size: 16px;
        }
        .pass-sante-registro-planes.bienvenida-preview {
            margin-top: 0px;
        }
        body{
            margin-top:0px !important;
        }
        .c-txtarea{
            width: 300px;
            font-size: 18px;
        }
        .div-txtarea-rta{
            margin-top: 0px;
        }
        .div-input-preguntas{
            margin-bottom: 10px; 
            text-align: center;
        }
        .div-botonoes{
            text-align: center; 
            margin-top: 5px;
        }
        .btn-escritorio{
            display: none;
        }
    }


</style>
<div>
    <div class="header-container header-container-nuevo" style="background-image: url({$IMGS}BannersRegalo/{$url_baner}.jpg);">
    </div>    
    <a href="{$url}portailsalaries" class="btn-volver-home-sante btn-escritorio" ><i class="fa fa-chevron-left"></i>{"Site WorknCare"|x_translate}</a>
    <input   hidden  id="cantPrestaciones" value="{$cuestionario.cantidad}">
    <input   hidden  id="anonimo" value="{$cuestionario.anonimo}">
    <input   hidden  id="idcuestionario" value="{$cuestionario.idcuestionario}">
    <input   hidden  id="idempresa" value="{$cuestionario.empresa_idempresa}">
    <div class="description-content">
        <div style="text-align: center;">
            <h5 style="color: #ababab; margin-top: 0px; margin-bottom: 10px;">{"Cuestionario"|x_translate}</h5>
        </div>
        <p id="parrafoBienvenida" style="color:#df2929;" class="text-center">{"Tómese unos minutos para responder"|x_translate} </p>
        <div id="fraseBienvenida" style="text-align: center;">
            <h5 style="color: #76a8e5; margin-top: 0px;">{"Su opinión cuenta !"|x_translate}</h5>
        </div>

        <div id="agradecimientoConfirmacion" style="text-align: center;">
            <h5 style="color: #76a8e5; margin-top: 30px;">{"Gracias por participar !"|x_translate}</h5>
        </div>
        {if $cuestionario.cantidad == '0'}
            <p id="parrafoConfirmacionSinPrestacion" style="color:#df2929;" class="text-center">{"Puede abrir una cuenta gratuita en WorknCare, nuestra plataforma de socios en prevención y bienestar con ventajas clave."|x_translate} </p>
        {else}
            <p id="parrafoConfirmacionConPrestacion" style="color:#df2929;" class="text-center">{"Puede abrir una cuenta gratuita en WorknCare, nuestra plataforma de socios en prevención y bienestar con ventajas clave(Con prestacion)."|x_translate} </p>
        {/if}
        <div style="text-align: center;">

            {assign var=running_total value=0}
            <div class="div-input-preguntas" id="divInputPreguntas">




                <input   hidden  id="cantidadPreguntas" value="{$lista_preguntas|count}">
                <input  hidden type="text" class="pul-np-dis" data-mensaje="{$cuestionario.mensaje}" data-cerrada="{$primerElemento.cerrada}" {if $primerElemento.cerrada == '1'} data-id="{$primerElemento.idpregunta}" {else} data-id="{$primerElemento.idpregunta_abierta_cuestionario}" {/if} name="primer_elemento"  id="primer_elemento"/>
                {if $cuestionario.mensaje!=''}
                    <textarea id="textAreaMensaje" disabled class="activo input-pregunta textarea-dim"> {$cuestionario.mensaje}</textarea>
                {/if}
                {foreach from=$lista_preguntas item=pregunta} 
                    <p {if $cuestionario.mensaje!=''} hidden  {/if} data-cerrada="{$pregunta.cerrada}"   {if $pregunta.cerrada == '1'}  data-id="{$pregunta.idpregunta}" {else} data-id="{$pregunta.idpregunta_abierta_cuestionario}" {/if} {if $running_total!='0' } hidden class="input-pregunta" {else} class="activo input-pregunta" {/if} readonly id="{$running_total}" value="{$pregunta.pregunta}">{$pregunta.pregunta} </p>
                    {assign var=running_total value=$running_total+1}
                {/foreach}
            </div>
            <div style="display: inline-block;">
                <div style="margin-bottom: 15px;">
                    <input style="width: 320px; text-align: center; border-radius: 8px;" hidden type="text" class="pul-np-dis" name="email" tabindex='7' id="email_input" placeholder='{"su-nombre@dominio.com"|x_translate}'/>
                </div>
                <div style="margin-bottom: 15px;">
                    <input style="width: 320px; text-align: center; border-radius: 8px;" hidden type="text" class="pul-np-dis" name="nombre" tabindex='7' id="nombre_input" placeholder='{"nombre"|x_translate}'/>
                </div>
                <div>
                    <input style="width: 320px; text-align: center; border-radius: 8px;" hidden type="text" class="pul-np-dis" name="apellido" tabindex='7' id="apellido_input" placeholder='{"apellido"|x_translate}'/>
                </div>
            </div>
            <div id="msjeAvisoAnonimo" hidden="" class="col-xs-12">
                <label style="color: #ED799E; font-size: 13px;"  class="mapc-label label-personalizar">{"Ingrese su email para comunicar el resultado de la prestacion, el cuestionario es anonimo."|x_translate}</label>
            </div>
            <div style="display: flex;" id='barraRtas'>
                <div id="ceroDeAcuerdo"  class="circulo ceroDeAcuerdoc"><i id="todoMal" style="color: white;" class="fa fa-thumbs-down"></i>
                    <div class="interno"></div>
                </div>
                <div  class="rectangulo rectangulo-ceroDeAcuerdo"></div>
                <div id="nadaAcuerdo"  class="circulo nadaAcuerdoc">
                    <div class="interno"></div>
                </div>
                <div  class="rectangulo rectangulo-nadaAcuerdo"></div>
                <div id="deAcuerdo"  class="circulo deAcuerdoc">
                    <div class="interno"></div>
                </div>
                <div  class="rectangulo rectangulo-deAcuerdo"></div>
                <div id="superDeAcuerdo"  class="circulo superDeAcuerdoc"><i id="todoBien" style="color: white;" class="fa fa-thumbs-up"></i>
                    <div class="interno"></div>
                </div>
            </div>
            <div style="margin-top: 20px;" id='txtRtas'>
                <label class="label-rta primer-label">{"Para nada de acuerdo"|x_translate}</label>
                <label class="label-rta segundo-label">{"Casi de acuerdo"|x_translate}</label>
                <label class="label-rta tercer-label">{"De acuerdo"|x_translate}</label>
                <label class="label-rta">{"Absolutamente de acuerdo"|x_translate}</label>
            </div>
            <div class="div-txtarea-rta" id='txtRtasAbiertas'>
               <!-- <input maxlength="80"  type="text" class="pul-np-dis input-abierta" name="inputRta"  id="inputRta" placeholder='{"respuesta"|x_translate}'/>
                -->
                <textarea class="c-txtarea" name="textarea" rows="2" id="inputRta" name="inputRta"  placeholder='{"respuesta"|x_translate}' cols="50"></textarea>
            </div>
        </div>
        <div class="div-botonoes">
            <a style="background: #3682df;" data-bandera="1" id="btnSiguienteComentario"  class="btn-default btn-cuestionario">{"Siguiente"|x_translate}</a>

            <a style="margin-right: 20px; background: #3682df;" id="btnVolverPregunta"  class="btn-default btn-cuestionario">{"Volver"|x_translate}</a>
            <a style="background: #3682df;" id="btnSiguientePregunta"  class="btn-default btn-cuestionario">{"Siguiente"|x_translate}</a>
            <a style="background: #3682df;" id="btnConfirmarCuestionario"   class="btn-default btn-cuestionario">{"Confirmar Respuesta"|x_translate}</a>
            <a style="background: #3682df;" id="btnDescubrir"  href="{$url}portailsalaries" class="btn-default btn-cuestionario">{"Descubrir"|x_translate}</a>
            <a style="background: #3682df;" id="btnCrearCuenta" href="{$url}patient/creer-un-compte.html" class="btn-default btn-cuestionario">{"Crear Cuenta"|x_translate}</a>

        </div>
    </div>

</div>

{literal}
    <script>
        $(function () {

            var arrayRptas = new Array();
            var arrayRptasAbiertas = new Array();
            var arrayTodasLasRtas = new Array();
            var opcionSeleccionada = 0;
            var ordenVisible = 0;
            var cantidadPreguntas = parseInt($("#cantidadPreguntas").val());
            var banderaPregTerminadas = 0;
            var esCerrada;

            // si es 1 es cerrada, si es 0 abierta
            var preguntaCerrada = 1;

            $("#ceroDeAcuerdo").click(function () {
                opcionSeleccionada = 1;
                $("#ceroDeAcuerdo").addClass("seleccionado");
                $("#nadaAcuerdo").removeClass("seleccionado");
                $("#deAcuerdo").removeClass("seleccionado");
                $("#superDeAcuerdo").removeClass("seleccionado");
                $("#todoMal").addClass("todoMalSelect");
                $("#todoBien").removeClass("todoBienSelect");

            });

            $("#nadaAcuerdo").click(function () {
                opcionSeleccionada = 2;
                $("#nadaAcuerdo").addClass("seleccionado");
                $("#ceroDeAcuerdo").removeClass("seleccionado");
                $("#deAcuerdo").removeClass("seleccionado");
                $("#superDeAcuerdo").removeClass("seleccionado");
                $("#todoMal").removeClass("todoMalSelect");
                $("#todoBien").removeClass("todoBienSelect");
            });

            $("#deAcuerdo").click(function () {
                opcionSeleccionada = 3;
                $("#deAcuerdo").addClass("seleccionado");
                $("#nadaAcuerdo").removeClass("seleccionado");
                $("#ceroDeAcuerdo").removeClass("seleccionado");
                $("#superDeAcuerdo").removeClass("seleccionado");
                $("#todoMal").removeClass("todoMalSelect");
                $("#todoBien").removeClass("todoBienSelect");
            });

            $("#superDeAcuerdo").click(function () {
                opcionSeleccionada = 4;
                $("#superDeAcuerdo").addClass("seleccionado");
                $("#nadaAcuerdo").removeClass("seleccionado");
                $("#deAcuerdo").removeClass("seleccionado");
                $("#ceroDeAcuerdo").removeClass("seleccionado");
                $("#todoMal").removeClass("todoMalSelect");
                $("#todoBien").addClass("todoBienSelect");

            });

            $("#btnSiguientePregunta").click(function () {
                $("#todoMal").removeClass("todoMalSelect");
                $("#todoBien").removeClass("todoBienSelect");

                // seteo el array que graba las rtas por si vuelve para atras
                if (preguntaCerrada == '0') {
                    arrayTodasLasRtas[ordenVisible] = $('#inputRta').val();
                } else {
                    arrayTodasLasRtas[ordenVisible] = opcionSeleccionada;
                }



                if (ordenVisible < cantidadPreguntas - 1) {
                    if (opcionSeleccionada != '0' || preguntaCerrada == '0') {
                        $(".activo").each(function (index) {
                            //  console.log($(this).attr('id'));
                            // console.log($(this).data('orden'));
                            //console.log($(this).attr('value'));
                            //console.log(opcionSeleccionada);
                            idPreguntaRespondida = $(this).data('id');
                            orden = $(this).attr('id');
                            ordenVisible = orden;

                            esCerrada = $(this).data('cerrada');
                            //console.log(esCerrada);
                            if (esCerrada == '1') {
                                arrayRptas[orden] = opcionSeleccionada + '-' + idPreguntaRespondida;
                            } else {
                                input = $('#inputRta').val();
                                if (input == '') {
                                    x_alert(x_translate("No se aceptan respuestas vacias"));
                                    return false;
                                } else {
                                    arrayRptasAbiertas[orden] = input + '-_-' + idPreguntaRespondida + '._.';
                                    input = '';
                                    $('#inputRta').val('');
                                }
                            }

                            $(this).hide();
                            $(this).removeClass("activo");
                            ordensig = parseInt(orden) + 1;
                            sigCerrada = $("#" + ordensig).data('cerrada');
                            if (sigCerrada == '1') {
                                $('#txtRtasAbiertas').hide();
                                $("#barraRtas").show();
                                $("#txtRtas").show();
                                preguntaCerrada = '1';
                            } else {
                                $('#txtRtasAbiertas').show();
                                $("#barraRtas").hide();
                                $("#txtRtas").hide();
                                preguntaCerrada = '0';
                            }

                            $("#" + ordensig).addClass("activo");
                            $("#" + ordensig).show();
                            ordenVisible = ordensig;
                            opcionSeleccionada = 0;
                            $("#deAcuerdo").removeClass("seleccionado");
                            $("#nadaAcuerdo").removeClass("seleccionado");
                            $("#ceroDeAcuerdo").removeClass("seleccionado");
                            $("#superDeAcuerdo").removeClass("seleccionado");

                        });
                    } else {
                        x_alert(x_translate("Debe seleccionar una opcion"));
                    }
                } else {

                    // aca entra si no es anonimo o si es anonimo pero sortea alguna prestacion
                    if ($("#cantPrestaciones").val() > '0' || $("#anonimo").val() == '0') {
                        if (opcionSeleccionada != '0' || preguntaCerrada == '0') {
                            $(".activo").each(function () {

                                idPreguntaRespondida = $(this).data('id');
                                orden = $(this).attr('id');
                                esCerrada = $(this).data('cerrada');
                            });

                            // arrayRptas[orden] = opcionSeleccionada + '-' + idPreguntaRespondida;

                            if (esCerrada == '1') {
                                arrayRptas[orden] = opcionSeleccionada + '-' + idPreguntaRespondida;
                            } else {
                                input = $('#inputRta').val();
                                if (input == '') {
                                    x_alert(x_translate("No se aceptan respuestas vacias"));
                                    return false;
                                } else {
                                    arrayRptasAbiertas[orden] = input + '-_-' + idPreguntaRespondida + '._.';
                                    input = '';
                                    $('#inputRta').val('');
                                }
                            }
                            opcionSeleccionada = 0;
                            banderaPregTerminadas = 1;
                            $("#barraRtas").hide();
                            $("#txtRtas").hide();
                            $('#txtRtasAbiertas').hide();
                            $("#" + ordensig).hide();
                            $("#" + ordensig).removeClass("activo");
                            $("#email_input").show();
                            if ($("#anonimo").val() == '1') {
                                $("#msjeAvisoAnonimo").show();
                            }
                            if ($("#anonimo").val() == '0') {
                                $("#nombre_input").show();
                                $("#apellido_input").show();
                            }
                            $("#btnSiguientePregunta").hide();
                            $("#btnConfirmarCuestionario").show();
                        } else {
                            x_alert(x_translate("Debe seleccionar una opcion"));
                        }
                    } else {
                        // aca entra cuando es anonimo sin prestaciones, ingresa en la ultima pregunta
                        // y ejecuto automaticamente el click para q pase a la etapa final
                        if (opcionSeleccionada != '0' || preguntaCerrada == '0') {
                            $(".activo").each(function () {

                                idPreguntaRespondida = $(this).data('id');
                                orden = $(this).attr('id');
                                esCerrada = $(this).data('cerrada');
                            });

                            // arrayRptas[orden] = opcionSeleccionada + '-' + idPreguntaRespondida;

                            if (esCerrada == '1') {
                                arrayRptas[orden] = opcionSeleccionada + '-' + idPreguntaRespondida;
                            } else {
                                input = $('#inputRta').val();
                                if (input == '') {
                                    x_alert(x_translate("No se aceptan respuestas vacias"));
                                    return false;
                                } else {
                                    arrayRptasAbiertas[orden] = input + '-_-' + idPreguntaRespondida + '._.';
                                    input = '';
                                    $('#inputRta').val('');
                                }
                            }

                            opcionSeleccionada = 0;
                            banderaPregTerminadas = 1;
                            $("#btnSiguientePregunta").hide();
                            $('#btnConfirmarCuestionario').trigger('click');
                            $("#deAcuerdo").removeClass("seleccionado");
                            $("#nadaAcuerdo").removeClass("seleccionado");
                            $("#ceroDeAcuerdo").removeClass("seleccionado");
                            $("#superDeAcuerdo").removeClass("seleccionado");
                            $('#txtRtasAbiertas').hide();


                        } else {
                            x_alert(x_translate("Debe seleccionar una opcion"));
                        }
                    }
                }

                if (ordenVisible == 0) {
                    $("#btnVolverPregunta").hide();
                } else {
                    $("#btnVolverPregunta").show();
                }

                // console.log(arrayRptas);
            });


            $("#btnVolverPregunta").click(function () {
                if (banderaPregTerminadas == '0') {
                    $(".activo").each(function (index) {
                        $(this).hide();
                        $(this).removeClass("activo");
                        ordensig = parseInt(ordenVisible) - 1;
                        sigCerrada = $("#" + ordensig).data('cerrada');

                        if (sigCerrada == '1') {
                            $('#txtRtasAbiertas').hide();
                            $("#barraRtas").show();
                            $("#txtRtas").show();

                            opcionSeleccionada = arrayTodasLasRtas[ordensig];
                            if (opcionSeleccionada == '1') {
                                $('#ceroDeAcuerdo').trigger('click');
                            } else if (opcionSeleccionada == '2') {
                                $('#nadaAcuerdo').trigger('click');
                            } else if (opcionSeleccionada == '3') {
                                $('#deAcuerdo').trigger('click');
                            } else {
                                $('#superDeAcuerdo').trigger('click');
                            }

                            preguntaCerrada = 1;
                        } else {

                            $('#txtRtasAbiertas').show();
                            $("#barraRtas").hide();
                            $("#txtRtas").hide();
                            $('#inputRta').val(arrayTodasLasRtas[ordensig]);
                            preguntaCerrada = 0;
                        }
                        $("#" + ordensig).addClass("activo");
                        $("#" + ordensig).show();
                        ordenVisible = ordensig;
                    });

                    if (ordenVisible == 0) {
                        $("#btnVolverPregunta").hide();
                    } else {
                        $("#btnVolverPregunta").show();
                    }
                } else {
                    $("#btnConfirmarCuestionario").hide();
                    $("#btnSiguientePregunta").show();
                    $("#barraRtas").show();
                    $("#txtRtas").show();
                    sigCerrada = $("#" + ordensig).data('cerrada');
                    if (sigCerrada == '1') {
                        $('#txtRtasAbiertas').hide();
                        $("#barraRtas").show();
                        $("#txtRtas").show();
                    } else {
                        $('#txtRtasAbiertas').show();
                        $("#barraRtas").hide();
                        $("#txtRtas").hide();
                    }
                    $("#" + ordensig).show();
                    $("#" + ordensig).addClass("activo");
                    $("#email_input").hide();
                    $("#nombre_input").hide();
                    $("#apellido_input").hide();
                    $("#msjeAvisoAnonimo").hide();
                    banderaPregTerminadas = 0;
                }

            });

            $(document).ready(function () {
                $("#btnConfirmarCuestionario").hide();
                $("#btnDescubrir").hide();
                $("#btnCrearCuenta").hide();
                $("#agradecimientoConfirmacion").hide();
                $("#parrafoConfirmacionConPrestacion").hide();
                $("#parrafoConfirmacionSinPrestacion").hide();

                if (ordenVisible == 0) {
                    $("#btnVolverPregunta").hide();
                } else {
                    $("#btnVolverPregunta").show();
                }


                // valido si la primer pregunta es abierta o cerrada y en base a eso muestro
                // el tipo de respuesta

                mensaje = $("#primer_elemento").data('mensaje');
                primer_ele = $("#primer_elemento").data('cerrada');
                if (mensaje == '') {
                    $('#textAreaMensaje').removeClass("activo");
                    $('#textAreaMensaje').hide();
                    $('#btnSiguienteComentario').hide();

                    if (primer_ele == '1') {
                        preguntaCerrada = 1;
                        $('#txtRtasAbiertas').hide();
                        $("#barraRtas").show();
                        $("#txtRtas").show();
                    } else {
                        preguntaCerrada = 0;
                        $('#txtRtasAbiertas').show();
                        $("#barraRtas").hide();
                        $("#txtRtas").hide();
                    }
                } else {
                    $('#txtRtasAbiertas').hide();
                    $("#barraRtas").hide();
                    $("#txtRtas").hide();
                    $("#btnSiguientePregunta").hide();

                }

            });


            $("#btnConfirmarCuestionario").click(function () {
                banderaAction = 0;
                idcuestionario = $("#idcuestionario").val();
                email = '';
                nombre = '';
                apellido = '';
                idempresa = $("#idempresa").val();

                if ($("#cantPrestaciones").val() > '0' || $("#anonimo").val() == '0') {

                    // valido mail
                    if (validarMail()) {
                        email = $("#email_input").val();
                        if ($("#anonimo").val() == '0') {
                            // valido que nombre y apelldio no sean vacios 
                            // xq el cuestionario no es anonimo
                            if ($("#nombre_input").val() != '' && $("#apellido_input").val() != '') {
                                nombre = $("#nombre_input").val();
                                apellido = $("#apellido_input").val();
                            } else {
                                x_alert(x_translate("Debe completar todos los campos"));
                                banderaAction = 1;
                            }
                        }

                    } else {
                        banderaAction = 1;
                    }
                }
                if (banderaAction == 0) {
                    cantPrestaciones = $("#cantPrestaciones").val();
                    arrayRptasAbiertasLimpio = arrayRptasAbiertas.filter(Boolean);


                    arrayL = arrayRptas.filter((item) => item !== '');

                    x_doAjaxCall(
                            'POST',
                            BASE_PATH + "frontend_2.php?action=1&modulo=programa_salud_registro&submodulo=registrar_respuestas_cuestionario",
                            'cuestionario_idcuestionario=' + idcuestionario + '&email=' + email + '&nombre=' + nombre
                            + '&apellido=' + apellido + '&respuestas=' + arrayL + '&empresa_idempresa=' + idempresa + '&respuestasAbiertas=' + arrayRptasAbiertasLimpio,
                            function (data) {
                                // console.log(data);
                                if (data.result) {
                                    $("#btnDescubrir").show();
                                    $("#btnCrearCuenta").show();
                                    if (cantPrestaciones > 0) {
                                        $("#parrafoConfirmacionConPrestacion").show();
                                    } else {
                                        $("#parrafoConfirmacionSinPrestacion").show();
                                    }
                                    $("#agradecimientoConfirmacion").show();
                                    $("#parrafoBienvenida").hide();
                                    $("#fraseBienvenida").hide();
                                    $("#btnConfirmarCuestionario").hide();
                                    $("#btnVolverPregunta").hide();
                                    $("#divInputPreguntas").hide();
                                    $("#barraRtas").hide();
                                    $("#txtRtas").hide();
                                    $("#email_input").hide();
                                    $("#nombre_input").hide();
                                    $("#apellido_input").hide();
                                    $("#msjeAvisoAnonimo").hide();



                                } else {
                                    x_alert(data.msg);
                                }
                            }
                    );
                }

            });


            // funcion para validar mail
            function validarMail() {
                $("#email_input").val($("#email_input").val().trim());
                if (!validarEmail($("#email_input").val())) {
                    $("#email_input").data("title", x_translate("Ingrese un email válido")).tooltip("show");
                    $('html, body').animate({
                        scrollTop: $("#email_input").offset().top - 200}, 1000);
                    return false;
                } else {
                    return true;
                }
            }


            $("#btnSiguienteComentario").click(function () {
                $('#textAreaMensaje').hide();
                $('#btnSiguienteComentario').hide();
                $('#btnSiguientePregunta').show();

                $('#textAreaMensaje').removeClass("activo");
                $("#0").addClass("activo");
                $('#0').show();

                primer_ele = $("#primer_elemento").data('cerrada');
                if (primer_ele == '1') {
                    preguntaCerrada = 1;
                    $('#txtRtasAbiertas').hide();
                    $("#barraRtas").show();
                    $("#txtRtas").show();
                } else {
                    preguntaCerrada = 0;
                    $('#txtRtasAbiertas').show();
                    $("#barraRtas").hide();
                    $("#txtRtas").hide();
                }

            });

        });
    </script>
{/literal}