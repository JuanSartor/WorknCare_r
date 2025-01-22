x_runJS();


$("#btnGuardar").click(function(){
								
		if ($("#pais_idpais").val() ==""){
			x_alert("Debe seleccionar una pa&iacute;s para la provincia");
		}else{
			x_sendForm($('#f_record'),true,doAddFromWindow,{'modulo':'maestros_localizacion','submodulo':'provincia_list'});	
		}
		

});


