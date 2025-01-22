<div class="pbn-map-holder">
    <div class="pbn-map-inner" id="pbn-map" >

        <div id="map_canvas" style="height: 800px; width: 800px; margin:0px auto;"></div>

        <div class="pbn-map-close-btn">
            <a href="javascript:;" class="btn btn-danger pbn-close-map-trigger"><i class="fa fa-times"></i> {"ocultar mapa"|x_translate}</a>
        </div>
    </div>
</div>
<script>
    var NOIMG_SRC = "{$IMGS}extranet/noimage_perfil.png";
    var ICON_RED = "{$IMGS}/icons/ico_pointer_red.png";
    var ICON_BLUE = "{$IMGS}/icons/ico_pointer_blue.png";
    var MOSTRAR_DIRECCION = "1";
</script>
{literal}
    <script>
        $(function () {
            // Atachamos evento al resize del browser
            $(window).resize(function () {

                resize();

                // Add by seba: Disparo un resise sobre el mapa para que se acomode al cambio de tamaño del contendor
                if (mapa_inicializado) {
                    google.maps.event.trigger(map, "resize");
                }
                ajustarMapaBuscador();

            });

            // Inicializamos la pantalla y llamamos a la función resize para que calcule los tamaños
            $(window).load(function () {
                //console.log("LOAD");
                resize();
            });

            /**
             *
             * Funcion que ajusta la ventana del mapa según el scroll y las resoluciones.
             *
             */
            var ajustarMapaBuscador = function () {


                $("#map_canvas").css({
                    width: actual_w,
                    height: actual_h
                });


                // Add by seba: Si estoy  por debajo de la linea de corte del boton
                $("#pbn-map").css({
                    width: actual_w,
                    height: actual_h
                });


                // Add by seba: Actualizo el tamaño de los contenedores en base al tamaño de pantalla
                $("#pbn-map").css({
                    position: 'fixed',
                    top: 104,
                    left: 0,
                    width: actual_w,
                    height: actual_h

                });
                $("#map_canvas").css({
                    width: actual_w,
                    height: actual_h
                });

                // Add by seba: Disparo un resise sobre el mapa para que se acomode al cambio de tamaño del contendor
                if (mapa_inicializado) {
                    google.maps.event.trigger(map, "resize");
                }





            };


            $(window).on('scroll', function () {
                // Add by seba: Disparo el evento AjustarMAPA para inicializar el contenedor de los elementos que se utilizan en el mapa			
                //ajustarMapaBuscador();

            });
            //listener boton mostrar mapa - direccion medico
            $('#modulo_listado_consultorios').on('click', '.pbn-map-trigger', function (e) {
                e.preventDefault();
                // Add by seba: Inicializo el contenedor del mapa
                $("#pbn-map").css({
                    width: $('.okm-container').width(),
                    height: actual_h,
                    position: "fixed",
                    top: 104,
                    left: 0

                });
                $("#map_canvas").css({
                    width: $('.okm-container').width(),
                    height: actual_h
                });
                ajustarMapaBuscador();
                inicializarMapaBuscador($(this).data("idmedico"));


                $('#pbn-map').slideToggle();
            });
            //listener cerrar mapa
            $(".pbn-close-map-trigger").click(function () {
                $('#pbn-map').slideUp();
            });

            var inicializarMapaBuscador = function (idmedico) {


                /**
                 * Map
                 */
                $("body").spin("large");
                $.getJSON(BASE_PATH + 'frontend_2.php?action=1&modulo=google&submodulo=get_coordenadas_medico&idmedico=' + idmedico, {format: "json"}, function (data) {

                    $("body").spin(false);
                    var lng = data.lng;
                    var lat = data.lat;
                    var latlng = new google.maps.LatLng(lat, lng);


                    var myOptions = {
                        zoom: 20,
                        center: latlng,
                        mapTypeId: google.maps.MapTypeId.ROADMAP
                    };


                    //inicializamos el mapa
                    if (!mapa_inicializado) {
                        map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);
                        mapa_inicializado = true;
                    }
                    ajustarMapaBuscador();
                    //cargamos la direccion del medico
                    if (data) {

                        var infowindow = new google.maps.InfoWindow();
                        var bounds = new google.maps.LatLngBounds();
                        $.each(data, function (index, value) {

                            //seteamos el  marcador si tiene direccion
                            if (value.hasOwnProperty('iddireccion')) {

                                var point = new google.maps.LatLng(value.lat, value.lng);
                                //guardo la posicion para centrar
                                bounds.extend(point);

                                if (MOSTRAR_DIRECCION === "1") {
                                    //si no hay foto de medico
                                    if (!value.imagen) {
                                        var img_src = NOIMG_SRC;
                                    } else {
                                        var img_src = value.imagen.perfil;
                                    }
                                    var html_cont = "<div class='map-content'><img class='mCS_img_loaded' title='" + value.name + "' alt='" + value.name + "' src='" + img_src + "'><div class='tooltip-usr'>" + value.name + "<br><span>" + value.especialidad + "</span></div><div class='tooltip-address'><i class='icon-doctorplus-map-plus-rounded'></i><p>" + value.direccion + " " + value.numero + ", " + value.localidad + ", " + value.pais + "</p></div></div>";

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

                                    // Centramos el mapa
                                    map.setZoom(16);
                                } else {
                                    map.setZoom(11);
                                }

                                map.setCenter(point);
                            }
                        });

                    }

                });

            };
        });
    </script>
{/literal}