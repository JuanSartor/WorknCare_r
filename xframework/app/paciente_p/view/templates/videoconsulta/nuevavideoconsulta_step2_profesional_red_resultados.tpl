<style>
    .ratting-like,.pbn-usr-like{
        margin-left:0px !important
    }
</style>
<div id="div_profesionales_red_list">
    <form name="f_busqueda" id="f_busqueda" action="{$url}busqueda_profesionales_red.do" method="POST" role="form" onsubmit="return false">
        <input type="hidden" id="idvideoconsulta_f" name="idvideoconsulta" value="{$smarty.request.idvideoconsulta}">
        <input type="hidden" id="especialidad_idespecialidad" name="especialidad_idespecialidad" value="{$smarty.request.especialidad_idespecialidad}">
        <input type="hidden" id="idlocalidad_f" name="localidad_idlocalidad" value="{$smarty.request.localidad_idlocalidad}">
        <input type="hidden" id="ididioma_f" name="idioma_ididioma" value="{$smarty.request.idioma_ididioma}">
        <input type="hidden" id="idpais_f" name="pais_idpais" value="{$smarty.request.pais_idpais}">
        <input type="hidden" id="rango_maximo" name="rango_maximo" value="{$smarty.request.rango_maximo}">
        <input type="hidden" id="rango_minimo" name="rango_minimo" value="{$smarty.request.rango_minimo}">
        <input type="hidden" id="valoracion_f" name="valoracion" value="{$smarty.request.valoracion}">
        <input type="hidden" id="order_f" name="order" value="">
        <input type="hidden" id="subEspecialidad_idsubEspecialidad_f" name="subEspecialidad_idsubEspecialidad" value="{$smarty.request.subEspecialidad_idsubEspecialidad}">
        <input type="hidden" id="idobraSocial_f" name="obraSocial_idobraSocial" value="{$smarty.request.obraSocial_idobraSocial}">
        <input type="hidden" id="idsector_f" name="sector_idsector" value="{$smarty.request.sector_idsector}">

    </form>
    <div class="cs-nc-section-holder">	
        <section class="container cs-nc-p2">
            <div class="cs-nc-p2-header">
                <figure>
                    <i class="icon-doctorplus-people-add"></i>
                </figure>
                <h2>{"Profesionales en la Red"|x_translate}</h2>
            </div>
            <div class="row">
                <div class="nc-ce-p2res-search-bar">
                    <div class="search-holder">
                        <button id="btn-nueva-busqueda">{"Nueva búsqueda"|x_translate} <i class="icon-doctorplus-search"></i></button>
                    </div>
                    {if $smarty.request.localidad_idlocalidad!=""}	<button  class="btn-remove-filtro" data-target="idlocalidad_f">{"Ubicación"|x_translate} <i class="icon-doctorplus-cruz"></i></button>{/if}
                    {if $smarty.request.idioma_ididioma!=""}	<button class="btn-remove-filtro" data-target="ididioma_f">{"Idioma"|x_translate} <i class="icon-doctorplus-cruz"></i></button>{/if}
                    {if $smarty.request.valoracion!=""}	<button class="btn-remove-filtro" data-target="valoracion_f">{"Valoración"|x_translate} <i class="icon-doctorplus-cruz "></i></button>{/if}
                    {if $smarty.request.obraSocial_idobraSocial!=""}	<button class="btn-remove-filtro" data-target="idobraSocial_f">{"Obra Social"|x_translate} <i class="icon-doctorplus-cruz "></i></button>{/if}
                    {if $smarty.request.sector_idsector!=""}	<button class="btn-remove-filtro" data-target="idsector_f">{"Sector"|x_translate} <i class="icon-doctorplus-cruz "></i></button>{/if}
                </div>
            </div>
            {if $medicos_list.rows && $medicos_list.rows|@count > 0}
                <div id="div_remover_profesionales_busqueda">
                    <div class="row text-center">
                        <label class="checkbox ib">
                            <input type="checkbox" id="btn_remover_profesionales_busqueda" value="1"   data-toggle="checkbox" class="custom-checkbox">
                            {"Quiero remover profesionales de la búsqueda"|x_translate}
                        </label>
                    </div>
                </div>
                <div id="div_listado_resultado_medicos" style="display:none;">
                    <div class="row ce-nc-p2-res">
                        <div class="col-sm-7">
                            <div class="ce-nc-p2-res-list-holder">
                                <div class="ce-nc-p2-res-toolbar">
                                    <ul>
                                        <li class="selectall">
                                            <a href="javascript:;" class="a-pointer" id="btnEliminarMedicos">
                                                <i class="icon-doctorplus-trash"></i>
                                                <span class="label">{"Eliminar"|x_translate}<span></span></span>
                                            </a>
                                        </li>

                                        <li class="bloquear" >
                                            <a href="javascript:;" class="a-pointer"  id="btnBloquearMedicos" >
                                                <figure> <i class="icon-doctorplus-lock"></i></figure>
                                                <label class="a-pointer">{"Bloquear"|x_translate}</label>
                                            </a>
                                        </li>
                                    </ul>

                                    <div class="settings consulta-express-pull-right resultado-pulldown">
                                        <div class="dropdown dropdown-express">

                                            <select id="order-medicos" class=" form-control select select-primary select-block mbl ce-nc-p2-res-list-select select2-offscreen" name="order" style="width:100%">

                                                <option value="">{"Ordenar por"|x_translate}</option>
                                                <option value="alfabetico" {if $smarty.request.order=="alfabetico"}selected{/if}>{"Alfabéticamente"|x_translate}</option>
                                                <option value="tarifa-asc" {if $smarty.request.order=="tarifa-asc"}selected{/if}>{"Menor a mayor tarifa"|x_translate}</option>
                                                <option value="tarifa-desc" {if $smarty.request.order=="tarifa-desc"}selected{/if}>{"Mayor a menos tarifa"|x_translate}</option>
                                                <option value="evaluacion" {if $smarty.request.order=="evaluacion"}selected{/if}>{"Mejor evaluación"|x_translate}</option>


                                            </select>

                                        </div>
                                    </div>


                                </div>

                                <!--				lista-->
                                <div class="ce-nc-resultados-list">
                                    {foreach item=medico from=$medicos_list.rows}
                                        <div class="resultados-list-row">
                                            <div id="medico-resultado-{$medico.idmedico}" class="resultados-list-left" style="cursor:default;">

                                                <div class="resultados-list-left-img">
                                                    <a href="{$url}panel-paciente/profesionales/{$medico.idmedico}-{$medico.nombre|str2seo}-{$medico.apellido|str2seo}.html">
                                                        <figure>
                                                            {if !$medico.imagen}
                                                                <img src="{$IMGS}extranet/noimage_perfil.png" title="{$medico.nombre} {$medico.apellido}" alt="{$medico.nombre} {$medico.apellido}">
                                                            {else}
                                                                <img src="{$path_files}/entities/medicos/{$medico.idmedico}/{$medico.idmedico}_list.jpg" title="{$medico.nombre} {$medico.apellido}" alt="{$medico.nombre} {$medico.apellido}">
                                                            {/if}
                                                        </figure>
                                                    </a>

                                                    <span id="desbloquear-{$medico.idmedico}" class="bloquear {if $medico.bloqueo!=1}hidden{/if}" data-toggle="tooltip" data-placement="right" title="Desbloquear">
                                                        <a href="javascript:;" data-id="{$medico.idmedico}" class="block-mdl-trigger unlock_profesional">
                                                            <figure><i class="icon-doctorplus-lock"></i></figure>
                                                        </a>
                                                    </span>

                                                    <label id="bloquear-{$medico.idmedico}" class="checkbox resultado-check {if $medico.bloqueo==1}hidden{/if}">
                                                        <input type="checkbox" class="check_lock_profesional" data-toggle="checkbox" value="{$medico.idmedico}">
                                                    </label>

                                                </div>

                                                <div class="resultados-list-left-content">
                                                    <h3 id="nombre-profesional-{$medico.idmedico}">                    
                                                        <a href="{$url}panel-paciente/profesionales/{$medico.idmedico}-{$medico.nombre|str2seo}-{$medico.apellido|str2seo}.html">
                                                            {$medico.titulo_profesional} {$medico.nombre} {$medico.apellido}
                                                        </a>
                                                    </h3>
                                                    <span>{$medico.especialidad.0.especialidad}</span>
                                                    <p>
                                                        <span>
                                                        </span>
                                                    </p>
                                                </div>
                                                <div class="resultados-list-left-ratting">
                                                    {*
                                                    <ul class="estrellas-{$medico.estrellas}">
                                                    <li><i class="icon-doctorplus-star"></i></li>
                                                    <li><i class="icon-doctorplus-star"></i></li>
                                                    <li><i class="icon-doctorplus-star"></i></li>
                                                    <li><i class="icon-doctorplus-star"></i></li>
                                                    <li><i class="icon-doctorplus-star"></i></li>
                                                    </ul>
                                                    *}


                                                    {if $medico.frecuente=="1"}
                                                        <a class="ratting-like-added"  data-id="{$medico.idmedico}" style="cursor:default;" href="javascript:;"><i class="icon-doctorplus-user-add-like"></i></a>
                                                        {else}
                                                        <a class="ratting-like {if $medico.favorito=="1"}selected{/if}"  data-id="{$medico.idmedico}" href="javascript:;">
                                                            <i class="icon-doctorplus-corazon"></i>
                                                        </a>
                                                    {/if}

                                                    <p>
                                                        {*{if $medico.valoracion==0}<span>{"Profesional aún sin recomendaciones"|x_translate}</span>{/if}*}
                                                        {if $medico.valoracion >0}
                                                            {if $medico.valoracion ==1}
                                                                <span>{$medico.valoracion} {"paciente lo recomienda"|x_translate}</span>
                                                            {else}
                                                                <span>{$medico.valoracion} {"pacientes lo recomendaron"|x_translate}</span>
                                                            {/if}
                                                        {else}
                                                            <span>&nbsp;</span>
                                                        {/if}
                                                    </p>

                                                </div>
                                            </div>
                                            <div class="resultados-list-right">
                                                <div class="resultados-list-right-price">
                                                    <span>
                                                        {if $medico.valorPinesVideoConsulta>"0"}&euro;{$medico.valorPinesVideoConsulta}
                                                        {else}
                                                            <small>
                                                                {"No publica"|x_translate}
                                                            </small>
                                                        {/if}
                                                    </span>
                                                </div>
                                                <div class="resultados-list-right-action">

                                                    <a  href="javascript:;" role="button"  {if $medico.valorPinesVideoConsulta>"0"}class="select-profesional-consulta" {/if} data-id="{$medico.idmedico}">
                                                        <i class="icon-doctorplus-video-call"></i>
                                                    </a>

                                                </div>
                                            </div>
                                        </div>


                                    {/foreach}

                                </div>


                            </div>

                        </div>
                        <div class="col-sm-5 ce-nc-mapa-holder">


                            <div id="map_canvas" style="height: 550px; width: 100%; margin:0px auto;"></div>
                            <div class="ce-nc-mapa-holder-action-holder">
                                <button class="ce-nc-cerrar-mapa">{"cerrar"|x_translate} <i class="icon-doctorplus-cruz"></i></button>
                            </div>

                            <input type="hidden" id="ids_consultorio_resultado" value="{$id_consultorios}"/>
                        </div>
                    </div>
                    <div class="cs-nc-listado-p2-paginador2-holder">


                        <div class="cs-nc-listado-p2-siguiente" style="float:right">
                            {x_paginate_loadmodule_v2  id="$idpaginate" modulo="videoconsulta" submodulo="nuevavideoconsulta_step2_profesional_red_resultados" container_id="div_profesionales_red_list"}
                        </div>
                    </div>

                    <div class="ce-nc-mapa-toggle-holder">
                        <button class="ce-cn-vermapa">{"Ver mapa"|x_translate} <i class="icon-doctorplus-map-check"></i></button>
                    </div>
                </div>
                <div class="cs-nc-listado-p2-siguiente"  style="float:right">
                    <a href="javascript:;" id="btnSiguienteStep" class="cs-nc-listado-p2-siguiente-btn" >{"siguiente"|x_translate} <span></span></a>
                    <a href="javascript:;" id="btn-delete-consulta" class="btn-cancel"><i class="icon-doctorplus-cruz"></i> {"cancelar consulta"|x_translate}</a>
                </div>

            {else}
                <div class="sin-registros">
                    <i class="icon-doctorplus-people-add"></i>
                    <h6>{"¡No se encontraron resultados!"|x_translate}</h6>
                    <p>{"No registramos profesionales dentro de esos parámetros."|x_translate}</p>
                    <p>{"Vuelva a intentarlo cambiando sus opciones de búsqueda"|x_translate}</p>
                </div>
            {/if}

        </section>

    </div>
