x_runJS();

$("#btnGuardar").click(function(){
	var idobraSocial=$("#obraSocial_idobraSocial").val();
	x_sendForm($('#f_record'),true,x_loadModule('maestros_os','maestros_planes_list','obraSocial_idobraSocial='+idobraSocial,'Main'));

});

$("#back").click(function() {
	var idobraSocial=$("#obraSocial_idobraSocial").val();
    x_goTo('maestros_os', 'maestros_planes_list', 'obraSocial_idobraSocial='+idobraSocial, 'Main', this);
});


