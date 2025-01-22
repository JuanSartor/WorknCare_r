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
<section class="okm-container" id="personalizadsec">
    <!-- primer columna -->
    <input  id="idcuestionario" hidden value='{$cuestionario.idcuestionario}'>
    <input  id="idempresaCues" hidden value='{$cuestionario.empresa_idempresa}'>
    <input  id="cantPreguntas" hidden value='{$listado_preguntas|@count}'>
    <input  id="estadoCuestionario" hidden value='{$cuestionario.estado}'>

    <div class="col-xs-6 programas-incluidos">
        <h2 class="title">
            <button onclick="location.href = 'JavaScript:window.history.back();'"  class="btn btn-transparen go-back-button btn-volver"><i class="fa fa-chevron-left"></i></button>
                {"Cuestionario"|x_translate}

        </h2>
        <div class="container-inputs" style="margin-top: 50px;">
            <div class="col-xs-12">
                <label  class="mapc-label label-personalizar"> {"Añadir titulo"|x_translate}</label>
                {if $cuestionario.empresa_idempresa=='0'}
                    {if $TRADUCCION_DEFAULT=="fr"}    <input id="input_titulo" class="input-personalizar input-title" type="text"  value="{$cuestionario.titulo}" placeholder="{$cuestionario.titulo}"/>
                    {else}
                        <input id="input_titulo" class="input-personalizar input-title" type="text"  value="{$cuestionario.titulo_en}" placeholder="{$cuestionario.titulo_en}"/>
                    {/if}
                {else}
                    <input id="input_titulo" class="input-personalizar input-title" type="text"  value="{$cuestionario.titulo}" placeholder="{$cuestionario.titulo}"/>
                {/if}


            </div>

            <div class="col-xs-12">
                <label  class="mapc-label label-personalizar"> {"Añadir duracion"|x_translate}</label>
                <input id="fecha_inicio" class="input-personalizar" type="text"  value="{$cuestionario.fecha_inicio|date_format:"%d/%m/%Y"}"  placeholder="{$cuestionario.fecha_inicio}"/>
                <input id="fecha_fin" class="input-personalizar" type="text"  value="{$cuestionario.fecha_fin|date_format:"%d/%m/%Y"}" placeholder="{$cuestionario.fecha_fin}"/>
            </div>
            <div class="col-xs-12">
                <label  class="mapc-label label-personalizar"> {"Numero estimado de personas a realizar cuestionario."|x_translate}</label>
                <input id="input_estimacion" class="input-personalizar" type="number"  value="{$cuestionario.estimacion_cuestionarios_totales}" placeholder="{$cuestionario.estimacion_cuestionarios_totales}"/>
            </div>
        </div>
        <div class="col-xs-12">
            <label  class="mapc-label label-personalizar"> {"Mensaje introductorio"|x_translate}</label>
            <textarea maxlength="150" id="mensajeCuestionario" name="mensajeCuestionario" value="{$cuestionario.mensaje}" rows="7" cols="35">{$cuestionario.mensaje}</textarea>
        </div>

    </div>
    <!-- segunda columna -->
    <div class="col-xs-6 preguntas-incluidas">
        <h2 class="title title-preguntas">
            {"Preguntas"|x_translate}
        </h2>
        <br> 

        <label  class="mapc-label label-personalizar"> {"Nueva Pregunta"|x_translate}</label>
        <input  maxlength="130" style="width: 70%; font-size: 20px;" type="text" id="preguntaInput">
        <div class="col-xs-6" style="position: relative; top: -58px;  left: 400px; width: 200px;">
            <a style="font-size: 15px; width: 200px;" href="javascript:;" id="agregarPregunta" class="btn btn-xs btn-default  btn-guardar dim-btns btn-agregar-pregunta" ><i class="fa fa-plus-circle pull-left font-iconos"></i>{"Agregar"|x_translate}</a>
        </div>

        <div class="col-xs-12" style="bottom: 20px;">
            <a id="rtaCerrada" class="cursors" data-val="1">
                <div id="divrtaCerrada" class="col-xs-6 modo-select" style="padding-top: 5px; padding-left: 5px;">

                    <div class="col-xs-12" style="text-align: center">
                        <label  class="mapc-label label-personalizar" style="color: #ED799E;"> {"Cerrada"|x_translate}</label>
                    </div>
                    <div class="col-xs-12" >
                        <div  style="display: flex;">
                            <div style="background: #dddddd; text-align: center; left: 3px;" class="circulo"><i style="color: white;" class="fa fa-thumbs-down"></i></div>
                            <div style="background: #dddddd; right: 11px;" class="rectangulo"></div>
                            <div style="background: #a9c5a9; margin-left: 56px;" class="circulo"></div>
                            <div style="background: #a9c5a9; right: 11px;" class="rectangulo"></div>
                            <div style="background: #88bf88; margin-left: 126px;" class="circulo"></div>
                            <div style="background: #88bf88; right: 11px;" class="rectangulo"></div>
                            <div style="background: #82bd82; margin-left: 195px; text-align: center;" class="circulo"><i style="color: white;" class="fa fa-thumbs-up"></i></div>
                        </div>

                        <div  style="margin-top: 20px;">
                            <label style="margin-right: 2px; width: 50px; position: relative; right: 11px;" class="label-rta">{"Para nada de acuerdo"|x_translate}</label>
                            <label class="label-rta" style="width: 46px;">{"Casi de acuerdo"|x_translate}</label>
                            <label class="label-rta" style="width: 50px; position: relative; left: 21px;">{"De acuerdo"|x_translate}</label>
                            <label class="label-rta" style="width: 50px; position: relative; left: 16px;">{"Absolutamente de acuerdo"|x_translate}</label>
                        </div>
                    </div>

                </div>
            </a>
            <a  id="rtaAbierta" class="cursors" data-val="2">
                <div id="divrtaAbierta" class="col-xs-6" style="padding-top: 5px; padding-left: 5px; padding-bottom: 15px;">
                    <div class="col-xs-12" style="text-align: center">
                        <label  class="mapc-label label-personalizar" style="color: #3DB4C0;"> {"Abierta"|x_translate}</label>
                    </div>
                    <div class="col-xs-12"  >
                        <input class="cursors" style="width: 200px; height: 30px; margin-left: 10px;" type="text" disabled  >
                    </div>
                </div>
            </a>
        </div>

        <div class="preguntas-iniciales" style="position: relative; margin-top: 180px;" >
            <ul id="mi_lista" style="position: relative; ">
                {foreach from=$listado_preguntas item=pregunta}
                    <li {if $pregunta.cerrada} id="miorden_{$pregunta.idpregunta}c" {else}id="miorden_{$pregunta.idpregunta_abierta_cuestionario}a"{/if}>
                        <div class="pregunta-item" style="display: flex;">

                            <input class="spanesids"  hidden    style="width: 70%; cursor:pointer;"  type="text" disabled   {if $pregunta.cerrada} id="span-cerrada-{$pregunta.idpregunta}" {else} id="span-abierta-{$pregunta.idpregunta_abierta_cuestionario}"{/if}   value="    {if $TRADUCCION_DEFAULT=="fr"} {$pregunta.pregunta} {else}{$pregunta.pregunta_en} {/if}">

                            <label style=" margin-right: 7px; width: 70%; background: #ededed; cursor: pointer; padding-left: 10px; line-height: 1.5; position: relative;" {if $pregunta.cerrada} id="labeli-cerrada-{$pregunta.idpregunta}" {else} id="labeli-abierta-{$pregunta.idpregunta_abierta_cuestionario}"{/if} >
                                {if $cuestionario.empresa_idempresa=='0'}
                                    {if $TRADUCCION_DEFAULT=="fr"}  {$pregunta.pregunta}
                                    {else}
                                        {$pregunta.pregunta_en}
                                    {/if}
                                {else}
                                    {$pregunta.pregunta}
                                {/if}
                            </label>

                            {if $pregunta.cerrada}
                                <label style=" max-height:40px; width: 90px; background: #ED799E; border-radius: 8px; text-align: center; color: white; position: relative;  cursor:pointer;">
                                    <h6 style="font-size: 15px; height: 10px; font-weight: 700; line-height: 0.9; position: relative; bottom: 8px;">  {"Cerrada"|x_translate} </h6>
                                </label>
                            {else}
                                <label style="max-height:40px; width: 90px; background: #3DB4C0; border-radius: 8px; text-align: center; color: white; position: relative;  cursor:pointer;">
                                    <h6 style="font-size: 15px; height: 10px; font-weight: 700; line-height: 0.9; position: relative; bottom: 8px;">  {"Abierta"|x_translate} </h6>
                                </label>
                            {/if}
                            <a   class="eliminarPregunta" style="position: relative; top: 7px;" {if $pregunta.cerrada} data-id="cerrada-{$pregunta.idpregunta}" {else} data-id="abierta-{$pregunta.idpregunta_abierta_cuestionario}"{/if} > 
                                <i class="fa fa-trash pull-right"></i>
                            </a>
                            <a   class="editarPregunta" style="position: relative; top: 7px;"  {if $pregunta.cerrada} data-id="cerrada-{$pregunta.idpregunta}" {else} data-id="abierta-{$pregunta.idpregunta_abierta_cuestionario}"{/if}> 
                                <i style="margin-right:10px;" class="fa fa-pencil pull-right"></i>
                            </a>
                        </div>
                        <div style="display: none;" class="pregunta-item labels-btns" {if $pregunta.cerrada} id="div-cerrada-{$pregunta.idpregunta}" {else} id="div-abierta-{$pregunta.idpregunta_abierta_cuestionario}"{/if}  >
                            <label class="label-cerrada" {if $pregunta.cerrada} id="label-cerrada-{$pregunta.idpregunta}" {else} id="label-cerrada-{$pregunta.idpregunta_abierta_cuestionario}"{/if}  {if $pregunta.cerrada} data-id="label-cerrada-{$pregunta.idpregunta}" {else} data-id="label-cerrada-{$pregunta.idpregunta_abierta_cuestionario}"{/if} style="width: 90px; background: #ED799E; border-radius: 8px; text-align: center; color: white; position: relative; ">
                                <h6 style="font-size: 15px; height: 10px; font-weight: 700; line-height: 0.9; position: relative; bottom: 8px;">  {"Cerrada"|x_translate} </h6>
                            </label>
                            <label class="label-abierta" {if $pregunta.cerrada} id="label-abierta-{$pregunta.idpregunta}" {else} id="label-abierta-{$pregunta.idpregunta_abierta_cuestionario}"{/if} {if $pregunta.cerrada} data-id="label-cerrada-{$pregunta.idpregunta}" {else} data-id="label-cerrada-{$pregunta.idpregunta_abierta_cuestionario}"{/if}  style="width: 90px; background: #3DB4C0; border-radius: 8px; text-align: center; color: white; position: relative; margin-left: 10px;">
                                <h6 style="font-size: 15px; height: 10px; font-weight: 700; line-height: 0.9; position: relative; bottom: 8px;">  {"Abierta"|x_translate} </h6>
                            </label> 
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

            $("#agregarPregunta").click(function () {
                // console.log($("#preguntaInput").val());
                // esto lo hice para que cuando agregue una pregunta si completo los demas inputs los cargue
                var fecha_actual = new Date(new Date().getFullYear(), new Date().getMonth(), new Date().getDate());
                var arr_split = $("#fecha_inicio").val().split("/");
                var fecha_adhesion = new Date(parseInt(arr_split[2]), parseInt(arr_split[1] - 1), parseInt(arr_split[0]));
                var arr_split_fin = $("#fecha_fin").val().split("/");
                var fecha_fin_var = new Date(parseInt(arr_split_fin[2]), parseInt(arr_split_fin[1] - 1), parseInt(arr_split_fin[0]));
                //console.log($("#cantPreguntas").val());

                titulo = $("#input_titulo").val();
                estimacion = $("#input_estimacion").val();
                fecha_inicio_para = $("#fecha_inicio").val();
                fecha_fina_para = $("#fecha_fin").val();
                ///////////
                idcuestionario = $("#idcuestionario").val();
                idempresaCues = $("#idempresaCues").val();
                nuevaPregunta = $("#preguntaInput").val();
                mensajeCuestionario = $("#mensajeCuestionario").val();

                x_doAjaxCall(
                        'POST',
                        BASE_PATH + "empresa.php?action=1&modulo=gestion&submodulo=agregar_pregunta_personalizable",
                        'idempresa=' + idempresaCues + '&idcuestionario=' + idcuestionario + '&nuevaPregunta=' + nuevaPregunta + '&titulo=' + titulo + '&estimacion_cuestionarios_totales=' + estimacion
                        + '&fecha_inicio=' + fecha_inicio_para + '&fecha_fin=' + fecha_fina_para + '&rtaCerrada=' + rtaCerrada + '&mensaje=' + mensajeCuestionario,
                        function (data) {
                            if (data.result) {
                                // console.log(data);

                                x_alert(x_translate(data.msg), function () {
                                    x_loadModule('gestion', 'personalizar', 'cuestionarios_idcuestionario=' + data.idcuestionarionuevo, 'personalizadsec');

                                });
                            } else {
                                x_alert(data.msg);
                            }
                        }
                );
            });
            // elimino la pregunta
            $(".eliminarPregunta").click(function () {

                // esto lo hice para que cuando agregue una pregunta si completo los demas inputs los cargue
                var fecha_actual = new Date(new Date().getFullYear(), new Date().getMonth(), new Date().getDate());
                var arr_split = $("#fecha_inicio").val().split("/");
                var fecha_adhesion = new Date(parseInt(arr_split[2]), parseInt(arr_split[1] - 1), parseInt(arr_split[0]));
                var arr_split_fin = $("#fecha_fin").val().split("/");
                var fecha_fin_var = new Date(parseInt(arr_split_fin[2]), parseInt(arr_split_fin[1] - 1), parseInt(arr_split_fin[0]));
                //console.log($("#cantPreguntas").val());

                titulo = $("#input_titulo").val();
                estimacion = $("#input_estimacion").val();
                fecha_inicio_para = $("#fecha_inicio").val();
                fecha_fina_para = $("#fecha_fin").val();
                mensajeCuestionario = $("#mensajeCuestionario").val();

                idpregunta = $(this).data("id");
                jConfirm({
                    title: x_translate("Eliminar Pregunta"),
                    text: x_translate('Esta seguro que desea eliminar la pregunta del cuestionario?'),
                    confirm: function () {
                        $("body").spin("large");
                        x_doAjaxCall(
                                'POST',
                                BASE_PATH + "empresa.php?action=1&modulo=gestion&submodulo=eliminar_pregunta_personalizable",
                                'idpregunta=' + idpregunta + '&cuestionarios_idcuestionario=' + $("#idcuestionario").val() + '&idempresa=' + $("#idempresaCues").val() +
                                '&titulo=' + titulo + '&estimacion_cuestionarios_totales=' + estimacion
                                + '&fecha_inicio=' + fecha_inicio_para + '&fecha_fin=' + fecha_fina_para + '&mensaje=' + mensajeCuestionario,
                                function (data) {
                                    if (data.result) {
                                        $("body").spin(false);
                                        x_alert(x_translate(data.msg), function () {
                                            x_loadModule('gestion', 'personalizar', 'cuestionarios_idcuestionario=' + data.idcuestionarionuevo, 'personalizadsec');
                                            // window.location.href = BASE_PATH + "entreprises/questionnaireslist/personalizar/" + data.idcuestionarionuevo + ".html";
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
            //opciones date picker de fecha de nacimiento
            $('#fecha_inicio').mask("00/00/0000", {placeholder: "JJ/MM/AAAA"});
            $('#fecha_fin').mask("00/00/0000", {placeholder: "JJ/MM/AAAA"});
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
                        idempresa = $("#idempresaCues").val();
                        idcuestionario = $("#idcuestionario").val();
                        idempresaCues = $("#idempresaCues").val();
                        if (result[0] == 'cerrada') {
                            npreguntActualizada = $("#span-cerrada-" + ideditar).val();
                        } else {
                            npreguntActualizada = $("#span-abierta-" + ideditar).val();
                        }

                        titulo = $("#input_titulo").val();
                        estimacion = $("#input_estimacion").val();
                        fecha_inicio_para = $("#fecha_inicio").val();
                        fecha_fina_para = $("#fecha_fin").val();
                        mensajeCuestionario = $("#mensajeCuestionario").val();
                        x_doAjaxCall(
                                'POST',
                                BASE_PATH + "empresa.php?action=1&modulo=gestion&submodulo=actualizar_pregunta",
                                'idpregunta=' + ideditar + '&idcuestionario=' + idcuestionario + '&pregunta=' + npreguntActualizada
                                + '&titulo=' + titulo + '&estimacion_cuestionarios_totales=' + estimacion + '&fecha_inicio=' + fecha_inicio_para
                                + '&fecha_fin=' + fecha_fina_para + '&id_empresa=' + idempresa + '&rtaCerrada=' + rtaCerrada + '&primerRta=' + resultTexto + '&mensaje=' + mensajeCuestionario,
                                function (data) {
                                    if (data.result) {
                                        banderaClickFueraDeInput = 0;
                                        // console.log(data);
                                        x_loadModule('gestion', 'personalizar', 'cuestionarios_idcuestionario=' + data.idcuestionario, 'personalizadsec');
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
                result = $(this).data("id").split('-');
                if (result[0] == 'cerrada') {
                    $("#divrtaCerrada").addClass("modo-select");
                    $("#divrtaAbierta").removeClass("modo-select");
                    rtaCerrada = true;
                    $('#div-cerrada-' + result[1]).css('display', 'block');
                    $('#label-cerrada-' + result[1]).addClass("seleccionado");
                } else {
                    $("#divrtaAbierta").addClass("modo-select");
                    $("#divrtaCerrada").removeClass("modo-select");
                    rtaCerrada = false;
                    $('#div-abierta-' + result[1]).css('display', 'block');
                    $('#label-abierta-' + result[1]).addClass("seleccionado");
                }
                ideditar = result[1];
                resultTexto = result[0];
                banderaClickFueraDeInput = 1;
            });

            // esto es para detectar el enter dentro de un actualizar y actualizarlo
            $(".spanesids").keypress(function (event) {

                var keycode = (event.keyCode ? event.keyCode : event.which);
                if (keycode == '13') {
                    idempresa = $("#idempresaCues").val();
                    banderaClickFueraDeInput = 0;
                    //console.log($("#span-" + ideditar).text());
                    idcuestionario = $("#idcuestionario").val();
                    idempresaCues = $("#idempresaCues").val();
                    if (result[0] == 'cerrada') {
                        npreguntActualizada = $("#span-cerrada-" + ideditar).val();
                    } else {
                        npreguntActualizada = $("#span-abierta-" + ideditar).val();
                    }

                    titulo = $("#input_titulo").val();
                    estimacion = $("#input_estimacion").val();
                    fecha_inicio_para = $("#fecha_inicio").val();
                    fecha_fina_para = $("#fecha_fin").val();
                    mensajeCuestionario = $("#mensajeCuestionario").val();
                    x_doAjaxCall(
                            'POST',
                            BASE_PATH + "empresa.php?action=1&modulo=gestion&submodulo=actualizar_pregunta",
                            'idpregunta=' + ideditar + '&idcuestionario=' + idcuestionario + '&pregunta=' + npreguntActualizada
                            + '&titulo=' + titulo + '&estimacion_cuestionarios_totales=' + estimacion + '&fecha_inicio=' + fecha_inicio_para
                            + '&fecha_fin=' + fecha_fina_para + '&id_empresa=' + idempresa + '&rtaCerrada=' + rtaCerrada + '&primerRta=' + resultTexto + '&mensaje=' + mensajeCuestionario,
                            function (data) {
                                if (data.result) {
                                    // console.log(data);
                                    x_loadModule('gestion', 'personalizar', 'cuestionarios_idcuestionario=' + data.idcuestionario, 'personalizadsec');
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

            $("#input_estimacion").keypress(function () {
                if ($("#input_estimacion").val().length >= 0) {
                    $("#input_estimacion").css('border', '1px solid #ccc');
                } else {
                    $("#input_estimacion").css('border', 'solid 2px red');
                }
            });

            $("#fecha_inicio").keypress(function () {
                if ($("#fecha_inicio").val().length >= 0) {
                    $("#fecha_inicio").css('border', '1px solid #ccc');
                } else {
                    $("#fecha_inicio").css('border', 'solid 2px red');
                }
            });

            $("#fecha_fin").keypress(function () {
                if ($("#fecha_fin").val().length >= 0) {
                    $("#fecha_fin").css('border', '1px solid #ccc');

                } else {
                    $("#fecha_fin").css('border', 'solid 2px red');
                }
            });

        });


        $(document).ready(function () {
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
        });

    </script>
{/literal}