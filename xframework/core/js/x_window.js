/**
	Funciones para el manejo de ventanas

*/
	
//	var x_win = false;

    /**
     *  Inicializa el hiighslide
     *
     **/                   
    var x_intitHighSlide = function(){    

        hs.graphicsDir = BASE_PATH+'xframework/core/libs/libs_js/highslide/graphics/';
        hs.outlineType = 'draggable-header no-footer no-close';
        hs.allowMultipleInstances = false;
        hs.preserveContent = false;         
/*        hs.outlineType = 'rounded-white'; 
/*        hs.wrapperClassName = 'wide-border'; */
  /*      hs.allowMultipleInstances = false;
        hs.preserveContent = false;     
	    hs.allowSizeReduction = false;*/
	    hs.dimmingOpacity = '0.75';
		
		hs.showCredits = false;
		hs.outlineType = 'custom';
		hs.registerOverlay({
			html: '<div class="closebutton" onclick="return hs.close(this)" title="Close"></div>',
			position: 'top right',
			useOnHtml: true,
			fade: 2 // fading the semi-transparent overlay looks bad in IE
		});
	}
	
	var x_loadWindow = function(link,module,submodule, params, width,height, id_window){


		if (typeof(id_window) == "undefined"){
			id_window = "win_content";	
		}

        hs.close();
        
		var content = 'highslide-html' + id_window
        hs.htmlExpand(link, { contentId: content,width:width,height:height,align:'center' } );
        x_loadModule(module,submodule,params, id_window);                    
    
    }
	
    /**
     *  Opener
     *
     **/              
    var x_open = function(url,winName,features){
        window.open(url,winName,features);
    }
    
    
    var closeWindow = function(){
        hs.close();
    }    
    
  
