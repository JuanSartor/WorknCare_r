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
    .font-iconos{
        font-size: 20px;
    }
    .btn-agregar-pregunta:hover {
        background: white !important;
        color: #77cbd3 !important;
        border: solid;
    }
    .label-personalizar{
        margin-bottom: 15px;
        font-size: 15px;
        font-weight: 600;
    }
    .input-personalizar{
        margin-bottom: 15px;
        padding-left: 10px;
        font-size: 20px;
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
        font-size: 20px;  
    }
    .pregunta-item{
        margin-bottom: 5px;
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
    .rectangulo {
        width: 45px;
        height: 16px; 
        position: relative;
        top: 7px;
        margin-left: 26px;
    }
    .label-rta{
        font-size: 10px;
        line-height: 1.5;
        font-weight: 600;
        color: #c6cbc6;
    }
    .dim-btn-mod-particular{
        width: 200px;
    }
    .cursors:hover {
        cursor: pointer;
    }
    .modo-select{
        border: 2px solid #82B9EE;
    }
    .img-cerrada{
        width: 80px;
        height: 20px;
    }
    .seleccionado{
        box-shadow: 1px 1px 10px 2px #3c3c3c;
    }
    ul{
        padding: 0px;
        margin: 0px;
    }
    #mi_lista li{
        list-style: none;
        cursor:pointer;
    }

