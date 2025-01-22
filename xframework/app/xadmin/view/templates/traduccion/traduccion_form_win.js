
x_runJS();



$("#back_hs").click(function() {
    hs.close();
});




$("#btnGuardar").click(function () {

   

    x_sendForm($('#f_record'),true,function(data){
        x_alert(data.msg);
        if(data.result){
            reload();
          
            hs.close();
        }
    });

});




