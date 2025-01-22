
<section class="container cs-nc-p2 cs-nc-profesionales-en-la-red">
    <div class="cs-nc-p2-header">
        <figure>
            <i class="icon-doctorplus-user-add-like"></i>
        </figure>
        <h2>{"Profesional en particular"|x_translate}</h2>
    </div>
    <div class="cs-nc-p2-inner">
        <div class="container-fluid">
            <form name="f_busqueda" id="f_busqueda" action="{$url}busqueda_profesionales_red.do" method="POST" role="form" >
                <input type="hidden" id="idconsultaExpress_f" name="idconsultaExpress" value="{$smarty.request.idconsultaExpress}">
                <input type="hidden" id="idlocalidad_f" name="localidad_idlocalidad" value="">
                <input type="hidden" id="ididioma_f" name="idioma_ididioma" value="">
                <input type="hidden" id="idpais_f" name="pais_idpais" value="1">
                <input type="hidden" id="idsector_f" name="sector_idsector" value="">
                {if $login_prestador!=1}
                    <input type="hidden" id="rango_maximo" name="rango_maximo" value="{$PRECIO_MAXIMO_CE}">
                    <input type="hidden" id="rango_minimo" name="rango_minimo" value="{$PRECIO_MINIMO_CE}">
                    <input type="hidden" id="idobraSocial_f" name="obraSocial_idobraSocial" value="">
                {/if}
                <input type="hidden" id="valoracion" name="valoracion" value="">


                <div class="row cs-nc-p2-row-divider">
                    <div class="col-sm-2">
                        <label>{"Profesional"|x_translate}</label>
                    </div>
                    {*<div class="col-sm-5">

                    <div class="cs-nc-p2-input-holder cs-nc-p2-input-text-holder required">
                    <input type="text" id="as_especialidades" placeholder="Especialidad"/>

                    </div>
                    </div>*}
                    <div class="col-sm-5">
                        <div class="cs-nc-p2-input-holder">
                            <select id="especialidad_idespecialidad" name="especialidad_idespecialidad" class="form-control select select-primary select-block mbl">
                                <option value="">{"Especialidad"|x_translate}</option>
                                {html_options options=$combo_especialidades }
                            </select>
                        </div>
                    </div>

                </div>
                <!-- Contenedor donde se carga el slider de seleccion de rango de precios-->
                <div id="container_rango_precios"></div>

            </form>
            <div class="cs-range-mas-filtros-trigger-holder">
                {*<button class="cs-range-mas-filtros-trigger">{"Más filtros"|x_translate}</button>*}
                <div class="cs-nc-listado-p2-siguiente pull-right">
                    <a id="btnContinuar" class="cs-nc-p2-btn-siguiente" href="javascript:void(0)" style="margin-top:0px">{"buscar"|x_translate} <span></span></a>
                    <a id="btn-delete-consulta" class="btn-cancel" href="javascript:;" style="margin-top:0px"><i class="icon-doctorplus-cruz"></i> {"cancelar consulta"|x_translate}</a>
                </div>
            </div>
            <input type="hidden" id="idpais" name="idpais" value="1">
            {*
            <div class="cs-range-mas-filtros">	
            <div class="row cs-nc-p2-row-divider">

            <div class="col-sm-2">
            <label>{"Ubicación"|x_translate}</label>
            </div>
            <div class="col-sm-4">

            <div class="cs-nc-p2-input-holder">
            <div class="cs-nc-p2-input-holder">
            <select id="idpais" name="idpais" class="form-control select select-primary select-block mbl">
            {if $paciente.pais_idpais==1 && $paciente.pais_idpais_trabajo!=2}
            <option value="1">France</option>
            {else}
            <option value="1">France</option>
            <option value="2" {if $paciente.pais_idpais==2}selected{/if} >Luxembourg</option>
            {/if}
            </select>
            </div>
            </div>
            </div>
            <div class="col-sm-4">
            <div class="cs-nc-p2-input-holder">
            <input type="hidden" id="idlocalidad" value=""> 
            <input type="text" id="as_localidad" placeholder='{"Ciudad"|x_translate}'/>
            </div>
            </div>

            </div>

            <div class="row cs-nc-p2-row-divider">
            {if $paciente.pais_idpais==1}
            <div class="col-sm-2">
            <label>{"Sector"|x_translate}</label>
            </div>
            <div class="col-sm-4">

            <div class="cs-nc-p2-input-holder">
            <div class="cs-nc-p2-input-holder">
            <select id="sector_idsector" name="sector_idsector" class="form-control select select-primary select-block mbl">
            <option value="">{"Sector"|x_translate}</option>
            {html_options options=$combo_sector}
            </select>
            </div>
            </div>
            </div>
            {/if}
            <div class="col-sm-6">
            <div class="row cs-nc-p2-row-action">
            <div class="cs-nc-p2-row-action-btns">
            <button id="btnCancelarFiltro" class="cs-nc-p2-cancel">{"Cancelar"|x_translate}</button>
            <button id="btnAplicarFiltro" class="cs-nc-p2-submit">{"Aplicar filtros"|x_translate}</button>
            </div>
            </div>


            </div>

            </div>
            </div>	
            *}
        </div>

    </div>
    {*<div class="row">
    <div class="cs-nc-p2-campos-obligatorios-msg"><span>*</span> {"Campos obligatorios"|x_translate}</div>
    </div>*}

</section>
<!-- Modal no hay profesionales -->
<div id="modal-no-profesionales" class="modal fade modal-profesionales" tabindex="-1" role="dialog" aria-labelledby="mySmallModalLabel">
    <div class="modal-dialog modal-sm modal-consulta-sm">


        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
            </div>
            <p>{"No hay profesionales para asignar la consulta"|x_translate}</p>

        </div>
    </div>
