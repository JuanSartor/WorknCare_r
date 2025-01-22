<input type="hidden" id="direccion_old"  value="{$direccion.direccion}">
<input type="hidden" id="idlocalidad_old"  value="{$direccion.idlocalidad}">
<input type="hidden" id="numero_old"  value="{$direccion.numero}">


<link href="{$url}xframework/core/libs/libs_js/intl-tel-input/build/css/intlTelInput.css" rel="stylesheet" >

<div class="row">
    <div class="col-md-10 col-md-offset-1">
        <h4 class="mul-form-tittle">{"Dirección"|x_translate}</h4>
    </div>
</div>

<div class="dc-form-spacer">
    <form class="form" id="frmDireccionConsultorio" role="form" action="{$url}direccion-consultorio-medico.do" method="post" onsubmit="return false" >
        <input type="hidden" id="lat" name="lat" value="{$direccion.lat}">
        <input type="hidden" id="lng" name="lng" value="{$direccion.lng}">
        <input type="hidden" id="iddireccion" name="iddireccion" value="{$direccion.iddireccion}">
        <input type="hidden" id="cambio_direccion" name="cambio_direccion" value="">

        <div class="row">
            <div class="col-md-5 col-md-offset-1">

                <div class="row">
                    <div class="col-md-8 col-sm-12 col-xs-12 ">
                        <div class="field-edit dp-edit mul-border dc-no-label">
                            <input maxlength="50" placeholder='{"Calle"|x_translate}' type="text" id="direccion" name="direccion" value="{$direccion.direccion}">
                        </div>
                    </div>

                    <div class="col-md-4 col-sm-12 col-xs-12">
                        <div class="field-edit dp-edit mul-border dc-no-label">
                            <input maxlength="10" placeholder='{"Numero"|x_translate}' type="text" id="numero" name="numero" value="{$direccion.numero}">
                        </div>
                    </div>
                </div>
                <input type="hidden" name="pais_idpais" id="pais_idpais" value="{$medico.pais_idpais}" />

                {*<div class="row">
                <div class="col-md-12">	
                <div class="okm-select-plus-box mdc-style mul-select-spacer dc-no-label" >
                <div class="okm-select">
                <select name="pais_idpais" id="pais_idpais" class="form-control select select-primary select-block mbl" required data-title='{"Seleccione un país"|x_translate}'>
                <option value="">{"Seleccione País"|x_translate}</option>
                {html_options options=$combo_pais selected=$direccion.pais_idpais}
                </select>
                </div>
                </div>
                </div>
                </div>*}

                <div class="row">
                    <div class="col-md-12">
                        <div class="field-edit dp-edit mul-border dc-no-label">
                            <input type="hidden" name="localidad_idlocalidad" id="idlocalidad" value="{$direccion.idlocalidad}" />
                            <input type="text"  id="as_localidad" name="as_localidad" value="{$direccion.localidad}" placeholder='{"Buscar Ciudad"|x_translate}'>
                        </div>
                    </div>                        
                </div>
                <div class="row">
                    <div class="col-md-12">
                        <div class="field-edit dp-edit mul-border dc-no-label">
                            <input  type="text" value="{$direccion.cpa}" id="cpa" placeholder='{"CPA"|x_translate}'>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-12">
                        <div class="field-edit dp-edit mul-border dc-no-label">
                            <input  type="tel" value="{$direccion.telefono}" name="telefono" id="telefono_consultorio">
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-12">
                        <div class="">
                            <label class="checkbox ib" for="mostrar_direccion">
                                <input type="checkbox" id="mostrar_direccion" name="mostrar_direccion" {if $direccion.mostrar_direccion!="0"}checked{/if} data-toggle="checkbox" value="1" class="custom-checkbox">
                                {"Mostrar mi dirección a los pacientes"|x_translate}
                            </label>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-5">
                <div class="dc-form-spacer">
                    <div class="row">
                        <div class="col-md-12">
                            <div id="map_canvas_modal"  style=" height: 380px; width: 100%; margin:0px auto; border:0" allowfullscreen=""></div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-12">
                            <p class="cd-map-text">
                                {"Indique la dirección de su consultorio. Puede ayudarse del zoom. Haga click sobre la misma para establecer la marca. Marcar su consultorio en el mapa es importante para que operen el resto de las funcionalidades del sitio."|x_translate}
                            </p>
                        </div>
                    </div>	 
                </div>
            </div>
        </div>
    </form>

    <div class="row">
        <div class="col-md-10 col-md-offset-1">
            <div class="dc-horarios-add-action-box">

                <a href="javascript:;"  id="agregar-direccion-consultorio" class="btn-oil-large ">{"listo"|x_translate} <i class="icon-doctorplus-check-thin"></i></a>

            </div>
        </div>
    </div>

