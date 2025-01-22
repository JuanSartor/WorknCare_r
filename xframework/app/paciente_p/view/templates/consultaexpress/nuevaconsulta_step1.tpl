<section id="div_seleccion_tipo"  class="container ce-nc-consulta">
    <div class="ce-nc-consulta-medico">
        <h3>{"¿a quién está dirigida la consulta?"|x_translate}</h3>
        <div class="ce-nc-consulta-title-divider">
            <span></span>
        </div>
        <div class="col-xs-6">
            <div class="row check-tipo-consulta">
                <div class="cs-nc-p2-header">
                    <figure>
                        <label class="checkbox">
                            <input type="radio" id="btnSelectProfesionalFrecuente" checked name="tipo_consulta" value="1"   data-toggle="radio" class="custom-checkbox">
                        </label>
                        <i class="icon-doctorplus-user-add-like"></i>
                    </figure>
                    <h2>{"Profesional en particular"|x_translate}</h2>

                </div>

            </div>
        </div>
        <div class="col-xs-6">
            <div class="row check-tipo-consulta" >
                <div class="cs-nc-p2-header">
                    <figure>
                        <label class="checkbox">
                            <input type="radio" id="btnSelectProfesionalRed" name="tipo_consulta" value="0"   data-toggle="radio" class="custom-checkbox">
                        </label>
                        <i class="icon-doctorplus-people-add"></i>
                    </figure>
                    <h2>{"Profesionales en la Red"|x_translate}</h2>
                </div>

            </div>
        </div>
    </div>

</div>

</section>
<section class="container cs-nc-p2 cs-nc-profesionales-en-la-red">

    <div class="cs-nc-p2-inner">

        <form name="f_busqueda" id="f_busqueda"  method="POST" role="form" >
            <input type="hidden" id="tipo_consulta" name="tipo_consulta" value="">
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


                <div class="col-md-6 col-xs-12" id="programa_categoria_container">
                    <div class="cs-nc-p2-input-holder">
                        <label>{"Programas de salud"|x_translate}</label>
                        <input type="hidden" id="idprograma_categoria" name="idprograma_categoria" value="">
                        <input type="hidden" id="idprograma_salud" name="idprograma_salud" value="">
                        <div class="dropdown dropdown-programas-container select2-container form-control select select-primary select-block mbl">
                            <a class="select2-choice" type="button" id="dropdownMenu1" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true">
                                <span class="label-default"> {"Seleccione un programa de salud"|x_translate}</span>
                                <span class="item-seleccionado" style="display: none;"></span>
                                <span class="select2-arrow" role="presentation"><b role="presentation"></b></span>
                            </a>
                            <ul class="select2-results dropdown-menu dropdown-programas" aria-labelledby="dropdownMenu1">
                                {foreach from=$combo_programas item=programa}
                                    {if $programa.propio == 0}
                                        <li>
                                            <a href="javascript:;" class="select-programa" data-idprograma="{$programa.idprograma_salud}">
                                                <i class="fa fa-chevron-right"></i> 
                                                <strong class="nombre-programa" data-idprograma="{$programa.idprograma_salud}">{$programa.programa_salud}:</strong>
                                                <span class="tag-container" >
                                                    <div class="programa-destacado-tag" data-id="{$programa.idprograma_salud}">
                                                        <span class="content">
                                                            {"Gratuita"|x_translate}
                                                        </span>
                                                    </div>
                                                </span>
                                            </a>
                                            <ul class="dropdown-submenu">
                                                {foreach from=$programa.programa_categoria item=categoria}
                                                    <li class="select-categoria" data-idprograma="{$programa.idprograma_salud}" data-idcategoria="{$categoria.idprograma_categoria}" >
                                                        - <span class="nombre-categoria" data-idcategoria="{$categoria.idprograma_categoria}">&nbsp;{$categoria.programa_categoria}</span>
                                                    </li>
                                                {/foreach}
                                            </ul>
                                        </li>
                                    {/if}
                                {/foreach}
                            </ul>
                        </div>
                    </div>
                </div>
            </div>


            <!-- Contenedor donde se carga el slider de seleccion de rango de precios-->
            {if $paciente.is_paciente_empresa!="1" || $paciente.ce_disponibles==0}
                <div id="container_rango_precios">
                    {include file="consultaexpress/rango_precios_profesionales_red.tpl"}
                </div>
            {/if}

        </form>
        <div class="cs-range-mas-filtros-trigger-holder">
            {*<button class="cs-range-mas-filtros-trigger">{"Más filtros"|x_translate}</button>*}
            <div class="cs-nc-listado-p2-siguiente pull-right">
                <a id="btnContinuar" class="cs-nc-p2-btn-siguiente" href="javascript:void(0)" style="margin-top:0px">{"buscar"|x_translate} <span></span></a>
                <a id="btn-delete-consulta" class="btn-cancel" href="javascript:;" style="margin-top:0px"><i class="icon-doctorplus-cruz"></i> {"cancelar consulta"|x_translate}</a>
            </div>
        </div>
        <input type="hidden" id="idpais" name="idpais" value="1">

    </div>

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
<script>
    var ids_excepciones_programa = "{$ids_excepciones_programa}";
