<style>
    #Main{
        background-color:#f7f7f7;
    }
    .modal-body.cropper-body img {
        max-width: 100%;
    }
    .mapc-select{
        margin-top: 0px;
    }
    /*header titulo*/
    .top-verde-centrado {
        min-height: 60px;

    }
    .top-verde-centrado h1 {
        font-size: 18px;
        line-height: 60px;
    }

    .top-verde-centrado h1>i {
        font-size: 24px;
        margin-right: 12px;
        top: 2px;
    }
</style>

<div class="top-verde-centrado">
    <h1><i class="fas fa-dog"></i> {"Editar mascota"|x_translate}</h1>
</div>
<input type="hidden" name="completer"  id="completer" value="{$completer}">

<form id="frm_Img" role="form" action="{$url}save_image_paciente.do" method="post" >
    <input type="hidden" name="idpaciente" value="{$paciente.idpaciente}" />
</form>

<section class="pul-datos-paciente">
    <form id="frmRegistro" role="form" method="post" action="{$url}cambiar-datos-paciente.do" onsubmit="return false;">
        {if $paciente.titular==1}
            <input type="hidden" id="usuarioweb_idusuarioweb" name="usuarioweb_idusuarioweb" value="{$paciente.usuarioweb_idusuarioweb}" />
        {/if}
        <input type="hidden" id="idpaciente" name="idpaciente" value="{$paciente.idpaciente}" />
        <input type="hidden" name="filter_selected" id="filter_selected" value="{$filter_selected}" />
        <input type="hidden" name="animal" value="1" />
        <div class="mapc-registro-box pul-nuevo-paciente-accordion">

            <div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">

                <div class="panel panel-default">
                    <div class="panel-heading" role="tab" id="headingOne">
                        <h4 class="panel-title">
                            <a role="button" id="accordion-trg-1" data-toggle="collapse" data-parent="#accordion" href="#collapseOne" aria-expanded="true" aria-controls="collapseOne">
                                {"Datos de la mascota"|x_translate}
                                <i class="more-less fa fa-chevron-down pull-right"></i>
                            </a>
                        </h4>
                    </div>

                    <div id="collapseOne" class="panel-collapse collapse in" role="tabpanel" aria-labelledby="headingOne">
                        <div class="panel-body">

                            <!-- foto de perfil-->
                            {include file="pacientes/foto_perfil.tpl"}

                            <div class="okm-row">
                                <div class="pul-col-x2">
                                    <div class="mapc-input-line">
                                        <label class="mapc-label">{"Nombre del animal"|x_translate}</label>
                                        <input type="text" id="nombre_animal_input" name="nombre" maxlength="15"  data-title='{"Ingrese nombre del animal"|x_translate}' value="{$paciente.nombre}"/>
                                    </div>
                                </div>
                                <div class="pul-col-x2">
                                    <div class="mapc-input-line">
                                        <label class="mapc-label">{"Tipo de animal"|x_translate}</label>
                                        <input type="text" name="tipo_animal" id="tipo_animal_input" maxlength="20" data-title='{"Ingrese tipo de animal"|x_translate}' value="{$paciente.tipo_animal}" />
                                    </div>
                                </div>
                            </div>

                            <div class="okm-row">
                                <div class="pul-col-x2">
                                    <label class="mapc-label">{"Fecha de nacimiento"|x_translate}</label>
                                    <div class="mapc-input-line">
                                        <div class="mapc-input-line">
                                            <input type="text" id="fecha_nacimiento"  name="fechaNacimiento" data-title='{"Ingrese fecha de nacimiento"|x_translate}' value="{$paciente.fechaNacimiento|date_format:'%d/%m/%Y'}"/>
                                            <i class="icon-doctorplus-calendar"></i>
                                        </div>
                                    </div>
                                </div>

                            </div>

                            <div class="okm-row" >
                                <div class="mapc-registro-form-row center">
                                    <a href="javascript:;"  class="btn-alert btnGuardarDatos">{"guardar"|x_translate}</a>
                                </div>
                            </div>

                        </div>
                    </div>
                </div>



            </div>

        </div>

    </form>
