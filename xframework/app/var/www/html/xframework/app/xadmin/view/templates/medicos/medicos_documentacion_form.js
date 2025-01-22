x_runJS();
$("#back_hs").click(function() {
    hs.close();
});

$("#btnGuardarDoc").click(function() {
if($("#descripcion_input").val()==""){
    x_alert("Ingrese la descricpión de la documentación");
        return false;
}
if($(".dz-preview.dz-complete").length==0){
     x_alert("Seleccione al menos un archivo");
        return false;
}
    x_sendForm(
            $('#f_documentacion'),
            true,
            function(data) {
                x_alert(data.msg);
                if (data.result) {
                    hs.close();
                    
                    x_loadModule('medicos','medicos_documentacion_list','id=' + $("#idmedicoWin").val() ,'div_listado_documentacion');

                    
                }
            }
    );

});






                    
