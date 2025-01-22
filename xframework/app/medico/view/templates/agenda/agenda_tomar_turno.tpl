<!--	datos administrador-->
<link href="{$url}xframework/core/libs/libs_js/intl-tel-input/build/css/intlTelInput.css" rel="stylesheet" >
<script src="{$url_js_libs}/intl-tel-input/build/js/intlTelInput.js"></script>
<script src="{$url_js_libs}/intl-tel-input/build/js/utils.js"></script>
{include file="agenda/agenda_header.tpl"}

{*verificamos si el turno aun se encuentra disponible*}
{if $turno.estado!=0 || $turno.paciente_idpaciente!="" ||$turno.turno_pasado==1}
    <section class="ag-turno">
        <div class="okm-container">
            <h1>{"El turno ya no se encuentra disponible"|x_translate}</h1>
            <div class="ag-container">
                <div class="">


                    <div class="okm-row">
                        <div class="col-ag-nuevo-paciente-form-actions">

                            <button class="btn-default-square" onclick="window.location.href = '{$url}panel-medico/agenda/detalle-turno-{$turno.idturno}.html'">{"detalle del turno"|x_translate}</button>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </section>
{else}

    <input type="hidden" id="idturno" value="{$smarty.request.idturno}"/>
    <section class="ag-turno">
        <div class="okm-container">
            <h1>{"Tomar turno / Agregar paciente"|x_translate}</h1>
            <div class="ag-container">

                <div class="okm-row ag-search-row">
                    <div class="col-busqueda">
                        <div  class="cobertura-form-row green-search-box">
                            <input type="text" id="query_str" placeholder='{"Buscar por Nombre / DNI"|x_translate}'/>
                            <button id="resultados-busqueda-trg"><i class="icon-doctorplus-search"></i></button>
                        </div>
                    </div>
                    <div class="col-agregar-usurio">
                        <a href="javascript:;" class="btn-default-square ag-btn-paciente-nuevo" id="ag-paciente-nuevo-trg">{"Paciente nuevo en DoctorPlus"|x_translate}</a>
                    </div>
                </div>

                <div class="datos-nuevo-paciente-box" id="ag-paciente-nuevo">
                    <h3><i class="icon-doctorplus-user"></i> {"Datos del Paciente"|x_translate}</h3>
                    <form id="f_nuevo_paciente" action="{$url}paciente_nuevo_reservar_turno.do" method="POST" onsubmit="return false;">
                        <input type="hidden" id="idturno" name="idturno" value="{$smarty.request.idturno}"/>

                        <div class="okm-row">
                            <div class="col-ag-nuevo-paciente">
                                <div class="bst-form-row cobertura-form-row green-input-box">
                                    <input type="text" id="nombre" maxlength="15" name="nombre" placeholder='{"Nombre"|x_translate}'>
                                    <span class="obligatorio">*</span>
                                </div>
                            </div>
                            <div class="col-ag-nuevo-paciente">
                                <div class="bst-form-row cobertura-form-row green-input-box">
                                    <input type="text" id="apellido" maxlength="20" name="apellido" placeholder='{"Apellido"|x_translate}'>
                                    <span class="obligatorio">*</span>
                                </div>
                            </div>
                        </div>

                        <div class="okm-row">
                            <div class="col-ag-nuevo-paciente">
                                <div class="bst-form-row cobertura-form-row green-search-box" id="datetimepicker1">
                                    <input type="text" id="fechaNacimiento" name="fechaNacimiento" placeholder='{"Fecha de nacimiento"|x_translate}'/>
                                    <button><i class="icon-doctorplus-calendar"></i></button>
                                    <span class="obligatorio">*</span>
                                </div>
                            </div>
                            <div class="col-ag-nuevo-paciente">
                                <div class="bst-form-row cobertura-form-row">
                                    <select class="form-control select select-block green-select" id="sexo" name="sexo">
                                        <option value="1">{"HOMBRE"|x_translate}</option>
                                        <option value="0">{"MUJER"|x_translate}</option>
                                    </select>
                                    <span class="obligatorio">*</span>
                                </div>
                            </div>

                        </div>

                        <!--					---	-->
                        <div id="ag-paciente-menor" style="display:none;" >
                            <div class="ag-paciente-menor-disclaimer">
                                <p>{"En caso de menores de edad, ingresar los datos de contacto del adulto responsable."|x_translate} </p>
                            </div>

                            <div class="okm-row" id="info_tituar_container">
                                <div class="col-ag-nuevo-paciente ">
                                    <div class="bst-form-row cobertura-form-row green-input-box">
                                        <input type="text" id="titular_nombre" maxlength="15" name="titular_nombre" placeholder='{"Nombre del responsable"|x_translate}'>
                                        <span class="obligatorio">*</span>
                                    </div>
                                </div>

                                <div class="col-ag-nuevo-paciente ">
                                    <div class="bst-form-row cobertura-form-row green-input-box">
                                        <input type="text"  id="titular_apellido" maxlength="20" name="titular_apellido" placeholder='{"Apellido del responsable"|x_translate}'>
                                        <span class="obligatorio">*</span>
                                    </div>
                                </div>
                            </div>
                            {*
                            <div class="okm-row">
                            <div class="col-ag-nuevo-paciente">
                            <div class="bst-form-row cobertura-form-row green-input-box">
                            <input type="text" id="titular_DNI" name="titular_DNI" placeholder='{"DNI del responsable"|x_translate}'>
                            <span class="obligatorio">*</span>
                            </div>
                            </div>
                            <div class="col-ag-nuevo-paciente">
                            <div class="switch-large mul-sexo-switch ag-paciente-switch-box">
                            <span class="mapc-switch-label-left">{"Sexo"|x_translate}</span>
                            <input type="checkbox" class="switch-checkbox"  data-on-text='{"HOMBRE"|x_translate}'  data-off-text='{"MUJER"|x_translate}' data-on-label="1" data-off-label="0"  id="titular_sexo" name="titular_sexo"/>
                            </div>
                            </div>
                            </div>
                                
                            *}
                            {*
                            <div class="okm-row">
                            <div class="col-ag-nuevo-paciente">
                            <div class="bst-form-row cobertura-form-row green-search-box" id="datetimepicker2">
                            <input type="text" id="titular_fechaNacimiento" name="titular_fechaNacimiento" placeholder='{"Fecha de nacimiento del responsable"|x_translate}'/>
                            <button><i class="icon-doctorplus-calendar"></i></button>
                            <span class="obligatorio">*</span>
                            </div>
                            </div>

                            <div class="col-ag-nuevo-paciente">
                            <div class="mapc-registro-form-row mapc-select ag-paciente-select">
                            <select  id="relacionGrupo_idrelacionGrupo" name="relacionGrupo_idrelacionGrupo" class="form-control select select-primary select-block mbl pul-np-dis" >
                            <option value="">{"Relación con el paciente"|x_translate}</option>
                            {html_options options=$combo_relacion_grupo}
                            </select>
                            <span class="obligatorio">*</span>
                            </div>
                            </div>
                            </div>
                            *}
                        </div>

                        <!--					------------>
                        <div class="okm-row">



                            <div class="col-ag-nuevo-paciente">
                                <div class="bst-form-row cobertura-form-row green-input-box">
                                    <input type="text" id="email" name="email" placeholder='{"Email"|x_translate}' class="error">
                                    <span class="obligatorio">*</span>
                                </div>
                            </div>
                            <div class="col-ag-nuevo-paciente">
                                <div class="bst-form-row cobertura-form-row green-input-box">
                                    {*<input type="text" id="numeroCelular" name="numeroCelular" placeholder='{"Celular"|x_translate}' class="error">*}
                                    <div class="field-edit border smartphone">
                                        <input type="tel" id="numeroCelular" name="numeroCelular"  value="{$medico.numeroCelular}">
                                    </div>
                                </div>                           
                            </div>
                            <div class="col-ag-nuevo-paciente">
                                <div class="bst-form-row cobertura-form-row">
                                    <select class="form-control select select-block green-select" id="motivo-consulta2" name="idmotivoVisita">
                                        {if $turno.is_virtual==1}
                                            <option value="">{"Motivo de videoconsulta"|x_translate}</option>
                                            {html_options options=$combo_motivo_videoconsulta}
                                        {else}
                                            <option value="">{"Motivo de visita"|x_translate}</option>
                                            {html_options options=$combo_motivo_visita}
                                        {/if}
                                    </select>
                                </div>
                            </div>
                        </div>

                        {*
                        <div class="okm-row">
                        <div class="col-ag-nuevo-paciente">
                        <div class="bst-form-row cobertura-form-row">
                        <select class="form-control select select-block green-select" id="motivo-consulta2" name="idmotivoVisita">
                        {if $turno.is_virtual==1}
                        <option value="">{"Motivo de videoconsulta"|x_translate}</option>
                        {html_options options=$combo_motivo_videoconsulta}
                        {else}
                        <option value="">{"Motivo de visita"|x_translate}</option>
                        {html_options options=$combo_motivo_visita}
                        {/if}
                        </select>
                        </div>
                        </div>
                        </div>
                        *}
                        <div class="col-ag-nuevo-paciente-form-actions">
                            <button class="btn-alert-square">{"cancelar"|x_translate} <i class="icon-doctorplus-cruz"></i></button>
                            <button class="btn-default-square turno-agendado-trg" id="btnConfirmarTurnoPacienteNuevo">{"agendar y enviar datos del turno"|x_translate} <i class="icon-doctorplus-mail-send"></i></button>
                        </div>

                </div>
                {*informacion del paciente seleccionado para el turno-> se inicializan los campos una vez seleccionado un paciente del modal*}
                <div class="datos-nuevo-paciente-box" id="ag-paciente-detalle">
                    <div class="col-ag-nuevo-paciente-form ag-nuevo-paciente-block">
                        <div class="okm-row">
                            <div class="td-slide-paciente-row">
                                <figure>
                                    <img id="paciente_turno_imagen" src="" alt="">
                                </figure>

                                <h4 id="paciente_turno_nombre"></h4>

                                <span class="td-slide-paciente-fn"><i class="sexo-masculino icon-doctorplus-masc-symbol" style="display:none;"></i><i class="sexo-femenino icon-doctorplus-fem-symbol" style="display:none;"></i> <span id="paciente_turno_fecha_nacimiento"></span></span>

                            </div>

                            <div class="td-slide-turno-row">
                                <figure>
                                    <i class="icon-doctorplus-calendar"></i>
                                </figure>
                                <span class="td-slide-turno-fecha">{$nombre_dia} {$dia}  {$nombre_mes} {$anio}</span>
                                <span class="td-slide-turno-hora">{$turno.horarioInicio|date_format:"%H:%M"} hs</span>
                            </div>

                        </div>

                        <div class="bst-form-row cobertura-form-row ag-nuevo-usuario-select-spacer">
                            <select class="form-control select select-block green-select" id="motivo-consulta1">
                                {if $turno.is_virtual==1}
                                    <option value="">{"Motivo de videoconsulta"|x_translate}</option>
                                    {html_options options=$combo_motivo_videoconsulta}

                                {else}
                                    <option value="">{"Motivo de visita"|x_translate}</option>
                                    {html_options options=$combo_motivo_visita}
                                {/if}
                            </select>
                        </div>
                    </div>

                    <div class="col-ag-nuevo-paciente-form-actions">
                        <button id="btn_cancelar" class="btn-alert-square">{"cancelar"|x_translate} <i class="icon-doctorplus-cruz"></i></button>
                        <button id="btnConfirmarTurno" data-idpaciente="" class="btn-default-square turno-agendado-trg">{"agendar y enviar datos del turno"|x_translate} <i class="icon-doctorplus-mail-send"></i></button>
                    </div>
                </div>


            </div>
        </div>
    </section>
    {include file="agenda/referencia_estado_turnos.tpl"}
    <!-- Modal turno agendado -->
    {*informacion del paciente seleccionado para el turno en el modal de confirmacion-> se inicializan los campos una vez realizada la confirmacion con exito*}
    <div id="turno-agendado-mdl" class="modal fade modal-turno-agendado" tabindex="-1" role="dialog" aria-labelledby="mySmallModalLabel">
        <div class="modal-dialog modal-sm modal-action-bool-sm">


            <div class="modal-content">

                <h3>{"¡Turno agendado!"|x_translate}</h3>
                <p>{"Se le ha enviado una notificación al paciente"|x_translate}</p>
                <div class="modal-turno-agendado-data">
                    <span><i class="icon-doctorplus-envelope"></i><span id="turno-agendado-mdl-email"></span></span>
                    <span><i class="icon-doctorplus-cel"></i><span id="turno-agendado-mdl-cel"></span></span>
                </div>
                <div class="modal-action-holder">
                    <a href="javascript:;" onclick="window.history.back();" class="modal-action-close" data-dismiss="modal" aria-label="Close">{"cerrar"|x_translate}</a>
                </div>
            </div>

        </div>
    </div>


    <!-- Modal Pacientes busqueda resultado -->
    <div class="modal fade modal-type-2 modal-listado-pacientes" id="resultados-busqueda-paciente">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <div class="modal-title"><h5>{"Resultados de búsqueda"|x_translate}</h5></div>
                    <span class="close-btn" data-dismiss="modal" aria-label="Close"><i class="fui-cross"></i></span>
                </div>
                <div class="modal-body">
                    <div class="form-content" id="div_modulo_resultado_busqueda">
                        {*cargar modulo con resultado de pacientes*}
                        {*agenda_tomar_turno_modulo_pacientes*}
                    </div>
                </div>
            </div>
        </div>
    </div>	

    {literal}
        <script>




            var validar_datos_paciente = function () {
                //validamos datos ingresados

                //verificar nombre
                if ($("#nombre").val() == "") {
                    $("#nombre").data("title", x_translate("Ingrese su nombre")).tooltip("show");
                    $('html, body').animate({
                        scrollTop: $("#nombre").offset().top - 200}, 1000);
                    return false;
                }

                //verificar apellido
                if ($("#apellido").val() == "") {
                    $("#apellido").data("title", x_translate("Ingrese su apellido")).tooltip("show");
                    $('html, body').animate({
                        scrollTop: $("#apellido").offset().top - 200}, 1000);
                    return false;
                }



                /*
                 if ($("#DNI").val() == "") {
                 $("#DNI").data("title", x_translate("Ingrese DNI")).tooltip("show");
                 $('html, body').animate({
                 scrollTop: $("#DNI").offset().top - 200}, 1000);
                 return false;
                 }
                 
                 if ($("#fechaNacimiento").val() == "") {
                 $("#fechaNacimiento").data("title", x_translate("Ingrese su fecha de nacimiento")).tooltip("show");
                 $('html, body').animate({
                 scrollTop: $("#fechaNacimiento").offset().top - 200}, 1000);
                 return false;
                 } else {
                 
                 //validacion edad titular
                 
                 //validar fecha futura
                 var time_actual = new Date().getTime();
                 var arr_split = $("#fechaNacimiento").val().split("/");
                 var fecha_nac = new Date(parseInt(arr_split[2]), parseInt(arr_split[1] - 1), parseInt(arr_split[0]));
                 if (fecha_nac > time_actual) {
                 $("#fechaNacimiento").data("title", x_translate("La fecha de nacimiento no puede ser futura")).tooltip("show");
                 return false;
                 }
                 //validar mayor de edad
                 var fecha_actual = new Date();
                 var time_mayor_edad = fecha_actual.setFullYear(fecha_nac.getFullYear() + 18);
                 
                 if (time_mayor_edad > time_actual) {
                 
                 $("#ag-paciente-menor").slideDown();
                 
                 if (!validar_datos_titular()) {
                 return false;
                 }
                 } else {
                 $("#ag-paciente-menor").slideUp();
                 }
                 
                 
                 }
                 */
                //validacion formato mail

                if (!validarEmail($("#email").val())) {
                    $("#email").data("title", x_translate("Ingrese un email válido")).tooltip("show");
                    $('html, body').animate({
                        scrollTop: $("#email").offset().top - 200}, 1000);
                    return false;
                }
                /*
                 //si hay telefono verifico la longitud
                 if ($("#numeroCelular").val() != "" && ($("#numeroCelular").val().length != 10 || (/[a-z-A-Z]/.test($("#numeroCelular").val())))) {
                 $("#numeroCelular").data("title", x_translate("Ingrese  un número de celular válido")).tooltip("show");
                 return false;
                 }
                 */
                return true;


            };

            $(function () {
                //inicializar input celular
                $("#numeroCelular").intlTelInput({
                    nationalMode: false,
                    preferredCountries: ['fr', 'be', 'lu'],
                    utilsScript: BASE_PATH + "xframework/core/libs/libs_js/intl-tel-input/build/js/utils.js"
                });
                $("#numeroCelular").mask("+0000000000000");
                $("#numeroCelular").on("keyup", function () {
                    if ($(this).val().substring(0, 1) != "+") {
                        $(this).val("+" + $(this).val());
                    }
                });


                $('.switch-checkbox').bootstrapSwitch();


                /**Boton buscar por DNI-.Nombre, abre modal con resultado de las busquedas cargando otro modulo**/
                $('#resultados-busqueda-trg').on('click', function (e) {


                    if ($("#query_str").val() == "") {
                        x_alert(x_translate("Ingrese un nombre/DNI para la busqueda"));
                        return false;
                    }
                    //limpiamos la el modulo de busquedas anteriores
                    $("#div_modulo_resultado_busqueda ul").empty();

                    //cargamos los resultados
                    x_loadModule("agenda", "agenda_tomar_turno_modulo_pacientes", "query_str=" + $("#query_str").val(), "div_modulo_resultado_busqueda");
                    //spin y desplegamos el modal
                    $("#div_modulo_resultado_busqueda").spin("large");
                    $('#resultados-busqueda-paciente').modal('show');
                });

                /**Boton buscar por DNI-.Nombre al presionar enter, abre modal con resultado de las busquedas cargando otro modulo**/
                $("#query_str").keypress(function (e) {
                    if (e.which == 13) {

                        if ($("#query_str").val() == "") {
                            x_alert(x_translate("Ingrese un nombre/DNI para la busqueda"));
                            return false;
                        }
                        //limpiamos la el modulo de busquedas anteriores
                        $("#div_modulo_resultado_busqueda ul").empty();

                        //cargamos los resultados
                        x_loadModule("agenda", "agenda_tomar_turno_modulo_pacientes", "query_str=" + $("#query_str").val(), "div_modulo_resultado_busqueda");
                        //spin y desplegamos el modal
                        $("#div_modulo_resultado_busqueda").spin("large");
                        $('#resultados-busqueda-paciente').modal('show');
                    }
                });

                /**Boton para agregar un nuevo paciente al sistema**/
                $('#ag-paciente-nuevo-trg').on('click', function (e) {
                    e.preventDefault();
                    //despliega formulario de alta
                    if ($('#ag-paciente-detalle').is(':visible')) {
                        $('#ag-paciente-detalle').slideUp();
                    }
                    $('#ag-paciente-nuevo').slideToggle();
                    scrollToEl($('#ag-paciente-nuevo'));
                });

                /**Cancelar turno->vuelve a cargar la pagina previa correspondiente a la agenda**/
                $("#btn_cancelar").click(function () {
                    window.history.back();
                });


                /*Boton confirmar turno*/
                $('#btnConfirmarTurno').on('click', function (e) {
                    e.preventDefault();
                    //validamos el motivo seleccionado
                    if ($("#motivo-consulta1").val() == "") {
                        x_alert(x_translate("Seleccione el motivo de la consulta"));
                        return false;
                    }
                    var idpaciente = $(this).data("idpaciente");
                    var idmotivoVisita = $("#motivo-consulta1").val();
                    var idturno = $("#idturno").val();
                    if (parseInt(idturno) > 0 && parseInt(idpaciente) > 0 && parseInt(idmotivoVisita) > 0) {

                        $("body").spin("large");
                        x_doAjaxCall(
                                'POST',
                                BASE_PATH + 'reservar_turno_medico.do',
                                'idturno=' + idturno + '&idpaciente=' + idpaciente + '&idmotivoVisita=' + idmotivoVisita,
                                function (data) {
                                    $("body").spin(false);
                                    if (data.result) {
                                        //seteamos los datos del paciente en el modal de confirmacion
                                        $("#turno-agendado-mdl-email").html("");
                                        $("#turno-agendado-mdl-cel").html("");
                                        $("#turno-agendado-mdl-email").html(data.email);
                                        if (data.numeroCelular == "") {
                                            $("#turno-agendado-mdl-cel").parent().hide();
                                        } else {
                                            $("#turno-agendado-mdl-cel").html(data.numeroCelular);
                                        }
                                        $('#turno-agendado-mdl').modal('show');
                                    } else {
                                        x_alert(data.msg);
                                    }
                                });
                    }


                });


                /*Evento al hacer click sobre un paciente del resultado de la busqueda->se selecciona el paciente del turno*/
                $('#div_modulo_resultado_busqueda').on('click', '.modal-paciente-trg', function (e) {

                    e.preventDefault();

                    //incializamos los datos del paciente seleccionado para el detalle del turno seleccionado
                    $("#paciente_turno_imagen").attr("src", $(this).find(".modal-resultados-imagen").attr("src"));
                    $("#paciente_turno_imagen").attr("alt", $(this).find(".modal-resultados-imagen").attr("alt"));
                    $("#paciente_turno_nombre").html($(this).find(".modal-resultados-nombre").html());
                    $("#paciente_turno_fecha_nacimiento").html($(this).find(".modal-resultados-fn").html());
                    var sexo = $(this).find(".modal-resultados-nombre").data("sexo");
                    if (sexo == 1) {
                        $("#paciente_turno_fecha_nacimiento").parent().find("i.sexo-femenino").hide();
                        $("#paciente_turno_fecha_nacimiento").parent().find("i.sexo-masculino").show();
                    } else {
                        $("#paciente_turno_fecha_nacimiento").parent().find("i.sexo-masculino").hide();
                        $("#paciente_turno_fecha_nacimiento").parent().find("i.sexo-femenino").show();
                    }

                    var idpaciente = $(this).find(".modal-resultados-nombre").data("idpaciente");
                    $("#btnConfirmarTurno").data("idpaciente", idpaciente);

                    //desplegamos el detalle de turno
                    if ($('#ag-paciente-nuevo').is(':visible')) {
                        $('#ag-paciente-nuevo').slideUp();
                    }
                    $('#resultados-busqueda-paciente').modal('hide');
                    $('#ag-paciente-detalle').slideDown(
                            scrollToEl($('#ag-paciente-detalle'))
                            );

                });

                /**
                 * APARTADO ALTA PACIENTE
                 * 
                 **/



                //inicializar datepicher fecha nacimiento
                $("#datetimepicker1")
                        .datetimepicker({
                            pickTime: false,
                            language: 'fr'
                        });
                $("#datetimepicker2")
                        .datetimepicker({
                            pickTime: false,
                            language: 'fr'
                        });

                //mascaras
                //$("#numeroCelular").inputmask("9999999999");
                $("#DNI,#titular_DNI").inputmask("99999999");
                $("#fechaNacimiento").inputmask("d/m/y");
                $("#titular_fechaNacimiento").inputmask("d/m/y");

                //validacion edad titular
                $("#fechaNacimiento").blur(function () {
                    //validar fecha futura
                    var time_actual = new Date().getTime();
                    var arr_split = $("#fechaNacimiento").val().split("/");
                    var fecha_nac = new Date(parseInt(arr_split[2]), parseInt(arr_split[1] - 1), parseInt(arr_split[0]));
                    if (fecha_nac > time_actual) {
                        $("#fechaNacimiento").data("title", x_translate("La fecha de nacimiento no puede ser futura")).tooltip("show");
                    }
                    //validar mayor de edad
                    var fecha_actual = new Date();
                    var time_mayor_edad = fecha_actual.setFullYear(fecha_nac.getFullYear() + 18);

                    if (time_mayor_edad > time_actual) {
                        $("#ag-paciente-menor").slideDown();
                        $("#info_tituar_container").hide();
                        $(".col-ag-nuevo-paciente-form-actions").hide();

                    } else {
                        $("#ag-paciente-menor").slideUp();
                        $("#info_tituar_container").show();
                        $(".col-ag-nuevo-paciente-form-actions").show();
                    }
                });
                //validacion formato mail
                $("#email").blur(function () {
                    if (!validarEmail($("#email").val())) {
                        $("#email").data("title", x_translate("Ingrese un email válido")).tooltip("show");
                        $('html, body').animate({
                            scrollTop: $("#email").offset().top - 200}, 1000);
                        return false;
                    }
                });
                //boton confirmar turno y crear paciente nuevo
                $("#btnConfirmarTurnoPacienteNuevo").click(function () {
                    if (validar_datos_paciente()) {
                        if ($("#motivo-consulta2").val() == "") {
                            x_alert(x_translate("Seleccione el motivo de la consulta"));
                            return false;
                        }
                        $("body").spin("large");

                        //enviamos el formulario para crear el paciente
                        x_sendForm($('#f_nuevo_paciente'), true, function (data) {
                            $("body").spin(false);

                            if (data.result) {
                                //seteamos los datos del paciente en el modal de confirmacion
                                $("#turno-agendado-mdl-email").html("");
                                $("#turno-agendado-mdl-cel").html("");
                                $("#turno-agendado-mdl-email").html(data.email);
                                if (data.numeroCelular == "") {
                                    $("#turno-agendado-mdl-cel").parent().hide();
                                } else {
                                    $("#turno-agendado-mdl-cel").html(data.numeroCelular);
                                }

                                $('#turno-agendado-mdl').modal('show');
                            } else {
                                x_alert(data.msg);
                            }

                        });
                    }



                });


            });
        </script>
    {/literal}

{/if}