</style>
<section class="okm-container" id="personalizadsecR">
    <!-- primer columna -->
    <input  id="idmodelos_riesgos" hidden value='{$modelo.idmodelos_riesgos}'>
    <input  id="idempresaMod" hidden value='{$modelo.empresa_idempresa}'>



    <div class="col-xs-6 programas-incluidos">
        <h2 class="title">
            <button onclick="location.href = 'JavaScript:window.history.back();'"  class="btn btn-transparen go-back-button btn-volver"><i class="fa fa-chevron-left"></i></button>
                {"Modelo"|x_translate}

        </h2>
        <div class="container-inputs" style="margin-top: 50px;">
            <div class="col-xs-12">
                <label  class="mapc-label label-personalizar"> {"Agregar nombre Entidad legal"|x_translate}</label>
                {if $modelo.empresa_idempresa=='0'}
                    {if $TRADUCCION_DEFAULT=="fr"}    <input id="input_titulo" class="input-personalizar input-title" type="text"  value="{$modelo.nombre}" placeholder="{$modelo.nombre_en}"/>
                    {else}
                        <input id="input_titulo" class="input-personalizar input-title" type="text"  value="{$modelo.nombre_en}" placeholder="{$modelo.nombre_en}"/>
                    {/if}
                {else}
                    <input id="input_titulo" class="input-personalizar input-title" type="text"  value="{$modelo.nombre}" placeholder="{$modelo.nombreagregarPregunta}"/>
                {/if}


            </div>

        </div>
        <div class="col-xs-12">

            <textarea disabled="true" maxlength="150" id="mensajeCuestionario" name="mensajeCuestionario" value="{$cuestionario.mensaje}" rows="7" cols="35">{$cuestionario.mensaje}</textarea>
        </div>

    </div>
    <!-- segunda columna -->
    <div class="col-xs-6 preguntas-incluidas">
        <!--  <h2 class="title title-preguntas">
        {"Familias"|x_translate}
    </h2>
        -->


        <label style="margin-top: 135px;"  class="mapc-label label-personalizar"> {"Añadir descripcion"|x_translate}</label>
        <input  maxlength="130" style="width: 70%; font-size: 20px;" type="text" value="{$modelo.descripcion_observacion}" id="descripcionInput">
        <br>
        <br>
        <br>
        <label  class="mapc-label label-personalizar"> {"Agregar riesgo"|x_translate}</label>
        <input  maxlength="130" style="width: 70%; font-size: 20px;" type="text" id="familiaInput">
        <div class="col-xs-6" style="position: relative; top: -58px;  left: 400px; width: 200px;">
            <a style="font-size: 15px; width: 200px;" href="javascript:;" id="agregarFamilia" class="btn btn-xs btn-default  btn-guardar dim-btns btn-agregar-pregunta" ><i class="fa fa-plus-circle pull-left font-iconos"></i>{"Agregar"|x_translate}</a>
        </div>



        <div class="preguntas-iniciales" style="position: relative; margin-top: 70px;" >
            <ul id="mi_lista" style="position: relative; ">
                {foreach from=$listado item=familia}
                    <li  id="miorden_{$familia.idfamilia_riesgo}" >
                        <div class="pregunta-item" style="display: flex;">

                            <input class="spanesids"  hidden    style="width: 70%; cursor:pointer;"  type="text" disabled    id="span-{$familia.idfamilia_riesgo}"   value="    {if $TRADUCCION_DEFAULT=="fr"} {$familia.titulo} {else}{$familia.titulo_en} {/if}">

                            <label style=" margin-right: 7px; width: 70%; background: #ededed; cursor: pointer; padding-left: 10px; line-height: 1.5; position: relative;"  id="labeli-{$familia.idfamilia_riesgo}" >
                                {if $modelo.empresa_idempresa=='0'}
                                    {if $TRADUCCION_DEFAULT=="fr"}  {$familia.titulo}
                                    {else}
                                        {$familia.titulo_en}
                                    {/if}
                                {else}
                                    {$familia.titulo}
                                {/if}
                            </label>


                            <a   class="eliminarRiesgo" style="position: relative; top: 7px;"  data-id="{$familia.idfamilia_riesgo}" > 
                                <i class="fa fa-trash pull-right"></i>
                            </a>
                            <a   class="editarPregunta" style="position: relative; top: 7px;"    data-id="{$familia.idfamilia_riesgo}"> 
                                <i style="margin-right:10px;" class="fa fa-pencil pull-right"></i>
                            </a>
                        </div>

                    </li>
                {/foreach}
            </ul>
        </div>
        <div class="okm-row text-center container-btn">
            <div class="col-xs-12" {if $cuestionario.estado == '1' } hidden {/if} >
                <a href="javascript:;" id="btnPasarSigEtapa" class="btn btn-xs btn-default  btn-guardar dim-btns btn-sig-etapa" ><i class="fa fa-arrow-circle-o-right pull-left font-iconos"></i>{"Pasar a la siguiente etapa"|x_translate}</a>
            </div><i class="fa-sharp fa-solid fa-cloud-arrow-up"></i>
            <div class="col-xs-6"  {if $cuestionario.estado != '1' } hidden {/if} >
                <a id="btnVolverModificarCuestionarioListo"  style="height: 46px;"  class="btn btn-xs btn-default  btn-guardar dim-btn-mod-particular btn-agregar-pregunta" >{"Volver"|x_translate}</a>
            </div>
            <div class="col-xs-6"  {if $cuestionario.estado != '1' } hidden {/if} >
                <a href="javascript:;" id="btnGuardarListo" class="btn btn-xs btn-default  btn-guardar dim-btn-mod-particular btn-sig-etapa" ><i class="fa fa-arrow-circle-o-right pull-left font-iconos"></i>{"Guardar"|x_translate}</a>
            </div>


        </div>
    </div>
    <div class="clearfix">&nbsp;</div>
</section>


