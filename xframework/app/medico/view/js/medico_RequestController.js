
function initializeMap(params) {

    if (typeof (params.coords) != "undefined") {


        var latlng = new google.maps.LatLng(params.coords.lat, params.coords.lng);

        var myOptions = {
            zoom: 16,
            center: latlng,
            mapTypeId: google.maps.MapTypeId.ROADMAP
        };

        map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);

        var marker = new google.maps.Marker({
            position: latlng,
            map: map,
            draggable: true,
            title: ""
        });

        google.maps.event.addListener(marker, 'dragend', function () {

            $("#lat").val(marker.getPosition().lat());
            $("#lng").val(marker.getPosition().lng());
        })


    } else {


        var address = params.address;

        geocoder = new google.maps.Geocoder();

        geocoder.geocode({'address': address}, function (results, status) {



            if (status == google.maps.GeocoderStatus.OK) {


                latlng = results[0].geometry.location;
                var myOptions = {
                    zoom: 16,
                    center: latlng,
                    mapTypeId: google.maps.MapTypeId.ROADMAP
                };

                map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);
                var marker = new google.maps.Marker({
                    position: latlng,
                    map: map,
                    draggable: true,
                    title: ""
                });

            } else {




                latlng = new google.maps.LatLng(-31.6323891, -60.6994591);
                var myOptions = {
                    zoom: 16,
                    center: latlng,
                    mapTypeId: google.maps.MapTypeId.ROADMAP
                };

                map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);

                var marker = new google.maps.Marker({
                    position: latlng,
                    map: map,
                    draggable: true,
                    title: ""
                });
            }


            google.maps.event.addListener(marker, 'dragend', function () {

                console.debug("aaahaha");

                $("#lat").val(marker.getPosition().lat());
                $("#lng").val(marker.getPosition().lng());
            })



        });

    }
}


function initializeStaticMap(params) {

    if (typeof (params.coords) != "undefined") {


        var latlng = new google.maps.LatLng(params.coords.lat, params.coords.lng);

        var myOptions = {
            zoom: 16,
            center: latlng,
            mapTypeId: google.maps.MapTypeId.ROADMAP
        };

        map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);

        var marker = new google.maps.Marker({
            position: latlng,
            map: map,
            draggable: false,
            title: ""
        });


    } else {


        var address = params.address;

        geocoder = new google.maps.Geocoder();

        geocoder.geocode({'address': address}, function (results, status) {



            if (status == google.maps.GeocoderStatus.OK) {


                latlng = results[0].geometry.location;
                var myOptions = {
                    zoom: 16,
                    center: latlng,
                    mapTypeId: google.maps.MapTypeId.ROADMAP
                };

                map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);
                var marker = new google.maps.Marker({
                    position: latlng,
                    map: map,
                    draggable: false,
                    title: ""
                });

            } else {




                latlng = new google.maps.LatLng(-31.6323891, -60.6994591);
                var myOptions = {
                    zoom: 16,
                    center: latlng,
                    mapTypeId: google.maps.MapTypeId.ROADMAP
                };

                map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);

                var marker = new google.maps.Marker({
                    position: latlng,
                    map: map,
                    draggable: false,
                    title: ""
                });
            }


        });

    }
}


/**
 * @author Sebastian Balestrini <sbalestrini@gmail.com>
 *
 * Cierra la sesión de xadmin
 */
var x_LogOut = function () {

    $.alert({
        icon: 'fa fa-warning',
        title: 'D&eacute;connexion',
        content: 'Souhaitez-vous fermer votre session?',
        theme: 'supervan',
        buttons: {
            tryAgain: {
                text: 'Non',
                btnClass: 'btn-green',
                action: function () {
                }
            },
            close: {
                text: 'Oui',
                btnClass: 'btn-red',
                action: function () {
                    $("body").spin("large");
                    x_doAjaxCall(
                            'POST',
                            BASE_PATH + 'medico.php?action=1&modulo=login&submodulo=logout',
                            '',
                            x_doLogOut
                            );
                }
            }
        }
    });


};

var x_doLogOut = function (json) {
    //limpiamos storage
    sessionStorage.clear();
    if (json.hasOwnProperty("location")) {
        window.location.href = json.location;
    } else {
        window.location.href = BASE_PATH;
    }

};


	   