</div>


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

<!-- Modal desbloquear -->
<div id="unlock-profesional-modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="mySmallModalLabel">
    <input type="hidden" id="idmedico_unlock_modal" value="">
    <div class="modal-dialog modal-sm modal-action-bool-sm">


        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
            </div>
            <p id="text-profesional-modal-unlock">{"Desbloquear al profesional"|x_translate}</p>
            <h4 id="name-profesional-modal-unlock"></h4>
            <div class="modal-action-holder">
                <a id="unlock-profesional-modal-cancelar" href="javascript:;" class="modal-action-close">{"cancelar"|x_translate}</a>
                <a id="unlock-profesional-modal-aceptar" href="javascript:;" class="modal-action">{"aceptar"|x_translate}</a>
            </div>
        </div>

    </div>
</div>

<!-- Modal bloquear -->
<div id="lock-profesional-modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="mySmallModalLabel">
    <div class="modal-dialog modal-sm modal-action-bool-sm">


        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
            </div>
            <p id="text-profesional-modal-lock"> {"Bloquear al profesional"|x_translate}</p>
            <h4 id="name-profesional-modal-lock"></h4>
            <div class="modal-action-holder">
                <a id="lock-profesional-modal-cancelar" href="javascript:;" class="modal-action-close">{"cancelar"|x_translate}</a>
                <a id="lock-profesional-modal-aceptar" href="javascript:;" class="modal-action">{"aceptar"|x_translate}</a>
            </div>
        </div>

    </div>
