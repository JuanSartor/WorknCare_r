	// JavaScript Document
	
	var MAX = 0;
	var actual_h = 0;
	var actual_w = 0;

	var resize = function(){  
	   
        initScreen(); 
	   	
//		alert("alert");
        if (!$('#colRight')){
            return;
        }
        
		actual_w = $(window).width();
		var left_w = 0;
		/*
		if ($("#colLeft").lenth > 0){
            var left_w = $('#colLeft').width()+60 ;
        }else{
            var left_w = 0;
        }
		*/
		var width_content = actual_w - left_w;


		// Main Content & Sections
		$('#colRight').width(width_content-30 - 225+225); // 230px es el ancho de la columna corrspondiente al menu
		
		$('#Footer').width(width_content-30 - 225+225-20); // REsto 20 porque le agrego padding left y right de 10px;
		// Footer
		//$('#Footer').width(width_content - 35 );
		
		
	}		
		/** Posiciona el Footer
	*/
	var initScreen = function() {
		
        var window_height =  getWinY();
//        window_height -= 170;
        window_height -= 71;
	  
        //var window_height = $(window).height()-250;
	  
		
		$("#Main").css("minHeight", window_height /*- 65*/ + 'px');
		$('#colRight').css("minHeight", window_height  + 'px');	
//		$('#Menu').css("height", window_height /*- 65 */+ 'px');	

	}
