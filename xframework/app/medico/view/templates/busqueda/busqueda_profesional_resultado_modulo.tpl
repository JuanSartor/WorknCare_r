<script>
    $("#Main").spin(false);
</script>
{if $listado_medicos.rows|@count > 0}
    <input type="hidden" id="ids_consultorio_resultado" value="{$id_consultorios}"/>
    <section class="pbn-listado-section pbp-listado-holder">
        <div class="okm-container">

            <div class="okm-row">
                {foreach from=$listado_medicos.rows item=medico}
                    <div class="pbn-col-profesional pbp-ficha-medico">

                        <div class="gnlist-profesional-holder">

                            <div class="okm-row gnlist-profesional-row">
                                <div class="pbp-ficha-medico-bg">
                                    <figure class="gnlist-usr-avatar">
                                        <a href="{$url}panel-medico/profesionales/{$medico.idmedico}-{$medico.nombre|str2seo}-{$medico.apellido|str2seo}.html?from_busqueda=1">
                                            {if $medico.imagen.list!=""}
                                                <img src="{$medico.imagen.list}" title="{$medico.titulo_profesional} {$medico.nombre} {$medico.apellido}"/>
                                            {else}
                                                <img src="{$IMGS}extranet/noimage_perfil.png" title="{$medico.titulo_profesional} {$medico.nombre} {$medico.apellido}"/>
                                            {/if}
                                        </a>
                                    </figure>

                                    <div class="gnlist-usr-data-holder">
                                        <h3><a href="{$url}panel-medico/profesionales/{$medico.idmedico}-{$medico.nombre|str2seo}-{$medico.apellido|str2seo}.html?from_busqueda=1">{$medico.titulo_profesional} {$medico.nombre} {$medico.apellido}</a></h3>
                                        <h4>{$medico.especialidad.0.especialidad}</h4>
                                        <div class="usr-data-content">
                                            <p><span></span></p>
                                        </div>
                                    </div>

                                    <div class="gnlist-ratting-holder">
                                        <div class="resultados-list-left-ratting">
                                            {*
                                            <ul class="estrellas-{$medico.cantidad_estrellas}">
                                            <li><i class="icon-doctorplus-star"></i></li>
                                            <li><i class="icon-doctorplus-star"></i></li>
                                            <li><i class="icon-doctorplus-star"></i></li>
                                            <li><i class="icon-doctorplus-star"></i></li>
                                            <li><i class="icon-doctorplus-star"></i></li>
                                            </ul>
                                            *}
                                            {if $medico.cantidad_recomendaciones > 0}
                                                <p>{$medico.cantidad_recomendaciones} patient{if $medico.cantidad_recomendaciones > 1}s{/if}<span> {if $medico.cantidad_recomendaciones > 1}ils l'ont recommandé{else}le recommande{/if}</span></p>
                                            {else}
                                                {*<p><span>{"Profesional aún sin recomendaciones"|x_translate}</span></p>*}
                                            {/if}
                                            <a class="pbp-contacto-modal-trigger data modal-btn " data-id="{$medico.idmedico}" role="button" href="javascript:;"><i class="dp-email"></i></a>
                                        </div>
                                    </div>
                                </div>
                                <div class="pnb-consultorios-holder">
                                    {if $medico.posee_consultorio_virtual==1}
                                        <div class="pbp-tiene-consultorio-virtual"><figure>{"¡Posee Consultorio Virtual!"|x_translate}</figure></div>
                                            {/if}
                                    <!-- Nav tabs -->
                                    <ul class="nav nav-tabs pbp-consultorio-tabs" role="tablist">

                                        {if $medico.list_consultorios|@count >0}
                                            {foreach from=$medico.list_consultorios item=consultorio name=foo}
                                                {if $consultorio.is_virtual=="0"}
                                                    <li role="presentation" {if $smarty.foreach.foo.first}class="active"{/if}>
                                                        <a href="#consultorio-{$consultorio.idconsultorio}" aria-controls="consultorio-{$consultorio.idconsultorio}" role="tab" data-toggle="tab">
                                                            <i class="icon-doctorplus-map-plus-rounded"></i>
                                                            <span class="arrow"></span>
                                                        </a>
                                                    </li>
                                                {else}
                                                    <li role="presentation">
                                                        <a href="#consultorio-{$consultorio.idconsultorio}" aria-controls="consultorio-{$consultorio.idconsultorio}" role="tab" data-toggle="tab">
                                                            <i class="icon-doctorplus-consultorio-virtual"></i>
                                                            <span class="arrow"></span>
                                                        </a>
                                                    </li>
                                                {/if}
                                            {/foreach}
                                        {else}
                                            <li role="presentation" class="active">
                                                <a href="#consultorio-no" aria-controls="consultorio-no" role="tab" data-toggle="tab">
                                                    <i class="icon-doctorplus-map-plus-rounded"></i>
                                                    <span class="arrow"></span>
                                                </a>
                                            </li>
                                        {/if}

                                    </ul>

                                    <!-- Tab panes -->
                                    <div class="tab-content pbp-consultorio-tabs-content">
                                        {if $medico.list_consultorios|@count >0}
                                            {foreach from=$medico.list_consultorios item=consultorio name=foo1}
                                                {if $consultorio.is_virtual=="0"}
                                                    <div role="tabpanel" class="tab-pane {if $smarty.foreach.foo1.first}active{/if}" id="consultorio-{$consultorio.idconsultorio}">
                                                        <a href="javascript:;">
                                                            <span>{"Consultorio Físico"|x_translate} - {$consultorio.direccion} {$consultorio.numero}, {$consultorio.localidad}, {$consultorio.provincia}</span>
                                                        </a>
                                                    </div>
                                                {else}
                                                    <div role="tabpanel" class="tab-pane {if $smarty.foreach.foo1.first}active{/if}" id="consultorio-{$consultorio.idconsultorio}">
                                                        <a href="javascript:;">
                                                            <span>{"Consultorio Virtual - Habilitado solo para pacientes"|x_translate}</span>
                                                        </a>
                                                    </div>
                                                {/if}
                                            {/foreach}
                                        {else}
                                            <div role="tabpanel" class="tab-pane active" id="consultorio-no">
                                                <span>{"No declara dirección de consultorio"|x_translate}</span>
                                            </div>
                                        {/if}

                                    </div>

                                </div>
                            </div>

                        </div>



                    </div>

                    <!-- Modal Medico ENVIAR Mensaje  -->
                    <div class="modal fade pbp-modal-contacto" id="pacientes-info-{$medico.idmedico}">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-body">
                                    <span class="close-btn" data-dismiss="modal" aria-label="Close"><i class="fui-cross"></i></span>		
                                    <div class="form-content">
                                        <div class="data">

                                            {if $medico.imagen.list!=""}
                                                <img class="img-circle" src="{$medico.imagen.list}" alt="{$medico.titulo_profesional} {$medico.nombre} {$medico.apellido}">
                                            {else}
                                                <img class="img-circle" src="{$IMGS}extranet/noimage_perfil.png" alt="{$medico.titulo_profesional} {$medico.nombre} {$medico.apellido}"/>

                                            {/if}
                                            <h3>{$medico.titulo_profesional} {$medico.nombre} {$medico.apellido}</h3>
                                            <div class="more-data pbp-modal-contacto-mensaje-ready">
                                                <textarea name="mensaje" id="text_mensaje_{$medico.idmedico}" class="form-control flat" placeholder="Mensaje"></textarea>
                                                <a href="javascript:;" data-id="{$medico.idmedico}" class="dp-email btn_msg_profesional pbp-modal-contacto-trigger"></a>
                                            </div>
                                            <div class="pbp-modal-contacto-mensaje-enviado">
                                                {"¡Su mensaje ha sido enviado!"|x_translate}
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                {/foreach}



            </div>

        </div>
    </section>
    <div class="pbn-divider"></div>	

    <div class="pbn-paginador">
        <div class="okm-container">
            {x_paginate_loadmodule_v2  id="$idpaginate" modulo="busqueda"
        submodulo="busqueda_profesional_resultado_modulo" 
        container_id="modulo_listado_consultorios"}
        </div>	
    </div>



    {*Codigo JS del mapa*}
    {*Si hay resultados cargamos el mapa de google*}
    {if $listado_medicos.rows && $listado_medicos.rows|@count > 0}
        {literal}
            <script>

                /* INICIO */


                var inicializarMapaBuscador = function () {
                    mapa_inicializado = true;

                    /**
                     * Map
                     */

                    var params = {};
                    var letters = new Array("A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z");
                    $.getJSON('medico.php?action=1&modulo=google&submodulo=get_coordenadas_map&id_consultorios=' + $("#ids_consultorio_resultado").val(), {format: "json"}, function (data) {
                        ///center: [data.lat, data.lng]

                        var lng = data.lng;
                        var lat = data.lat;
                        var latlng = new google.maps.LatLng(lat, lng);


                        var zoom_pais = parseInt(data.zoom);
                        var myOptions = {
                            zoom: zoom_pais,
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
                                        var html_cont = "<div class='map-content'><a href='" + BASE_PATH + "panel-medico/profesionales/" + value.seo + ".html?from_busqueda=1'><img class='mCS_img_loaded' title='" + value.name + "' alt='" + value.name + "' src='" + NOIMG_SRC + "'></a><div class='tooltip-usr'><a href='" + BASE_PATH + "panel-medico/profesionales/" + value.seo + ".html?from_busqueda=1'>" + value.name + "<br><span>" + value.especialidad + "</span></div><div class='tooltip-address'><i class='icon-doctorplus-map-plus-rounded'></i><p>" + value.direccion + " " + value.numero + "<br>" + value.localidad + ", " + value.provincia + "</p></div></div>";
                                    } else {
                                        //contenido del pop up
                                        var html_cont = "<div class='map-content'><a href='" + BASE_PATH + "panel-medico/profesionales/" + value.seo + ".html?from_busqueda=1'><img class='mCS_img_loaded' title='" + value.name + "' alt='" + value.name + "' src='" + value.imagen.perfil + "'></a><div class='tooltip-usr'><a href='" + BASE_PATH + "panel-medico/profesionales/" + value.seo + ".html?from_busqueda=1'>" + value.name + "<br><span>" + value.especialidad + "</span></div><div class='tooltip-address'><i class='icon-doctorplus-map-plus-rounded'></i><p>" + value.direccion + " " + value.numero + "<br>" + value.localidad + ", " + value.provincia + "</p></div></div>";
                                    }

                                    infowindow.setContent(html_cont);



                                    var marker = new google.maps.Marker({
                                        position: point,
                                        map: map,
                                        icon: ICON_BLUE,
                                        draggable: false,
                                        title: x_translate("Mapa de los consultorios")
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

                                    $("#medico-resultado-" + value.idconsultorio).mouseover(function () {

                                        if (infowindow) {
                                            infowindow.close();
                                        }
                                        google.maps.event.trigger(marker, 'click');
                                        marker.setIcon(ICON_RED);

                                    });
                                    $("#medico-resultado-" + value.idconsultorio).mouseout(function () {

                                        marker.setIcon(ICON_BLUE);
                                    });


                                }
                            });

                            //autocentrado

                            map.fitBounds(bounds);
                            map.panToBounds(bounds);


                        }

                    });

                } /* FIN */


            </script>
        {/literal}
    {/if}
    {literal}
        <script>
            $(function () {
                //excedente de lineas de texto subespecialidad
                if ($('.text-cut').length > 0) {
                    textcut('.text-cut', $('.text-cut').data('lines'));
                }

                //boton confirmacion enviar mensaje del modal de Mensaje al medico
                $(".btn_msg_profesional").click(function () {
                    var id = $(this).data('id');
                    if ($("#text_mensaje_" + id).val() == "") {
                        x_alert(x_translate("Ingrese el texto del mensaje"));
                        return false;
                    }


                    if (parseInt(id) > 0 && $("#text_mensaje_" + id).val() != "") {

                        $("body").spin("large");
                        x_doAjaxCall(
                                'POST',
                                BASE_PATH + 'enviar_mensaje_from_mis_pacientes.do',
                                "mensaje=" + $("#text_mensaje_" + id).val() + "&idmedico=" + id,
                                function (data) {
                                    $("body").spin(false);

                                    if (data.result) {
                                        x_alert(data.msg);
                                        if ($('.pbp-modal-contacto').is(':visible')) {
                                            $('.pbp-modal-contacto-mensaje-ready').hide();
                                            $('.pbp-modal-contacto-mensaje-enviado').show();

                                        }
                                    } else {
                                        x_alert(data.msg);
                                    }
                                });
                    }
                });

                $(':checkbox').radiocheck();



                //boton de una tarjeta de medico que abre el modal para enviarle un  msj
                $(".pbp-contacto-modal-trigger").click(function () {
                    var id = $(this).data('id');
                    if (parseInt(id) > 0) {
                        //mostramos el text area y ocultamos el msj de exito
                        $('#pacientes-info-' + id + ' .pbp-modal-contacto-mensaje-ready').show();
                        $("#text_mensaje_" + id).val("");
                        $('#pacientes-info-' + id + ' .pbp-modal-contacto-mensaje-enviado').hide();
                        $("#pacientes-info-" + id).modal('show');
                    }
                });



            });
        </script>
    {/literal}


{else}
    <div class="sin-registros">
        <i class="dp-pacientes dp-icon"></i>
        <h6>{"¡No se encontraron resultados!"|x_translate}</h6>
        <p>{"No hay Médicos en la búsqueda hecha."|x_translate}</p>
    </div>
{/if}