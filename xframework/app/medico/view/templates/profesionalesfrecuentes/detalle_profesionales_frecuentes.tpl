{if $medico_detalle.idmedico!=""}

    <!-- /accesso directos menu -->
    {if $smarty.request.from_busqueda=="1"}
        <section class="pbn-section-buscador">
            <div class="okm-container">
                <div class="okm-row pbn-background">
                    <div class="pbn-buscador-col pbp-section-top">
                        <a href="{$url}panel-medico/busqueda-profesional/"  class="pbp-section-top-action"><i class="icon-doctorplus-left-arrow"></i><i class="icon-doctorplus-people-add"></i></a>
                        <h2>{"Buscador de profesionales"|x_translate}</h2>
                    </div>
                    <div class="pbn-buscador-btn-col">
                        <a href="{$url}panel-medico/busqueda-profesional/" class="btn-oil-square pbn-buscador-btn"><span>{"Nueva búsqueda"|x_translate}</span> <i class="icon-doctorplus-search"></i></a>
                    </div>
                </div>
            </div>
        </section>
    {else}
        <section class="pbn-section-buscador">
            <div class="okm-container">
                <div class="okm-row ">
                    <div class="pbn-buscador-col pbp-section-top">
                        <a href="javascript:;"  onclick="window.history.back();" class="pbp-section-top-action"><i class="icon-doctorplus-left-arrow"></i></a>
                        <h2>{"Ficha de Médico"|x_translate} </h2>
                    </div>
                    <div class="pbn-buscador-btn-col">
                        <a href="{$url}panel-medico/busqueda-profesional/" class="btn-oil-square pbn-buscador-btn"><span>{"Buscar otro profesional"|x_translate}</span> <i class="icon-doctorplus-search"></i></a>
                    </div>
                </div>
            </div>
        </section>
    {/if}

    <input type="hidden" id="idmedico" value="{$medico_detalle.idmedico}">


    <section class="okm-container pbp-medico-ficha">
        <div class="okm-row">
            <div class="pbp-col">
                <div class="gnlist-profesional-holder">
                    <div class="okm-row gnlist-profesional-row">

                        <figure class="gnlist-usr-avatar">
                            <a href="javascript:;">
                                {if !$medico_detalle.imagen}
                                    <img src="{$IMGS}extranet/noimage_perfil.png"  alt="{$medico_detalle.tituloprofesional} {$medico_detalle.nombre} {$medico_detalle.apellido}">
                                {else}
                                    <img src="{$medico_detalle.imagen.list}" alt="{$medico_detalle.tituloprofesional} {$medico_detalle.nombre} {$medico_detalle.apellido}">
                                {/if}
                            </a>
                        </figure>

                        <div class="gnlist-usr-data-holder">
                            <h3><a href="javascript:;">{$medico_detalle.tituloprofesional} {$medico_detalle.nombre} {$medico_detalle.apellido}</a></h3>
                            <h4>{$medico_detalle.mis_especialidades.0.especialidad}</h4>
                            <div class="usr-data-content">
                                <p></p>
                            </div>
                        </div>
                    </div>
                    <div class="gnlist-ratting-holder">
                        <div class="resultados-list-left-ratting">
                            <!--	
                                Clase estrellas-n (n de 1 a 5 marca lacantidad de estrellas resaltadas)
                            -->
                            <ul class="estrellas-{$medico_detalle.estrellas}">
                                <li><i class="icon-doctorplus-star"></i></li>
                                <li><i class="icon-doctorplus-star"></i></li>
                                <li><i class="icon-doctorplus-star"></i></li>
                                <li><i class="icon-doctorplus-star"></i></li>
                                <li><i class="icon-doctorplus-star"></i></li>
                            </ul>
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
                            <a class="pbp-contacto-modal-trigger data modal-btn " data-id="{$medico_detalle.idmedico}" role="button" href="javascript:;"><i class="dp-email"></i></a>
                        </div>
                    </div>
                    <div class="pnb-consultorios-holder">

                        <!-- Nav tabs -->
                        <ul class="nav nav-tabs pbp-consultorio-tabs" role="tablist">
                            {if $medico_detalle.consultorios|@count >0}
                                {foreach from=$medico_detalle.consultorios item=consultorio name=foo}
                                    {if $consultorio.is_virtual=="0"}
                                        <li role="presentation" {if $smarty.foreach.foo.first}class="active"{/if}>
                                            <a href="#consultorio-{$consultorio.idconsultorio}" aria-controls="home" role="tab" data-toggle="tab" class="consultorio_change" data-id="{$consultorio.idconsultorio}">
                                                <i class="icon-doctorplus-map-plus-rounded"></i>
                                                <span class="arrow"></span>
                                            </a>
                                        </li>
                                    {else}
                                        <li role="presentation" {if $smarty.foreach.foo.first}class="active"{/if}>
                                            <a href="#consultorio-{$consultorio.idconsultorio}" aria-controls="messages" role="tab" data-toggle="tab">
                                                <i class="icon-doctorplus-video-call"></i>
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
                            {if $medico_detalle.consultorios|@count >0}
                                {foreach from=$medico_detalle.consultorios item=consultorio name=foo1}
                                    {if $consultorio.is_virtual=="0"}
                                        <div role="tabpanel" class="tab-pane {if $smarty.foreach.foo1.first}active{/if}" id="consultorio-{$consultorio.idconsultorio}">
                                            <a href="#target-consultorio-{$consultorio.idconsultorio}" class="pbp-turno-trigger">
                                                <span> {"Consultorio Físico"|x_translate} - {$consultorio.direccion} {$consultorio.numero}, {$consultorio.localidad}, {$consultorio.provincia}</span>
                                            </a>
                                        </div>
                                    {else}
                                        <div role="tabpanel" class="tab-pane {if $smarty.foreach.foo1.first}active{/if}" id="consultorio-{$consultorio.idconsultorio}">
                                            <span>{"Próximamente usted podrá realizar Video Consultas"|x_translate}</span>
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

                <div class="pbp-card pbp-perfil-profesional">
                    <div class="pbp-card-inner">

                        <h3><i class="icon-doctorplus-ficha-tecnica"></i> {"Perfil Profesional"|x_translate}</h3>
                        <div class="pbp-card-slide">
                            <h4>{"CV / Formación académica y experiencia profesional"|x_translate}</h4>
                            <div class="pbp-perfil-profesional-expand-text" data-lines="20" data-linesrsp="10">
                                <span>              
                                    <p>{$medico_detalle.formacionAcademica}</p> 
                                </span>

                            </div>

                            <h4>{"Miembro de Asociaciones Médicas"|x_translate}</h4>

                            <div class="pbp-perfil-profesional-expand-text" data-lines="20" data-linesrsp="10">
                                <span>
                                    <p>{$medico_detalle.experienciaProfesional}</p>
                                </span>
                            </div>


                        </div>
                    </div>
                </div>
            </div>

            <div class="pbp-col">
                <div id="mapa" class="pbp-map-card ">
                    <div class="google-maps">
                        <div id="map_canvas" style="height: 418px; width: 100%; margin:0px auto;"></div>
                        <input type="hidden" id="ids_consultorio_resultado" value="{$id_consultorios}"/>
                    </div>
                </div>


                <div class="pbp-card">
                    <div class="pbp-card-inner">
                        <h3><i class="icon-doctorplus-maletin"></i> {"Servicios que ofrece"|x_translate}</h3>
                        <div class="pbp-card-slide">

                            <div class="okm-row">

                                <div class="pbp-tarifas-tipo">
                                    {if $medico_detalle.posee_consultapresencial=="1"}
                                        <span class="pbp-tarifa-tipo-trigger">
                                            <figure>
                                                <i class="icon-doctorplus-estetoscopio"></i>
                                            </figure>	
                                        </span>
                                    {/if}

                                    {if $medico_detalle.preferencia.valorPinesConsultaExpress>"0"}
                                        <span class="pbp-tarifa-tipo-trigger">
                                            <figure>
                                                <i class="icon-doctorplus-chat"></i>
                                            </figure>
                                        </span>
                                    {/if}
                                    {if $medico_detalle.posee_videoconsulta=="1"}
                                        <span class="pbp-tarifa-tipo-trigger">
                                            <figure>
                                                <i class="icon-doctorplus-video-call"></i>
                                            </figure>	
                                        </span>
                                    {/if}
                                </div>



                            </div>
                        </div>
                    </div>
                </div>


            </div>


        </div>

    </section>
    <a href="javascript:;" class="map-static-btn"><i class="icon-doctorplus-map-check"></i></a>
    <!-- Modal Medico ENVIAR Mensaje  -->
    <div class="modal fade pbp-modal-contacto" id="pacientes-info-{$medico_detalle.idmedico}">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-body">
                    <span class="close-btn" data-dismiss="modal" aria-label="Close"><i class="fui-cross"></i></span>		
                    <div class="form-content">
                        <div class="data">

                            {if $medico_detalle.imagen.list!=""}
                                <img class="img-circle" src="{$medico_detalle.imagen.list}" alt="{$medico_detalle.titulo_profesional} {$medico_detalle.nombre} {$medico_detalle.apellido}">
                            {else}
                                <img class="img-circle" src="{$IMGS}extranet/noimage_perfil.png" alt="{$medico_detalle.titulo_profesional} {$medico_detalle.nombre} {$medico_detalle.apellido}"/>

                            {/if}
                            <h3>{$medico_detalle.tituloprofesional} {$medico_detalle.nombre} {$medico_detalle.apellido}</h3>
                            <div class="more-data pbp-modal-contacto-mensaje-ready">
                                <textarea name="mensaje" id="text_mensaje_{$medico_detalle.idmedico}" class="form-control flat" placeholder="Mensaje"></textarea>
                                <a href="javascript:;" data-id="{$medico_detalle.idmedico}" class="dp-email btn_msg_profesional pbp-modal-contacto-trigger"></a>
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
    <section class="banner-gestion-cobros">
        <div class="okm-container">
            <div class="okm-row">
                <div class="banner-gestion-cobros-img-holder">
                    <div class="banner-gestion-cobros-card">
                        <figure>
                            <i class="icon-doctorplus-chat"></i>
                        </figure>
                        <div class="banner-gestion-cobros-content">
                            <div class="banner-gestion-cobros-shadow">
                                <div class="banner-gestion-cobros-inner">
                                    <h3>{"¡Aumente su capacidad productiva!"|x_translate}</h3>
                                    <p>{"Controle y capitalice las consultas de sus pacientes fuera de su consultorio a través del servicio de Consulta Express."|x_translate}</p>
                                </div>
                            </div>

                            <div class="banner-gestion-cobros-footer">
                                <p>{"Ud. Atienda la consulta."|x_translate} <br>
                                    {"DoctorPlus se encarga de gestionar su cobro."|x_translate}</p>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </section>

    {literal}
        <script>

            $(function () {


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
                                    var html_cont = "<div class='map-content'><img class='mCS_img_loaded' title='" + value.name + "' alt='" + value.name + "' src='" + NOIMG_SRC + "'><div class='tooltip-usr'>" + value.name + "<br><span>" + value.especialidad + "</span></div><div class='tooltip-address'><i class='icon-doctorplus-map-plus-rounded'></i><p>" + value.direccion + " " + value.numero + "<br>" + value.localidad + ", " + value.provincia + "</p></div></div>";
                                } else {
                                    //contenido del pop up
                                    var html_cont = "<div class='map-content'><img class='mCS_img_loaded' title='" + value.name + "' alt='" + value.name + "' src='" + value.imagen.perfil + "'><div class='tooltip-usr'>" + value.name + "<br><span>" + value.especialidad + "</span></div><div class='tooltip-address'><i class='icon-doctorplus-map-plus-rounded'></i><p>" + value.direccion + " " + value.numero + "<br>" + value.localidad + ", " + value.provincia + "</p></div></div>";
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

                                /* $("#consultorio-" + value.idconsultorio).mouseover(function () {
                                 
                                 if (infowindow) { infowindow.close();}
                                 google.maps.event.trigger(marker, 'click');
                                 marker.setIcon(ICON_RED);
                                 
                                 });*/
                                $(".pbp-consultorio-tabs-content").mouseout(function () {
                                    var id_active = $(".pbp-consultorio-tabs-content .tab-pane.active").attr('id');
                                    if (id_active == "consultorio-" + value.idconsultorio) {

                                        marker.setIcon(ICON_BLUE);
                                    }

                                });

                                $(".pbp-consultorio-tabs-content").mouseover(function () {
                                    var id_active = $(".pbp-consultorio-tabs-content .tab-pane.active").attr('id');
                                    if (id_active == "consultorio-" + value.idconsultorio) {
                                        if (infowindow) {
                                            infowindow.close();
                                        }
                                        google.maps.event.trigger(marker, 'click');
                                        marker.setIcon(ICON_RED);
                                    }

                                });
                                /*   $("#consultorio-" + value.idconsultorio).mouseout(function () {
                                 
                                 marker.setIcon(ICON_BLUE);
                                 });*/

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

    {literal}
        <script>


            $(function () {


                //excedente de lineas de texto subespecialidad
                if ($('.text-cut').length > 0) {
                    textcut('.text-cut', $('.text-cut').data('lines'));
                }

                $(':checkbox').radiocheck();



                $('.pbr-instrucciones-trigger').on('click', function (e) {
                    e.preventDefault();
                    $('#pbr-instrucciones').fadeToggle();
                });

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



                $('.pbn-turnos-slide-holder').on('init', function (slick) {
                    //slickNext

                    $(this).siblings('.pbn-turnos-right-arrow').on('click', function (e) {
                        e.preventDefault();
                        $(this).siblings('.pbn-turnos-slide-holder').slick('slickNext');

                    });

                    $(this).siblings('.pbn-turnos-left-arrow').on('click', function (e) {
                        e.preventDefault();
                        $(this).siblings('.pbn-turnos-slide-holder').slick('slickPrev');

                    });



                });

                $('.pbn-turnos-slide-holder').slick({
                    dots: false,
                    infinite: true,
                    speed: 300,
                    slidesToShow: 1,
                    adaptiveHeight: false,
                    arrows: false
                });

                var altoUl = 230;

                $('#pbn-instrucciones, .pbr-instrucciones-trigger').on('click', function (e) {
                    e.preventDefault();
                    $('#pbr-instrucciones').fadeToggle();
                });

                $('.pbn-map-trigger').on('click', function (e) {
                    e.preventDefault();

                    //		$('html, body').animate({
                    //			scrollTop: $(".pbn-map-holder").offset().top -100
                    //		}, 1000);
                    $('#pbn-map').slideToggle();
                });

                if ($('.pbn-static-btn').length > 0) {

                    var headerHeight = $('#menu').height() + 50;
                    var elepos = $('.pbn-static-btn').offset().top;
                    var topspace = elepos - headerHeight;

                    $(window).on('scroll', function () {
                        var currentTop = $(window).scrollTop();
                        var currentElePos = $('.pbn-static-btn').offset().top;
                        var currentElePosH = $('.pbn-static-btn').offset().left;
                        var btnposV = currentElePos - currentTop;


                        if (currentTop > topspace) {

                            if (!$('.pbn-static-btn').hasClass('rounded')) {

                                $('.pbn-static-btn').addClass('rounded');
                                $('.pbn-static-btn').css({
                                    position: 'fixed',
                                    top: 120,
                                    right: '5%',
                                    'z-index': 9000
                                });

                                $("#pbn-map").css({
                                    position: 'fixed',
                                    top: 104,
                                    left: 0,
                                    width: '100%'
                                });
                            }

                        } else if (currentTop < topspace) {
                            if ($('.pbn-static-btn').hasClass('rounded')) {
                                $('.pbn-static-btn').removeClass('rounded');
                                $('.pbn-static-btn').css({
                                    position: 'relative',
                                    top: 0,
                                    left: 'inherit',
                                    'z-index': 1

                                });
                                $("#pbn-map").css({
                                    position: 'absolute',
                                    top: 0,
                                    left: 0
                                });
                            }
                        }

                    });
                }

                function verMasTexto(trigger, obj, inner, height) {

                    var animateObj = trigger.prev(obj);
                    var innerObj = animateObj.children(inner);

                    var altoIni = height;
                    var altoSlide = innerObj.outerHeight();



                    if (animateObj.outerHeight() <= altoIni) {

                        animateObj.animate({
                            height: altoSlide
                        }, 600);
                        trigger.html('Menos');
                    } else {
                        animateObj.animate({
                            height: altoIni
                        }, 600);
                        trigger.html('Más...');
                    }


                }

                function getHeightText(trigger, obj, inner, height) {

                    $.each(trigger, function (i, val) {

                        var animateObj = $(this).prev(obj);
                        var innerObj = animateObj.children(inner);

                        var altoIni = height;
                        var altoSlide = innerObj.outerHeight();


                        if (altoSlide <= altoIni) {
                            $(this).hide();

                        }

                    });

                }

                /* $(".pbp-prepagas-list").mCustomScrollbar({
                 theme: "dark-3"
                 });*/
                if ($('.pbp-medico-ficha').length > 0) {

                    getHeightText($('.pbp-ver-mas-trigger'), '.pbp-perfil-profesional-expand-text', '.pbp-perfil-profesional-expand-text-inner', 100);

                    $('.pbp-ver-mas-trigger').on('click', function (e) {
                        e.preventDefault();
                        verMasTexto($(this), '.pbp-perfil-profesional-expand-text', '.pbp-perfil-profesional-expand-text-inner', 100);

                    });

                }

                if ($('.map-static-btn').length > 0) {

                    $('.map-static-btn').on('click', function (e) {
                        e.preventDefault();
                        $('#mapa').slideToggle();
                    });
                }

                if ($('.pbp-tarifa-tipo-trigger').length > 0) {

                    $('.pbp-tarifa-tipo-trigger').on('click', function (e) {
                        e.preventDefault();
                        if ($('.pbp-tarifa-tipo-trigger').hasClass('selected')) {
                            $('.pbp-tarifa-tipo-trigger').removeClass('selected');
                        }
                        $(this).addClass('selected');
                        var tipoData = $(this).data('type');

                        $.each($('.pbp-presencial'), function (i, val) {
                            if ($(this).data('src') == tipoData) {
                                if ($(this).hasClass('hidden')) {
                                    $(this).removeClass('hidden');
                                }
                            } else {
                                if (!$(this).hasClass('hidden')) {
                                    $(this).addClass('hidden');
                                }
                            }
                        });
                    });
                }
                function scrollToObj(trgObj) {
                    var trgObjHeight = trgObj.outerHeight();
                    $('html, body').animate({
                        scrollTop: trgObj.offset().top - trgObjHeight
                    }, 1000);
                }

                $('.pbp-turno-trigger').on('click', function (e) {
                    e.preventDefault();
                    var dTarget = $(this).attr('href');
                    scrollToObj($(dTarget));
                });





                var vpw = $(window).width() + getScrollBarWidth();
                if (vpw <= 800) {

                    $('.pbp-card').find('h3').on('click', function (e) {
                        $(this).next('.pbp-card-slide').slideToggle(function () {

                            if ($(this).is(':visible')) {
                                textcut(".pbp-perfil-profesional-expand-text", $(".pbp-perfil-profesional-expand-text").data('linesrsp'));
                            }

                        });
                        $(this).toggleClass('selected');
                    });
                } else {
                    textcut(".pbp-perfil-profesional-expand-text", $(".pbp-perfil-profesional-expand-text").data('lines'));
                }







            });
        </script>

    {/literal}

{else}
    <br>
    <h3 class="text-center">
        {"No se ha encontrado el profesional"|x_translate}
    </h3>
{/if}