</div>
<!-- Modal cambio de domicilio consultorio -->
<div id="modal-cambio-domicilio-consultorio" class="modal fade bs-example-modal-lg vc-modal-interrupcion vc-refund-modal" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel">
    <div class="modal-dialog modal-lg" role="document">

        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">×</span></button>
                <figure class="modal-icon consultorios"><i class="icon-doctorplus-map-plus-rounded"></i></figure>
                <h4 class="modal-title modal-consulorios-disclaimer">
                    {"Le notificaremos a los pacientes con turnos confirmados el cambio de domicilio."|x_translate}
                </h4>
            </div>
            <div class="modal-body">
                <div class="modal-action-row">
                    <a href="javascript:;" class="btn-alert"  id="btnCancelarCambioDomicilio" data-dismiss="modal" aria-label="Close"><i class="icon-doctorplus-cruz"></i> {"cancelar"|x_translate}</a>
                    <a href="javascript:;" class="btn-default" id="btnAceptarCambioDomicilio"><i class="icon-doctorplus-check-thin"></i> {"aceptar"|x_translate}</a>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="{$url_js_libs}/intl-tel-input/build/js/intlTelInput.js">
</script>
<script src="{$url_js_libs}/intl-tel-input/build/js/utils.js">
</script>
<script src="{$url}xframework/core/libs/libs_js/jquery/gmap3/gmap3.min.js">
</script>
{literal}
    <script>
        $(function () {
            if ($("#pais_idpais").val() == 1) {
                var prefCountries = ['fr', 'be', 'lu'];

            } else {
                var prefCountries = ['lu', 'fr', 'be'];
            }
            $("#telefono_consultorio").intlTelInput({
                nationalMode: false,
                preferredCountries: prefCountries,
                utilsScript: BASE_PATH + "xframework/core/libs/libs_js/intl-tel-input/build/js/utils.js"
            });
            $("#telefono_consultorio").mask("+0000000000000");
            //agregamos el + al numero de telefono
            $("#telefono_consultorio").on("keyup", function () {
                if ($(this).val().substring(0, 1) != "+") {
                    $(this).val("+" + $(this).val());
                }
            });

            // Initializar autocomplete de localidades
            $('#as_localidad').autocomplete({
                zIndex: 10000,
                serviceUrl: BASE_PATH + 'medico.php?action=1&modulo=home&submodulo=localidad_autosuggest&pais_idpais=' + $("#pais_idpais").val(),
                onSelect: function (data) {

                    $("#idlocalidad").val(data.data);
                    $("#cpa").val(data.cpa);
                    getLocalization();
                }
            });
            //buscar posicion en Maps al cambiar direccion
            $('#as_localidad, #direccion, #numero').blur(function (event) {
                /* Act on the event */
                getLocalization();
            });

            $("#pais_idpais").change(function () {
                getLocalization();
                $("#idlocalidad, #as_localidad").val("");
                $('#as_localidad').autocomplete('clear');
                $('#as_localidad').autocomplete('setOptions', {serviceUrl: BASE_PATH + 'medico.php?action=1&modulo=home&submodulo=localidad_autosuggest&pais_idpais=' + this.value});
            });

            if ($("#lng").val() != "") {

                var lat = $("#lat").val();
                var lng = $("#lng").val();
            } else {

                var lat = -34.6083;
                var lng = -58.3712;
            }
            $("#map_canvas_modal").gmap3({
                map: {
                    options: {
                        center: [lat, lng],
                        zoom: 16
                    }
                },
                marker: {
                    values: [
                        {latLng: [lat, lng], tag: 'myMarker'}
                    ],
                    options: {
                        draggable: true
                    },
                    events: {
                        dragend: function (marker) {

                            var position = marker.getPosition();
                            $("#lat").val(position.lat());
                            $("#lng").val(position.lng());
                        }
                    },
                }
            });


            $("#agregar-direccion-consultorio").click(function () {
                //elimnamos los tooltips preexistentes
                $("#frmDireccionConsultorio :input").tooltip("destroy");
                $("#frmDireccionConsultorio select").tooltip("destroy");

                if ($("#direccion").val() == "") {
                    scrollToEl($("#direccion"));
                    $("#direccion").data("title", x_translate("Calle")).tooltip("show");
                    return false;
                }

                if ($("#numero").val() == "") {
                    scrollToEl($("#numero"));
                    $("#numero").data("title", x_translate("Número")).tooltip("show");
                    return false;
                }

                if ($("#idlocalidad").val() == "") {
                    scrollToEl($("#idlocalidad"));
                    $("#as_localidad").data("title", x_translate("Ingrese una localidad")).tooltip("show");
                    return false;
                }
                if ($("#cpa").val() == "") {
                    scrollToEl($("#cpa"));
                    $("#cpa").data("title", x_translate("Ingrese CPA")).tooltip("show");
                    return false;
                }



                if ($("#telefono_consultorio").val() === "") {

                    scrollToEl($("#telefono_consultorio"));
                    $("#telefono_consultorio").data("title", x_translate("Ingrese teléfono del consultorio válido")).tooltip("show");
                    return false;
                }

                if (validar_cambio_domicilio()) {
                    $("#modal-cambio-domicilio-consultorio").modal("show");
                } else {
                    x_sendForm($('#frmDireccionConsultorio'), true, alert_resultado_direccion);
                }
            });



            //confirmacion del modal de Cambio de domicilio del consultorio que notificara a los pacientes
            $("#btnAceptarCambioDomicilio").click(function () {
                $("#cambio_direccion").val(1);
                x_sendForm($('#frmDireccionConsultorio'), true, alert_resultado_direccion);
            });
            //si cancela el modal de cambio de domicilio, restauramos los valores anteriores
            $("#btnCancelarCambioDomicilio").click(function () {
                $("#direccion").val($("#direccion_old").val());
                $("#numero").val($("#numero_old").val());
                $("#idlocalidad").val($("#idlocalidad_old").val());
                renderUI2("div_consultorio");
            });
            //comprobamos si han cambiado los datos del domicilio para informar a los pacientes
            var validar_cambio_domicilio = function () {
                if ($("#iddireccion").val() != "" && ($("#direccion_old").val() != $("#direccion").val() ||
                        $("#numero_old").val() != $("#numero").val() ||
                        $("#idlocalidad_old").val() != $("#idlocalidad").val()
                        )) {
                    return true;
                } else {
                    return false;
                }
            };

            var alert_resultado_direccion = function (data) {

                if (data.result) {
                    $("#cambio_direccion").val(1);
                    $("#modal-cambio-domicilio-consultorio").modal("hide");

                    //actualizamos los datos de los formularios

                    $("#direccion_old").val($("#direccion").val());
                    $("#numero_old").val($("#numero").val());
                    $("#idlocalidad_old").val($("#idlocalidad").val());

                    //quitamos alerta en seccion consultorios

                    x_loadModule('usuario', 'menu_usuario', 'sm=datos_consultorios', 'div_menu_usuario', BASE_PATH + "medico");

                    $("#headingOne .alert-req-field").remove();
                    if ($("#div_datos_consultorios .alert-req-field").length == 0) {
                        $("a[data-src='#consultorios'] p.span_alert").remove();
                    }
                    //mostrar una alerta cuando esté todo completo
                    if (data.showModal) {

                        x_alert(x_translate("Se han completado sus datos profesionales minimos para poder operar en DoctorPlus"), function () {
                            recargar(BASE_PATH + "panel-medico/");
                        });
                    } else {
                        x_alert(data.msg, function () {
                            $("#headingOne a").trigger('click');//cerrar direccion  
                            $("#headingTwo a").trigger('click'); //abrir agenda consultorios
                        });

                    }
                } else {
                    x_alert(data.msg);
                }


            };
            var getLocalization = function () {
                if ($("#pais_idpais").val() == 1) {
                    var pais = "France";
                } else {
                    var pais = "Luxembourg";
                }

                var address = "";
                if (pais != "") {

                    address = pais
                    var ciudad = $("#as_localidad").val();
                    if (ciudad != "") {

                        address = ciudad + "," + address;
                        var direccion = $("#direccion").val();
                        if (direccion != "") {

                            var numero = $("#numero").val();
                            if (numero) {

                                direccion = direccion + " " + numero;
                            }

                            address = direccion + "," + address;
                        }
                    }
                    //eliminar el CP para mejorar la busqueda de gmap
                    address = address.replace(/\([0-9]+\)/g, "");
                    $("#map_canvas_modal").gmap3({
                        getlatlng: {
                            address: address,
                            callback: function (results) {

                                if (!results)
                                    return;
                                var map = $(this);
                                map.gmap3('get').panTo(results[0].geometry.location);
                                map.gmap3({
                                    get: {
                                        name: "marker",
                                        tag: "myMarker",
                                        callback: function (marker) {
                                            marker.setPosition(results[0].geometry.location);
                                            $("#lat").val(results[0].geometry.location.lat());
                                            $("#lng").val(results[0].geometry.location.lng());
                                        }
                                    }

                                });
                            }
                        }
                    });
                }

            }

            getLocalization();

        });

    </script>
{/literal}