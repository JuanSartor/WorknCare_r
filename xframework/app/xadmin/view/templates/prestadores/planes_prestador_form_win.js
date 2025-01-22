
x_runJS();


$("#back_hs").click(function() {
    hs.close();
});


$("#btnGuardarPlanPrestador").click(function () {
    x_sendForm($('#f_planes_prestador'),true,function(data){
        x_alert(data.msg);
        if(data.result){
            reload_planes_prestador();         
            hs.close();
        }
    });

});