</div>

<!-- Modal eliminar -->
<div id="eliminar-profesional-modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="mySmallModalLabel">
    <div class="modal-dialog modal-sm modal-action-bool-sm">


        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
            </div>
            <p id="text-profesional-modal-eliminar"> {"Eliminar el profesional seleccionado. No se incluirá en la consulta."|x_translate}</p>
            <h4 id="name-profesional-modal-eliminar"></h4>
            <div class="modal-action-holder">
                <a id="eliminar-profesional-modal-cancelar" href="javascript:;" class="modal-action-close">{"cancelar"|x_translate}</a>
                <a id="eliminar-profesional-modal-aceptar" href="javascript:;" class="modal-action">{"aceptar"|x_translate}</a>
            </div>
        </div>

    </div>
</div>
<script type="text/javascript"   src="https://maps.google.com/maps/api/js?key={$GOOGLE_MAPS_KEY}&language=fr"></script>
{*Si hay resultados cargamos el mapa de google*}
{if $medicos_list.rows && $medicos_list.rows|@count > 0}

    {literal}
        <script>
        {/literal}
            var NOIMG_SRC = "{$IMGS}extranet/noimage_perfil.png";
            var ICON_RED = "{$IMGS}/icons/ico_pointer_red.png";
            var ICON_BLUE = "{$IMGS}/icons/ico_pointer_blue.png";
        {literal}

            $(function () {
                renderUI2();

                /**
                 * Map
                 */

                var params = {};
                var letters = new Array("A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z");
                $.getJSON(BASE_PATH + 'paciente_p.php?action=1&modulo=google&submodulo=get_coordenadas_map&id_consultorios=' + $("#ids_consultorio_resultado").val(), {format: "json"}, function (data) {
///center: [data.lat, data.lng]
                    var lng = data.lng;
                    var lat = data.lat;
                    var latlng = new google.maps.LatLng(lat, lng);


                    var zoom_pais = parseInt(data.zoom);
                    var myOptions = {
                        zoom: 20,
                        center: latlng,
                        mapTypeId: google.maps.MapTypeId.ROADMAP
                    };


                    //inicializamos el mapa
                    map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);

                    //cargamos los consultorios   
                    if (data.no_idconsultorios) {
                        console.log("no vienen consultorios");
                    } else {

                        var infowindow = new google.maps.InfoWindow();
                        var bounds = new google.maps.LatLngBounds();

                        $.each(data, function (index, value) {


                            if (value.hasOwnProperty('idconsultorio')) {

                                var point = new google.maps.LatLng(value.lat, value.lng);
                                //guardo la posicion para centrar
                                bounds.extend(point);
                                if (!value.imagen) {//si no hay foto de medico
                                    var html_cont = "<div class='map-content'><img class='mCS_img_loaded' title='" + value.name + "' alt='" + value.name + "' src='" + NOIMG_SRC + "'><div class='tooltip-usr'>" + value.name + "<br><span>" + value.especialidad + "</span></div><a class='tooltip-precio' href='javascript:;' onclick='setProfesionalConsulta(" + value.idmedico + ");'> <i class='icon-doctorplus-video-call'></i>&nbsp;<span> &euro;" + value.valorPinesVideoConsulta + " </span></a></div>";
                                } else {
                                    //contenido del pop up
                                    var html_cont = "<div class='map-content'><img class='mCS_img_loaded' title='" + value.name + "' alt='" + value.name + "' src='" + value.imagen.perfil + "'><div class='tooltip-usr'>" + value.name + "<br><span>" + value.especialidad + "</span></div><a class='tooltip-precio' href='javascript:;' onclick='setProfesionalConsulta(" + value.idmedico + ");'> <i class='icon-doctorplus-video-call'></i>&nbsp;<span> &euro;" + value.valorPinesVideoConsulta + " </span></a></div>";
                                }

                                infowindow.setContent(html_cont);



                                var marker = new google.maps.Marker({
                                    position: point,
                                    map: map,
                                    icon: ICON_BLUE,
                                    draggable: false,
                                    title: "Carte des cabinets"
                                });



                                google.maps.event.addListener(marker, 'click', function () {
                                    infowindow.setContent(html_cont);

                                    infowindow.open(map, marker);
                                });
                                google.maps.event.addListener(marker, 'mouseover', function () {

                                    infowindow.setContent(html_cont);
                                    infowindow.open(map, marker);
                                    marker.setIcon(ICON_RED);
                                });
                                google.maps.event.addListener(marker, 'mouseout', function () {
                                    marker.setIcon(ICON_BLUE);
                                });

                                $("#medico-resultado-" + value.idmedico).mouseover(function () {

                                    if (infowindow) {
                                        infowindow.close();
                                    }
                                    google.maps.event.trigger(marker, 'click');
                                    marker.setIcon(ICON_RED);

                                });
                                $("#medico-resultado-" + value.idmedico).mouseout(function () {

                                    marker.setIcon(ICON_BLUE);
                                });


                            }
                        });

                        //autocentrado

                        map.fitBounds(bounds);
                        map.panToBounds(bounds);


                    }

                });



            });
        </script>
    {/literal}
{/if}