</script>
{literal}
    <script>
        $(function () {
            //ir arriba
            if (getViewportWidth() < 600) {
                $('html, body').animate({
                    scrollTop: $("#consulta-express-step-container").offset().top - 50}, 1000);
            } else {
                $('html, body').animate({
                    scrollTop: $("#Main")}, 1000);
            }

            renderUI2("consulta-express-step-container");
            $("#idpais_f").val($("#idpais").val());

            //desmarcamos los programas que no son ofrecidos por la empresa
            if (ids_excepciones_programa !== "") {

                if (ids_excepciones_programa !== "ALL") {
                    ids_excepciones_programa.split(',').forEach(function (id) {
                        $(".programa-destacado-tag[data-id=" + id + "]").addClass("hide");
                    });
                    $(".programa-destacado-tag:not(.hide)").show();
                } else {
                    $(".programa-destacado-tag").show();
                }
            }
            //marcamos el programa o categoria seleccionado
            $(".select-programa").click(function (e) {
                e.preventDefault();
                e.stopPropagation();
                let idprograma = $(this).data("idprograma");
                $(".select-programa").not("[data-idprograma=" + idprograma + "]").removeClass("open");
                $(this).toggleClass("open");
            });
            //marcamos el programa o categoria seleccionado
            $(".select-categoria").click(function (e) {
                e.preventDefault();

                $(".item-seleccionado").html("");
                $("#idprograma_categoria").val("");
                $("#idprograma_salud").val("");
                if ($(this).data("idprograma") != "") {
                    let idprograma = $(this).data("idprograma");
                    $(".item-seleccionado").append($(".nombre-programa[data-idprograma=" + idprograma + "]").clone());
                    $("#idprograma_salud").val(idprograma);
                }
                if ($(this).data("idcategoria") != "") {
                    let idcategoria = $(this).data("idcategoria");
                    $(".item-seleccionado").append($(".nombre-categoria[data-idcategoria=" + idcategoria + "]").clone());
                    $("#idprograma_categoria").val(idcategoria);
                }

                $(".label-default").hide();
                $(".item-seleccionado").show();
            });

            //recargamos el modulo de rango de precios por defecto cuando cambian los filtros - si no tiene consultas libres disponibles
            if ($("#container_rango_precios").length > 0) {
                $(".select-categoria").click(function () {

                    $("#idpais_f").val($("#idpais").val());
                    $("body").spin();
                    x_loadModule('consultaexpress', 'rango_precios_profesionales_red', $("#f_busqueda").serialize(), 'container_rango_precios', BASE_PATH + "paciente_p").then(function () {
                        $("body").spin(false);
                    });
                });
            }


            //listener check
            $(".check-tipo-consulta").click(function () {
                $(this).find(":radio").radiocheck("check");
                /*        
                 $("#idprograma_categoria").val("");
                 $("#idprograma_salud").val("");
                 $(".item-seleccionado").hide();
                 $(".label-default").show();
                 
                 //mostrar/ocultar select de programas
                 var tipo_consulta = $("#btnSelectProfesionalFrecuente").is(":checked") ? 1 : 0;
                 console.log("tipo:" + tipo_consulta);
                 */
            });

            //busqueda de medicos 
            $("#btnContinuar").click(function () {

                if (!$("#btnSelectProfesionalFrecuente").is(":checked") && !$("#btnSelectProfesionalRed").is(":checked")) {
                    x_alert(x_translate("Seleccione a quien está dirigida la consulta"));
                    return false;
                }

                if ($("#idprograma_salud").val() === "" && $("#idprograma_categoria").val() === "") {
                    x_alert(x_translate("Seleccione un programa de salud"));
                    return false;
                }

                var tipo_consulta = $("#btnSelectProfesionalFrecuente").is(":checked") ? 1 : 0;
                $("#tipo_consulta").val(tipo_consulta);
                $("body").spin();
                x_doAjaxCall(
                        'POST',
                        BASE_PATH + 'nuevaconsulta_step1.do',
                        $("#f_busqueda").serialize(),
                        function (data) {
                            //seteamos el id luego de crear la consulta
                            $("#idconsultaExpress").val(data.id);
                            if (data.result) {
                                if (tipo_consulta == 1) {
                                    x_loadModule('consultaexpress', 'nuevaconsulta_step2_profesional_frecuente_resultados', "idconsultaExpress=" + data.id + "&do_reset=1", "consulta-express-step-container", BASE_PATH + "paciente_p").then(function () {
                                        $("body").spin(false);
                                    });
                                } else {
                                    x_loadModule('consultaexpress', 'nuevaconsulta_step3', 'idconsultaExpress=' + data.id, 'consulta-express-step-container', BASE_PATH + "paciente_p").then(function () {
                                        $("body").spin(false);
                                    });
                                }
                            } else {
                                $("body").spin(false);
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

