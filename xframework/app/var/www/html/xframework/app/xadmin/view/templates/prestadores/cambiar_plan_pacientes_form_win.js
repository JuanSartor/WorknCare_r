
x_runJS();



$("#back_hs").click(function() {
    hs.close();
});




$("#btnCambiarPlan").click(function () {



if($("#list_paciente").jqGrid('getGridParam', 'selarrrow')==""){
    x_alert("Seleccione al menos un paciente");
    return false;
}
if($("#plan_prestador_idplan_prestador").val()==""){
    x_alert("Seleccione el plan a asignar a el/los paciente/s");
    return false;
}

$("#ids_paciente").val($("#list_paciente").jqGrid('getGridParam', 'selarrrow'));
    x_sendForm($('#f_cambiar_plan'),true,function(data){
        x_alert(data.msg);
        if(data.result){
            reload_pacientes_prestador();
          
            hs.close();
        }
    });

});




