x_runJS();


$("#btnGuardar").click(function(){
								

		x_sendForm($('#f_record'),true,doAddFromWindow,{'modulo':'maestros_localizacion','submodulo':'pais_list'});

});


