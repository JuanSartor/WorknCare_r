

<script language="javascript" type="text/javascript" >
	//Variable que contendr todos los WIDGETS en cada uno de los Formularios
	//inicializacion de hisgslide
	$(document).ready(function(){
		
		$(window).bind('hashchange', function(e) {  
			var url = $.param.fragment();  
			//console.debug(url)  ;
			
			if (url){
				//console.debug( Base64.decode( bookmarks.getHash(url)));
				bookmarks.checkhash();
			}
			
		}); 
		
		$(window).trigger( 'hashchange' );  
		
		bookmarks.initialize();

		x_intitHighSlide();
		
		$(window).resize(function() {
			resize();
		});
		
		$(window).load(function() {
			resize();
		});
		
		{if $allowed}
			x_loadModule('x_menu','x_menu','','xmnu');
		{/if}
		
		
		// Para hacer bind de la barra de menu si socrresponde.
		var num = 30; //number of pixels before modifying styles
		$(window).bind('scroll', function () {
			//alert($(window).scrollTop());
			if ($(window).scrollTop() > num) {
				$('.title_bar').addClass('xFixed');
				
			} else {
				$('.title_bar').removeClass('xFixed');
			}
		});
		
		//  Cerrar sesion
		$("#logout").click(x_LogOut);		
		$("#perfil").click(function(){
		
			x_goTo('usuarios','miperfil','','Main');
		});
		
				
	})

</script>