

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

        google.maps.event.addListener(marker, 'dragend', function() {

            $("#lat").val(marker.getPosition().lat());
            $("#lng").val(marker.getPosition().lng());
        })


    } else {


        var address = params.address;

        geocoder = new google.maps.Geocoder();

        geocoder.geocode({'address': address}, function(results, status) {



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


            google.maps.event.addListener(marker, 'dragend', function() {

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

        geocoder.geocode({'address': address}, function(results, status) {



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
var x_LogOut = function() {

	
		$.alert({
			icon: 'fa fa-warning',
			title: 'Salir',
			content: 'Desea cerrar la sesión?',
			theme: 'supervan',
			buttons: {
				tryAgain: {
					text: 'No',
					btnClass: 'btn-green',
					action: function(){
					}
				},
				close: {
					text: 'Si',
					btnClass: 'btn-red',
					action: function(){
					}
				}
			}
		});
	
};

var x_doLogOut = function(json) {

    window.location.href =   json.location;

};
	   

	
