<div id="mapa" class="pbp-map-card ">
    <div class="google-maps">
        <div id="map_canvas" style="height: 300px; width: 100%; margin:0px auto;"></div>
        <input type="hidden" id="ids_consultorio_resultado" value="{$id_consultorios}"/>
    </div>
</div>
<script>
    var NOIMG_SRC = "{$IMGS}extranet/noimage_perfil.png";
    var ICON_RED = "{$IMGS}/icons/ico_pointer_red.png";
    var ICON_BLUE = "{$IMGS}/icons/ico_pointer_blue.png";
    var MOSTRAR_DIRECCION = "{$medico.direccion.mostrar_direccion}";
</script>
{literal}
    <script>

        var scroll_consultorio = function (id) {
            $('html, body').animate({scrollTop: $("#modulo_listado_consultorios").offset().top - 200}, 1000);
        };

        $(function () {
            $.getJSON(BASE_PATH + 'paciente_p.php?action=1&modulo=google&submodulo=get_coordenadas_medico&idmedico=' + $("#idmedico").val(), {format: "json"}, function (data) {
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

                //cargamos la direccion del medico
                if (data) {

                    var infowindow = new google.maps.InfoWindow();
                    var bounds = new google.maps.LatLngBounds();
                    $.each(data, function (index, value) {

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

                    //autocentrado                                             
                    //map.fitBounds(bounds);
                    //map.panToBounds(bounds);

                }




            });



        });
    </script>
{/literal}
