x_runJS();


$("#btnGuardar").click(function(){
								
    
        x_sendForm($('#f_record'),true,doAddFromWindow,{'modulo':'maestros_localizacion','submodulo':'localidad_list','params':'pais_idpais='+$("#pais_idpais").val()});
    

});
$("#btnVolver").click(function(){
								
    
      x_goTo('maestros_localizacion','localidad_list','pais_idpais='+$("#pais_idpais").val(),'Main',this);
    

});



