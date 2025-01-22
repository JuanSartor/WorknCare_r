x_runJS();
$("#back_hs").click(function() {
    hs.close();
});

$("#btnGuardar").click(function() {


    x_sendForm(
            $('#f_record_pdf'),
            true,
            function(data) {
                x_alert(data.msg);
                if (data.result) {
                    hs.close();
                    reload();
                }
            }
    );

});