</section>
{literal}
    <script>
        $(function () {

            scrollToEl($("body"));

            /**
             * Validación formulario 
             */

            var validar_campos_requeridos_mascota = function () {

                //limpiar viejos tooltips
                $.each($("#frmRegistro input"), function (index, element) {
                    var $element = $(element);
                    $element.tooltip("destroy").removeClass("select-required");
                });

                $.each($("#frmRegistro select"), function (index, element) {
                    var $element = $(element);
                    $element.tooltip("destroy").removeClass("select-required");
                });

                /*Validaciones*/

                //validar nombre
                if ($("#nombre_input").val() == "") {
                    $("#nombre_input").tooltip("show").addClass("select-required");
                    if (!$('#collapseOne').is(":visible")) {
                        $('#collapseOne').collapse('show');
                    }
                    scrollToEl($("#nombre_input"));
                    return false;
                }

                //verificar apellido
                if ($("#tipo_animal_input").val() == "") {
                    $("#tipo_animal_input").tooltip("show").addClass("select-required");
                    if (!$('#collapseOne').is(":visible")) {
                        $('#collapseOne').collapse('show');
                    }
                    scrollToEl($("#apellido_input"));
                    return false;
                }


                //verificar fecha de nacimiento
                if ($("#fecha_nacimiento").val().length != 10 || (typeof (validatedate) == "function" && !validatedate($("#fecha_nacimiento").val()))) {
                    $("#fecha_nacimiento").data("title", x_translate("Ingrese su fecha de nacimiento")).tooltip("show").addClass("select-required");
                    if (!$('#collapseOne').is(":visible")) {
                        $('#collapseOne').collapse('show');
                    }
                    scrollToEl($("#fecha_nacimiento"));
                    return false;
                }



                //validar fecha futura
                var time_actual = new Date().getTime();
                var arr_split = $("#fecha_nacimiento").val().split("/");
                var fecha_nac = new Date(parseInt(arr_split[2]), parseInt(arr_split[1] - 1), parseInt(arr_split[0]));
                if (fecha_nac > time_actual) {
                    $("#fecha_nacimiento").data("title", x_translate("La fecha de nacimiento no puede ser futura")).tooltip("show").addClass("select-required");
                    if (!$('#collapseOne').is(":visible")) {
                        $('#collapseOne').collapse('show');
                    }
                    scrollToEl($("#fecha_nacimiento"));
                    return false;
                }


                return true;

            };

            function alert_resultado(data) {
                $.alert({

                    title: '',
                    scrollToPreviousElement: false,
                    scrollToPreviousElementAnimate: false,
                    content: x_translate(data.msg),
                    theme: 'material',
                    backgroundDismiss: true,
                    buttons: {

                    }
                });
                //scrollToEl($("body"));



            }
            //accion de validar y enviar el formulario con los datos de la mascota
            $(".btnGuardarDatos").click(function () {

                if (validar_campos_requeridos_mascota()) {
                    x_sendForm($('#frmRegistro'), true, alert_resultado);
                }


            });

            //alerta al querer redimensionar imagen de perfil - cropper no disponible
            $("#a_img_cropper").click(function () {
                x_alert(x_translate("ATENCIÓN: La imagen que usted ha subido se encuentra cargada en forma temporal. Las funciones de edición están deshabilitadas. Tras la creación del miembro de grupo familiar, usted podrá modificar, recortar y rotar la misma haciendo click sobre la imagen."));
            });

            //opciones date picker de fecha de nacimientos

            $('#fecha_nacimiento').mask("00/00/0000", {placeholder: "jj/mm/aaaa"});

            //accion completar campos y desplegar
            $('.panel-heading a').on('click', function (e) {
                $('.panel-heading a').not($(this)).find(".more-less").removeClass('fa-chevron-up').addClass('fa-chevron-down');
                $(this).find(".more-less").toggleClass('fa-chevron-down fa-chevron-up');

            });






        });
    </script>
{/literal}