{literal}
    <script>
        $(function () {

            var rtaCerrada = true;
            var banderaClickFueraDeInput = 0;

            $("#agregarFamilia").click(function () {


                nombre = $("#input_titulo").val();
                idempresa = $("#idempresaMod").val();
                nuevaFamilia = $("#familiaInput").val();
                descripcionModelo = $("#descripcionInput").val();

                x_doAjaxCall(
                        'POST',
                        BASE_PATH + "empresa.php?action=1&modulo=riesgo&submodulo=agregar_familia_personalizable",
                        'idempresa=' + idempresa + '&idmodelos_riesgos=' + $("#idmodelos_riesgos").val() + '&titulo=' + nuevaFamilia + '&nombre=' + nombre
                        + '&descripcionModelo=' + descripcionModelo,
                        function (data) {
                            if (data.result) {

                                x_alert(x_translate(data.msg), function () {
                                    x_loadModule('riesgo', 'personalizar', 'idmodelos_riesgos=' + data.idmodelos_riesgos_nuevo, 'personalizadsecR');

                                });
                            } else {
                                x_alert(data.msg);
                            }
                        }
                );
            });


            // elimino el item riesgo
            $(".eliminarRiesgo").click(function () {

                descripcionModelo = $("#descripcionInput").val();
                titulo = $("#input_titulo").val();
                idempresa = $("#idempresaMod").val();

                //  mensajeCuestionario = $("#mensajeCuestionario").val();

                idfamilia_riesgo = $(this).data("id");
                jConfirm({
                    title: x_translate("Eliminar Familia Riesgo"),
                    text: x_translate('Esta seguro que desea eliminar la familia?'),
                    confirm: function () {
                        $("body").spin("large");
                        x_doAjaxCall(
                                'POST',
                                BASE_PATH + "empresa.php?action=1&modulo=riesgo&submodulo=eliminar_familia_riesgo",
                                'idfamilia_riesgo=' + idfamilia_riesgo + '&idmodelos_riesgos=' + $("#idmodelos_riesgos").val() +
                                '&titulo=' + titulo + '&idempresa=' + idempresa + '&descripcionModelo=' + descripcionModelo,
                                function (data) {
                                    if (data.result) {
                                        $("body").spin(false);
                                        x_alert(x_translate(data.msg), function () {

                                            x_loadModule('riesgo', 'personalizar', 'idmodelos_riesgos=' + data.idmodelos_riesgos_nuevo, 'personalizadsecR');
                                        });
                                    } else {
                                        $("body").spin(false);
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


            // btn que pasa a la siguiente etapa setea los campos faltantes en cuestionario
            $("#btnPasarSigEtapa").click(function () {
                var fecha_actual = new Date(new Date().getFullYear(), new Date().getMonth(), new Date().getDate());
                var arr_split = $("#fecha_inicio").val().split("/");
                var fecha_adhesion = new Date(parseInt(arr_split[2]), parseInt(arr_split[1] - 1), parseInt(arr_split[0]));
                var arr_split_fin = $("#fecha_fin").val().split("/");
                var fecha_fin_var = new Date(parseInt(arr_split_fin[2]), parseInt(arr_split_fin[1] - 1), parseInt(arr_split_fin[0]));
                //console.log($("#cantPreguntas").val());
                cantpre = $("#cantPreguntas").val();
                idcuestionario = $("#idcuestionario").val();
                titulo = $("#input_titulo").val();
                estimacion = $("#input_estimacion").val();

                var vregexNaix = /^(0[1-9]|[1-2]\d|3[01])(\/)(0[1-9]|1[012])\2(\d{4})$/;
                fecha_inicio_para = $("#fecha_inicio").val();
                if (!vregexNaix.test(fecha_inicio_para)) {
                    x_alert(x_translate("Fecha Invalida"));
                    $("#fecha_inicio").css('border', 'solid 2px red');
                    return false;
                }
                fecha_fina_para = $("#fecha_fin").val();
                if (!vregexNaix.test(fecha_fina_para)) {
                    x_alert(x_translate("Fecha Invalida"));
                    $("#fecha_fin").css('border', 'solid 2px red');
                    return false;
                }
                idempresa = $("#idempresaCues").val();
                mensajeCuestionario = $("#mensajeCuestionario").val();
                if (titulo != '' && estimacion != '' && fecha_inicio_para != '' && fecha_fina_para != '') {
                    if (cantpre == '0') {
                        x_alert(x_translate("No puede crear un cuestionario sin preguntas"));
                    } else if (fecha_adhesion.getTime() < fecha_actual.getTime()) {
                        x_alert(x_translate("La fecha de inicio no puede ser anterior a hoy"));
                        $("#fecha_inicio").css('border', 'solid 2px red');
                    } else if (fecha_fin_var.getTime() < fecha_adhesion.getTime()) {
                        x_alert(x_translate("La fecha de fin no puede ser anterior a la de inicio"));
                        $("#fecha_fin").css('border', 'solid 2px red');
                    } else {

                        x_doAjaxCall(
                                'POST',
                                BASE_PATH + "empresa.php?action=1&modulo=gestion&submodulo=setear_datos_cuestionarios",
                                'idcuestionario=' + idcuestionario + '&titulo=' + titulo + '&estimacion_cuestionarios_totales=' + estimacion
                                + '&fecha_inicio=' + fecha_inicio_para + '&fecha_fin=' + fecha_fina_para + '&idempresa=' + idempresa + '&mensaje=' + mensajeCuestionario,
                                function (data) {
                                    console.log(data);
                                    if (data.result) {

                                        if (data.idcuestionarionuevo != null) {

                                            idcuestionario = data.idcuestionarionuevo;
                                        }
                                        window.location.href = BASE_PATH + "entreprises/questionnaireslist/parametres/" + idcuestionario + ".html";

                                    } else {
                                        x_alert(data.msg);
                                    }
                                }
                        );
                    }
                } else {
                    if (titulo == '') {
                        $("#input_titulo").css('border', 'solid 2px red');

                    } else {
                        $("#input_titulo").css('border', '1px solid #ccc');

                    }

                    if (estimacion == '') {
                        $("#input_estimacion").css('border', 'solid 2px red');

                    } else {
                        $("#input_estimacion").css('border', '1px solid #ccc');

                    }
                    if (fecha_inicio_para == '') {
                        $("#fecha_inicio").css('border', 'solid 2px red');

                    } else {
                        $("#fecha_inicio").css('border', '1px solid #ccc');

                    }
                    if (fecha_fina_para == '') {
                        $("#fecha_fin").css('border', 'solid 2px red');
                    } else {
                        $("#fecha_fin").css('border', '1px solid #ccc');

                    }
                    x_alert(x_translate("Debe completar todos los campos"));
                }

            });

            // para detectar click fuera del input y tomarlo como enter
            $(document).click(function () {
                if (banderaClickFueraDeInput == 1) {
                    var obj = $(".spanesids");
                    if (!obj.is(event.target) && !obj.has(event.target).length) {

                        banderaClickFueraDeInput = 0;
                        //console.log($("#span-" + ideditar).text());
                        idempresa = $("#idempresaMod").val();
                        idmodelos_riesgos = $("#idmodelos_riesgos").val();
                        descripcionModelo = $("#descripcionInput").val();
                        tituloModelo = $("#input_titulo").val();
                        textoIngresado = $("#span-" + ideditar).val();


                        x_doAjaxCall(
                                'POST',
                                BASE_PATH + "empresa.php?action=1&modulo=riesgo&submodulo=actualizar_familia",
                                'idfamilia_riesgo=' + ideditar + '&idmodelos_riesgos=' + idmodelos_riesgos + '&descripcionModelo=' + descripcionModelo
                                + '&tituloModelo=' + tituloModelo + '&idempresa=' + idempresa + '&titulo=' + textoIngresado,
                                function (data) {
                                    if (data.result) {
                                        // console.log(data);

                                        x_loadModule('riesgo', 'personalizar', 'idmodelos_riesgos=' + data.idmodelos_riesgos_nuevo, 'personalizadsecR');
                                    }
                                }
                        );
                    }

                }
            });


            var ideditar;
            var resultTexto;
            $(".editarPregunta").click(function () {
                $("#labeli-" + $(this).data("id")).css('display', 'none');

                $(".labels-btns").css('display', 'none');

                $(".spanesids").css('border', 'none');
                $(".spanesids").attr('disabled', true);
                $("#span-" + $(this).data("id")).css('display', 'block');
                $("#span-" + $(this).data("id")).css('border', 'solid 2px red');
                $("#span-" + $(this).data("id")).attr('disabled', false);
                event.stopPropagation();
                result = $(this).data("id");

                ideditar = result;

                banderaClickFueraDeInput = 1;
            });

            // esto es para detectar el enter dentro de un actualizar y actualizarlo
            $(".spanesids").keypress(function (event) {

                var keycode = (event.keyCode ? event.keyCode : event.which);
                if (keycode == '13') {
                    idempresa = $("#idempresaMod").val();
                    idmodelos_riesgos = $("#idmodelos_riesgos").val();
                    descripcionModelo = $("#descripcionInput").val();
                    tituloModelo = $("#input_titulo").val();
                    banderaClickFueraDeInput = 0;
                    //console.log($("#span-" + ideditar).text());


                    textoIngresado = $("#span-" + ideditar).val();

                    x_doAjaxCall(
                            'POST',
                            BASE_PATH + "empresa.php?action=1&modulo=riesgo&submodulo=actualizar_familia",
                            'idfamilia_riesgo=' + ideditar + '&idmodelos_riesgos=' + idmodelos_riesgos + '&descripcionModelo=' + descripcionModelo
                            + '&tituloModelo=' + tituloModelo + '&idempresa=' + idempresa + '&titulo=' + textoIngresado,
                            function (data) {
                                if (data.result) {
                                    // console.log(data);

                                    x_loadModule('riesgo', 'personalizar', 'idmodelos_riesgos=' + data.idmodelos_riesgos_nuevo, 'personalizadsecR');
                                }
                            }
                    );
                }

            });


            // btn que aparece cuando va a modificar un cuestionario en estado listo
            $("#btnGuardarListo").click(function () {
                var fecha_actual = new Date(new Date().getFullYear(), new Date().getMonth(), new Date().getDate());
                var arr_split = $("#fecha_inicio").val().split("/");
                var fecha_adhesion = new Date(parseInt(arr_split[2]), parseInt(arr_split[1] - 1), parseInt(arr_split[0]));
                var arr_split_fin = $("#fecha_fin").val().split("/");
                var fecha_fin_var = new Date(parseInt(arr_split_fin[2]), parseInt(arr_split_fin[1] - 1), parseInt(arr_split_fin[0]));
                //console.log($("#cantPreguntas").val());
                cantpre = $("#cantPreguntas").val();
                idcuestionario = $("#idcuestionario").val();
                titulo = $("#input_titulo").val();
                estimacion = $("#input_estimacion").val();
                mensajeCuestionario = $("#mensajeCuestionario").val();

                var vregexNaix = /^(0[1-9]|[1-2]\d|3[01])(\/)(0[1-9]|1[012])\2(\d{4})$/;
                fecha_inicio_para = $("#fecha_inicio").val();
                if (!vregexNaix.test(fecha_inicio_para)) {
                    x_alert(x_translate("Fecha Invalida"));
                    $("#fecha_inicio").css('border', 'solid 2px red');
                    return false;
                }

                fecha_fina_para = $("#fecha_fin").val();
                if (!vregexNaix.test(fecha_fina_para)) {
                    x_alert(x_translate("Fecha Invalida"));
                    $("#fecha_fin").css('border', 'solid 2px red');
                    return false;
                }
                idempresa = $("#idempresaCues").val();
                if (titulo != '' && estimacion != '' && fecha_inicio_para != '' && fecha_fina_para != '') {
                    if (cantpre == '0') {
                        x_alert(x_translate("No puede crear un cuestionario sin preguntas"));
                    } else if (fecha_adhesion.getTime() < fecha_actual.getTime()) {
                        x_alert(x_translate("La fecha de inicio no puede ser anterior a hoy"));
                        $("#fecha_inicio").css('border', 'solid 2px red');
                    } else if (fecha_fin_var.getTime() < fecha_adhesion.getTime()) {
                        x_alert(x_translate("La fecha de fin no puede ser anterior a la de inicio"));
                        $("#fecha_fin").css('border', 'solid 2px red');
                    } else {

                        x_doAjaxCall(
                                'POST',
                                BASE_PATH + "empresa.php?action=1&modulo=gestion&submodulo=actualizar_cuestionario_listo",
                                'idcuestionario=' + idcuestionario + '&titulo=' + titulo + '&estimacion_cuestionarios_totales=' + estimacion
                                + '&fecha_inicio=' + fecha_inicio_para + '&fecha_fin=' + fecha_fina_para + '&idempresa=' + idempresa + '&mensaje=' + mensajeCuestionario,
                                function (data) {
                                    // console.log(data);
                                    if (data.result) {

                                        x_alert(x_translate("Cuestionario actualizado"), function () {
                                            x_loadModule('gestion', 'personalizar', 'cuestionarios_idcuestionario=' + idcuestionario, 'personalizadsec');
                                        });

                                    } else {
                                        x_alert(data.msg);
                                    }
                                }
                        );
                    }
                } else {
                    if (titulo == '') {
                        $("#input_titulo").css('border', 'solid 2px red');

                    } else {
                        $("#input_titulo").css('border', '1px solid #ccc');

                    }

                    x_alert(x_translate("Debe completar todos los campos"));
                }
            });


            $("#btnVolverModificarCuestionarioListo").click(function () {
                idcuestionarioVolver = $("#idcuestionario").val();
                x_doAjaxCall(
                        'POST',
                        BASE_PATH + "empresa.php?action=1&modulo=gestion&submodulo=generar_qr_btnvolverModificar",
                        'idcuestionario=' + idcuestionarioVolver,
                        function (data) {
                            // console.log(data);
                            $("body").spin(false);
                            if (data.result) {
                                window.location.href = BASE_PATH + "entreprises/questionnairesready/" + data.hash + ".html";

                            } else {
                                x_alert(data.msg);
                            }
                        }
                );
            });


            $("#rtaAbierta").click(function () {
                $("#divrtaAbierta").addClass("modo-select");
                $("#divrtaCerrada").removeClass("modo-select");
                rtaCerrada = false;
                $('#label-abierta-' + ideditar).addClass("seleccionado");
                $('#label-cerrada-' + ideditar).removeClass("seleccionado");
                event.stopPropagation();

            });
            $("#rtaCerrada").click(function () {
                $("#divrtaCerrada").addClass("modo-select");
                $("#divrtaAbierta").removeClass("modo-select");
                $('#label-abierta-' + ideditar).removeClass("seleccionado");
                $('#label-cerrada-' + ideditar).addClass("seleccionado");
                rtaCerrada = true;
                event.stopPropagation();

            });

            $(".label-abierta").click(function () {
                event.stopPropagation();
                $("#divrtaAbierta").addClass("modo-select");
                $("#divrtaCerrada").removeClass("modo-select");
                rtaCerrada = false;
                $('#label-abierta-' + ideditar).addClass("seleccionado");
                $('#label-cerrada-' + ideditar).removeClass("seleccionado");
            });
            $(".label-cerrada").click(function () {
                event.stopPropagation();
                $("#divrtaCerrada").addClass("modo-select");
                $("#divrtaAbierta").removeClass("modo-select");
                $('#label-abierta-' + ideditar).removeClass("seleccionado");
                $('#label-cerrada-' + ideditar).addClass("seleccionado");
                rtaCerrada = true;
            });



            $("#input_titulo").keypress(function () {
                if ($("#input_titulo").val().length >= 0) {
                    $("#input_titulo").css('border', '1px solid #ccc');
                } else {
                    $("#input_titulo").css('border', 'solid 2px red');
                }
            });
        });


        /*   $(document).ready(function () {
         $(function () {
         $("#mi_lista").sortable({update: function () {
         
         var ordem_atual = $(this).sortable("serialize");
         x_doAjaxCall(
         'POST',
         BASE_PATH + "empresa.php?action=1&modulo=gestion&submodulo=actualizar_orden",
         'miorden=' + ordem_atual,
         function () {
         
         }
         );
         }
         });
         });
         }); */

    </script>
{/literal}