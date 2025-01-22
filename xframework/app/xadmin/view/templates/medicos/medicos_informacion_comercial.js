x_runJS();
$("#modulo").val("medicos");
$("#submodulo").val("medicos_informacion_comercial");

$("#btnGuardar").click(function() {
    
    
    x_sendForm(
            $('#f_record'),
            true,
            x_loadModule('medicos', 'medicos_generica_list', '', 'Main')
            );

});

$("#back").click(function() {
    x_goTo('medicos', 'medicos_generica_list', '', 'Main', this);
});
