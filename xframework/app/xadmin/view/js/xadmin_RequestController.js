/******************************************************************************
 *
 *  Funciones personalizadas para el controlador xadmin
 *
 *
 ******************************************************************************/


	function initializeMap(params) {
		
		

	   if (typeof (params.coords) != "undefined" ){
		   
			 
            var latlng = new google.maps.LatLng(params.coords.lat,params.coords.lng);

            var myOptions = {
            	zoom: 16,
            	center: latlng,
            	mapTypeId: google.maps.MapTypeId.ROADMAP
            };	
            
            map = new google.maps.Map(document.getElementById("map_canvas") ,myOptions);
            
            var marker = new google.maps.Marker({
              position: latlng,
              map: map,
              draggable:true,
              title:""
            });
			
			$("#lat_search").val(marker.getPosition().lat()); 
			$("#lng_search").val(marker.getPosition().lng()); 
			
			

            google.maps.event.addListener(marker, 'dragend', function() {                                      
                
                $("#lat_search").val(marker.getPosition().lat()); 
				$("#lng_search").val(marker.getPosition().lng());                 
            })                     
        
       
       }else{
       
        
            var address = params.address;		
    		
    		geocoder = new google.maps.Geocoder();    	           
           
        	geocoder.geocode( { 'address': address}, function(results, status) {
    			
                
                
                if (status == google.maps.GeocoderStatus.OK) {
                  
                    
    				latlng = results[0].geometry.location;
    				var myOptions = {
    					zoom: 16,
    					center: latlng,
    					mapTypeId: google.maps.MapTypeId.ROADMAP
    				};	
    		
    				map = new google.maps.Map(document.getElementById("map_canvas"),myOptions);
    				 var marker = new google.maps.Marker({
    					  position: latlng,
    					  map: map,
    					  draggable:true, 
    					  title:""
    				  });
					  	$("#lat_search").val(marker.getPosition().lat()); 
    					$("#lng_search").val(marker.getPosition().lng()); 
					  
					  
    			  } else {
    				
                  
                    
                    
                    latlng = new google.maps.LatLng(-31.6323891,-60.6994591);	
    				var myOptions = {
    					zoom: 16,
    					center: latlng,
    					mapTypeId: google.maps.MapTypeId.ROADMAP
    				};	
    				
    				map = new google.maps.Map(document.getElementById("map_canvas"),myOptions);			
    				
                    var marker = new google.maps.Marker({
    					  position: latlng,
    					  map: map,
    					  draggable:true,
    					  title:""
    				  });
    			  }
    			  
				$("#lat_search").val(marker.getPosition().lat()); 
    			$("#lng_search").val(marker.getPosition().lng()); 
						
    
                 google.maps.event.addListener(marker, 'dragend', function() {                                      
                   
                    
                    $("#lat_searcg").val(marker.getPosition().lat()); 
    				$("#lng_searcg").val(marker.getPosition().lng());                 
                })  
    
    			  
    			  
    		});
    		
        }    		
	}
            
			
			
	function searchInMap() {
		

			
			var address = $("#direccion_gmaps_input").val();
			    		
    		geocoder = new google.maps.Geocoder();    	           
           
        	geocoder.geocode( { 'address': address}, function(results, status) {
    			
                
                
                if (status == google.maps.GeocoderStatus.OK) {
                  
                    
    				latlng = results[0].geometry.location;
    				var myOptions = {
    					zoom: 16,
    					center: latlng,
    					mapTypeId: google.maps.MapTypeId.ROADMAP
    				};	
    		
    				map = new google.maps.Map(document.getElementById("map_canvas"),myOptions);
    				var marker = new google.maps.Marker({
    					  position: latlng,
    					  map: map,
    					  draggable:true, 
    					  title:""
    				});
					  
					$("#lat_search").val(marker.getPosition().lat()); 
    				$("#lng_search").val(marker.getPosition().lng()); 
					  
					  
    		
    			  } 
    
                 google.maps.event.addListener(marker, 'dragend', function() {                                      
                   
                    
                    $("#lat_search").val(marker.getPosition().lat()); 
    				$("#lng_search").val(marker.getPosition().lng());                 
                })  
    
    			  
    			  
    		});
    		
    		
	}


	function saveSearchCoords() {
		
		var params = $.extend({pregunta:"Desea copiar las coordenadas de b&uacute;squeda al registro?",titulo:"Copiar Coordenadas"},params);
		
		jConfirm(
			params.pregunta, 
			params.titulo, 
			function(r) {
				if (r){
					
					 $("#lat").val($("#lat_search").val()); 
					 $("#lng").val($("#lng_search").val()); 
					
				}
			}
		);
		
	}
			