{literal}

    <script>

        x_runJS();


        //seleccionar medico de video consulta desde gmap
        var setProfesionalConsulta = function (idmedico) {

            x_doAjaxCall(
                    'POST',
                    BASE_PATH + 'set_medico_videoconsulta.do',
                    'medico_idmedico=' + idmedico + "&idvideoconsulta=" + $("#idvideoconsulta").val(),
                    function (data) {

                        if (data.result) {
                            window.location.href = "" + "?continue=true";
                            ;
                        } else {
                            x_alert(data.msg);
                        }

                    }

            );
        };


        $(function () {


            $("#btn_remover_profesionales_busqueda").click(function () {
                $("#div_remover_profesionales_busqueda").hide();
                $("#div_listado_resultado_medicos").slideDown();
            })



            /**
             * Fin de búsquedas de consultorios
             */


            $('#div_profesionales_red_list span.text-cut').each(function () {
                if ($(this).html().length > 170) {
                    $(this).html($(this).html().substring(0, 170) + "...");
                }
            });
            $(':checkbox').radiocheck();
            $('[data-toggle="tooltip"]').tooltip({
                template: '<div class="tooltip alert-tooltip" role="tooltip"><div class="tooltip-arrow"></div><div class="tooltip-inner"></div></div>'
            });
            $('.block-mdl-trigger').on('click', function (e) {
                e.preventDefault();
                $('#blck-modal').modal('show');
            });
            $(".ce-nc-resultados-list").mCustomScrollbar({
                theme: "dark-3"
            });
            $('.ce-cn-vermapa').on('click', function (e) {
                e.preventDefault();
                $('.ce-nc-mapa-holder').toggleClass('ce-nc-mapa-visible');
                $(this).hide();
            });
            $('.ce-nc-cerrar-mapa').on('click', function (e) {
                e.preventDefault();
                $('.ce-nc-mapa-holder').toggleClass('ce-nc-mapa-visible');
                $('.ce-cn-vermapa').show();
            });
            $('.resultados-list-row').on('click', function (e) {
                $('.resultados-list-left').removeClass('resultados-list-left-selected');
                $(this).find('.resultados-list-left').toggleClass('resultados-list-left-selected');
            });
            renderUI2("videoconsulta-step-container");
            //boton setear o eliminar medico favorito
            $('.ce-nc-p2-res a.ratting-like').click(function () {
                $element = $(this);
                var id = $(this).data('id');
                x_doAjaxCall(
                        'POST',
                        BASE_PATH + 'marcar_favorito.do',
                        'idmedico=' + id,
                        function (data) {
                            if (data.result) {
                                if ($element.hasClass('selected')) {
                                    $element.removeClass("selected");
                                } else {
                                    $element.addClass("selected");
                                }


                            } else {
                                x_alert(data.msg);
                            }
                        }

                );
            });
            //boton desbloquear un medico del listado
            $('.unlock_profesional').click(function () {
                $element = $(this);
                var id_medico = $(this).data('id');
                $("#idmedico_unlock_modal").val(id_medico);
                $("#name-profesional-modal-unlock").html($("#nombre-profesional-" + id_medico).html());

                $("#unlock-profesional-modal").modal('show');
            });


            //cancelar desbloquear
            $("#unlock-profesional-modal-cancelar").click(function () {
                $("#unlock-profesional-modal").modal('hide');
            });
            //aceptar desbloquear
            $("#unlock-profesional-modal-aceptar").click(function () {
                var id = $("#idmedico_unlock_modal").val();

                $("#div_profesionales_red_list").spin("large");

                x_doAjaxCall(
                        'POST',
                        BASE_PATH + 'unlock_profesional_frecuente.do',
                        'idmedico=' + id,
                        function (data) {
                            $("#div_profesionales_red_list").spin(false);
                            $("#unlock-profesional-modal").modal('hide');
                            if (data.result) {

                                $(".check_lock_profesional[value=" + id + "]").radiocheck('uncheck');
                                $("#bloquear-" + id).removeClass("hidden");
                                $("#desbloquear-" + id).addClass("hidden");
                            } else {
                                x_alert(data.msg);
                            }
                        }

                );
            });
            //boton bloquear multiples medicos listado profesionales frecuentes
            $('#btnBloquearMedicos').click(function () {


                var ids = "";
                $.each($(".check_lock_profesional:checked"),
                        function (index, value) {
                            ids += "," + $(this).val();
                            //console.log($(this).val());
                        });
                if (ids.length > 0) {
                    ids = ids.substring(1);
                } else {

                    x_alert(x_translate("No hay profesionales seleccionados"));
                    return false;
                }
                if ($(".check_lock_profesional:checked").length == 1) {
                    $("#text-profesional-modal-lock").html(x_translate("Bloquear al profesional seleccionado"));
                    id_medico = $(".check_lock_profesional:checked").val();
                    $("#name-profesional-modal-lock").html($("#nombre-profesional-" + id_medico).html());
                } else {
                    $("#text-profesional-modal-lock").html(x_translate("Bloquear a los prefesionales seleccionados"));
                    $("#name-profesional-modal-lock").html("");

                }
                $("#lock-profesional-modal").modal('show');
            });
            //cancelar bloquear
            $("#lock-profesional-modal-cancelar").click(function () {
                $("#lock-profesional-modal").modal('hide');
            });
            //aceptar bloquear
            $("#lock-profesional-modal-aceptar").click(function () {

                var ids = "";
                $.each($(".check_lock_profesional:checked"),
                        function (index, value) {
                            ids += "," + $(this).val();
                            //console.log($(this).val());
                        });
                if (ids.length > 0) {
                    ids = ids.substring(1);
                } else {

                    x_alert(x_translate("No hay profesionales seleccionados"));
                    return false;
                }
                $("#div_profesionales_red_list").spin("large");
                x_doAjaxCall(
                        'POST',
                        BASE_PATH + 'lock_multiple_profesionales_frecuentes.do',
                        'ids=' + ids,
                        function (data) {

                            $("#div_profesionales_red_list").spin(false);
                            $("#lock-profesional-modal").modal('hide');
                            if (data.result) {


                                ids_arr = ids.split(',');
                                $.each(ids_arr, function (key, value) {
                                    $(".check_lock_profesional[value=" + value + "]").radiocheck('uncheck');
                                    $("#bloquear-" + value).addClass("hidden");
                                    $("#desbloquear-" + value).removeClass("hidden");

                                });
                            } else {
                                x_alert(data.msg);
                            }

                        }
                );

            });

            //boton eliminar multiples medicos de la video consulta
            $('#btnEliminarMedicos').click(function () {
                var ids = "";
                $.each($(".check_lock_profesional:checked"),
                        function (index, value) {
                            ids += "," + $(this).val();
                            //console.log($(this).val());
                        });
                if (ids.length > 0) {
                    ids = ids.substring(1);
                } else {

                    x_alert(x_translate("No hay profesionales seleccionados"));
                    return false;
                }
                if ($(".check_lock_profesional:checked").length == 1) {
                    $("#text-profesional-modal-eliminar").html(x_translate("Eliminar el profesional seleccionado. No se incluirá en la consulta."));
                    id_medico = $(".check_lock_profesional:checked").val();
                    $("#name-profesional-modal-eliminar").html($("#nombre-profesional-" + id_medico).html());
                } else {
                    $("#text-profesional-modal-eliminar").html(x_translate("Eliminar los profesionales seleccionados. <br> No se incluirán en la consulta."));
                    $("#name-profesional-modal-eliminar").html("");

                }
                $("#eliminar-profesional-modal").modal('show');
            });

            //cancelar bloquear
            $("#eliminar-profesional-modal-cancelar").click(function () {
                $("#eliminar-profesional-modal").modal('hide');
            });
            //aceptar bloquear
            $("#eliminar-profesional-modal-aceptar").click(function () {

                var ids = "";
                $.each($(".check_lock_profesional:checked"),
                        function (index, value) {
                            ids += "," + $(this).val();
                            //console.log($(this).val());
                        });
                if (ids.length > 0) {
                    ids = ids.substring(1);
                } else {

                    x_alert(x_translate("No hay profesionales seleccionados"));
                    return false;
                }

                $("#div_profesionales_red_list").spin("large");

                x_doAjaxCall(
                        'POST',
                        BASE_PATH + 'eliminar_medicos_videoconsulta.do',
                        'ids=' + ids + "&idvideoconsulta=" + $("#idvideoconsulta").val(),
                        function (data) {
                            $("#eliminar-profesional-modal").modal('hide');
                            $("#div_profesionales_red_list").spin(false);
                            if (data.result) {


                                x_loadModule('videoconsulta', 'nuevavideoconsulta_step2_profesional_red_resultados', $("#f_busqueda").serialize(), "videoconsulta-step-container", BASE_PATH + "paciente_p");
                            } else {
                                x_alert(data.msg);
                            }

                        }
                );

            });



            //al limpiar los filtros recargamos el modulo
            $(".btn-remove-filtro").click(function () {
                var remove_input = $(this).data('target');
                $("#" + remove_input).val("");
                //cuando limpiamos la pais tambien borramos la localidad
                if (remove_input == "idpais_f") {
                    $("#idlocalidad_f").val("");
                }

                x_doAjaxCall(
                        'POST',
                        BASE_PATH + "save_filtros_busqueda.do",
                        $("#f_busqueda").serialize(),
                        function (data) {
                            if (data.result) {
                                x_loadModule('videoconsulta', 'nuevavideoconsulta_step2_profesional_red_resultados', $("#f_busqueda").serialize() + "&do_reset=1", "videoconsulta-step-container", BASE_PATH + "paciente_p");
                            } else {
                                x_alert(data.msg);

                            }

                        }
                );
            });
            //opciones de ordenamiento
            $("#order-medicos").change(function () {

                $("#order_f").val($(this).val());
                x_loadModule('videoconsulta', 'nuevavideoconsulta_step2_profesional_red_resultados', $("#f_busqueda").serialize() + "&do_reset=1", "videoconsulta-step-container", BASE_PATH + "paciente_p");
            });
            //nueva busqueda
            $("#btn-nueva-busqueda").click(function () {

                x_loadModule('videoconsulta', 'nuevavideoconsulta_step2_profesional_red_busqueda', 'idvideoconsulta=' + $("#idvideoconsulta").val(), 'videoconsulta-step-container', BASE_PATH + "paciente_p");
            });
            //seleccionar medico de video consulta
            $(".select-profesional-consulta").click(function () {
                var idmedico = $(this).data('id');
                x_doAjaxCall(
                        'POST',
                        BASE_PATH + 'set_medico_videoconsulta.do',
                        'medico_idmedico=' + idmedico + "&idvideoconsulta=" + $("#idvideoconsulta").val(),
                        function (data) {

                            if (data.result) {
                                window.location.href = "" + "?continue=true";
                            } else {
                                x_alert(data.msg);
                            }

                        }

                );
            });
            //botones para asignar los medicos de la bola a la consulta y seguir al siguiente paso
            $("#btnSiguienteStep").click(function () {

                x_doAjaxCall(
                        'POST',
                        BASE_PATH + 'nuevavideoconsulta_step2_profesionalred.do',
                        'idvideoconsulta=' + $("#idvideoconsulta").val(),
                        function (data) {
                            if (data.result) {
                                x_loadModule('videoconsulta', 'nuevavideoconsulta_step3', 'idvideoconsulta=' + $("#idvideoconsulta").val(), 'videoconsulta-step-container', BASE_PATH + "paciente_p");
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