</div>
{if $login_prestador!=1}
    {literal}
        <script>
            $(function () {
                //cargamos el modulo de rango de precios por defecto
                $("#idpais_f").val($("#idpais").val());
                x_loadModule('consultaexpress', 'rango_precios_profesionales_red', '', 'container_rango_precios', BASE_PATH + "paciente_p");

                //recargamos el modulo de rango de precios por defecto cuando cambian los filtros
                $("#especialidad_idespecialidad").change(function () {
                    $("#idpais_f").val($("#idpais").val());
                    x_loadModule('consultaexpress', 'rango_precios_profesionales_red', $("#f_busqueda").serialize(), 'container_rango_precios', BASE_PATH + "paciente_p");


                });
            })
        </script>
    {/literal}
{/if}
{literal}
    <script>

        $(function () {


            renderUI2("consulta-express-step-container");
            $("#idpais_f").val($("#idpais").val());

            //limpiamos los filtros anteriores guardados
            x_doAjaxCall(
                    'POST',
                    BASE_PATH + 'delete_filtros_busqueda.do',
                    "idconsultaExpress=" + $("#idconsultaExpress").val(),
                    function (data) {
                        if (data.result) {

                        } else {
                            x_alert(data.msg);
                        }
                    }
            );



            if ($('.cs-range-mas-filtros').length > 0) {
                fflag = true;
                $('.cs-range-mas-filtros-trigger').on('click', function (e) {
                    e.preventDefault();
                    if (fflag) {
                        $('.cs-range-mas-filtros').stop().slideDown();
                        $(this).html(x_translate('Menos filtros'));
                        fflag = false;
                    } else if (!fflag) {
                        $('.cs-range-mas-filtros').stop().slideUp();
                        $(this).html(x_translate('Más filtros'));
                        fflag = true;
                    }
                });


            }


            //autosuggest de localidad
            $('#as_localidad').autocomplete({
                zIndex: 10000,
                serviceUrl: BASE_PATH + 'paciente_p.php?action=1&modulo=consultaexpress&submodulo=localidad_autosuggest&idpais=' + $("#idpais").val(),
                onSelect: function (data) {

                    $("#idlocalidad").val(data.data).change();

                }
            }).on('keyup, blur', function () {
                var that = this;
                if (this.value == "") {
                    $("#idlocalidad_f").val("").change();
                }
            });

            //actualizamos el autosuggest seleccionando una pais
            $("#idpais").change(function () {

                $("#idlocalidad, #as_localidad").val("");
                $('#as_localidad').autocomplete('clear');
                $('#as_localidad').autocomplete('setOptions', {serviceUrl: BASE_PATH + 'paciente_p.php?action=1&modulo=consultaexpress&submodulo=localidad_autosuggest&pais_idpais=' + this.value});
            });


            //autosuggest de obra social
            $('#as_obrasocial').autocomplete({
                zIndex: 10000,
                serviceUrl: BASE_PATH + 'paciente_p.php?action=1&modulo=consultaexpress&submodulo=obrasocial_autosuggest',
                onSelect: function (data) {

                    $("#idobraSocial_f").val(data.data).change();

                }
            }).on('keyup, blur', function () {
                var that = this;
                if (this.value == "") {
                    $("#idobraSocial_f").val("").change();
                }
            });



            //seleccion de valoracion del medico

            $(".ce-nc-valoracion input:checkbox").on('change.radiocheck', function () {
                var ids = "";
                $(".ce-nc-valoracion input:checkbox:checked").each(function () {
                    ids += ',' + $(this).val();
                });
                if (ids.length > 0) {
                    ids = ids.substring(1);
                }
                $("#valoracion").val(ids);

            });



            //botones aplicar o cancelar filtros - limpiar o setear inputs ocultos en form

            $("#btnAplicarFiltro").click(function () {
                $("#idlocalidad_f").val($("#idlocalidad").val());
                $("#idpais_f").val($("#idpais").val());
                $("#ididioma_f").val($("#ididioma").val());
                $("#valoracion_f").val($("#valoracion").val());
                $("#idsector_f").val($("#sector_idsector").val());

                x_loadModule('consultaexpress', 'rango_precios_profesionales_red', $("#f_busqueda").serialize(), 'container_rango_precios', BASE_PATH + "paciente_p");

            });

            $("#btnCancelarFiltro").click(function () {

                $('.cs-range-mas-filtros').stop().slideUp();
                $('.cs-range-mas-filtros-trigger').html(x_translate('Más filtros'));
                $("#as_localidad").val("");
                $("#idpais").val("");
                $("#idlocalidad").val("");
                $("#ididioma").val("");
                $("#valoracion_f").val("");

            });


            //busqueda de medicos en la red
            //busqueda de medicos en la red
            $("#btnContinuar").click(function () {
                if ($("#especialidad_idespecialidad").val() == "") {
                    x_alert(x_translate("Seleccione al menos una especialidad"));
                    return false;
                }
                $("#idpais_f").val($("#idpais").val());
                x_doAjaxCall(
                        'POST',
                        BASE_PATH + "save_filtros_busqueda.do",
                        $("#f_busqueda").serialize(),
                        function (data) {
                            if (data.result) {

                                x_loadModule('consultaexpress', 'nuevaconsulta_step2_profesional_frecuente_resultados', "idconsultaExpress=" + $("#idconsultaExpress_f").val() + "&do_reset=1", "consulta-express-step-container", BASE_PATH + "paciente_p");



                            } else {
                                if (data.no_profesionales == "1") {
                                    $('#modal-no-profesionales').modal('show');
                                } else {
                                    x_alert(data.msg);
                                }

                            }
                        }
                );
            });



        });
    </script>
{/literal}

