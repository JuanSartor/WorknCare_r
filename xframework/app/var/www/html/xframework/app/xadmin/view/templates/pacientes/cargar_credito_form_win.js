x_runJS();
$("#back_hs").click(function() {
    hs.close();
});

$("#btnGuardarCredito").click(function() {


    x_sendForm(
            $('#f_cargar_credito'),
            true,
            function(data) {
                x_alert(data.msg);
                if (data.result) {
                    hs.close();
                   
                }
            }
    );

});