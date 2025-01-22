x_runJS();


$("#btnGuardar").click(function(){

		if ($("#pais_idpais").val() =="" || $("#provincia_idprovincia").val() == "" ){
			x_alert("Debe seleccionar una pa&iacute;s y una provincia para el partido");
		}else{
			x_sendForm($('#f_record'),true,doAddFromWindow,{'modulo':'maestros_localizacion','submodulo':'partido_list'});	
		}
								

});

//acciones de combo

$("#pais_idpais").change(function(){
	updateComboBox(this, 'provincia_idprovincia','ManagerProvincia', 'getComboProvinciasDePais',2);	


})

