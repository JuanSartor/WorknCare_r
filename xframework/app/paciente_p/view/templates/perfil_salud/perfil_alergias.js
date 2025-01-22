$(document).ready(function () {
    $("ul.slider-menu li a").removeClass("active");
    $("ul.slider-menu li i.dpp-alergia").parent().addClass("active");
    //x_runJS();

    $('[data-toggle="tooltip"]').tooltip();

   // Inicialización de los checks 1
    if ($("#posee_intolerancia_si").is(':checked')) {
        $("#div_row_listado_alergias").show();
        $("#div_anafilaxia").show();
         $("#div_causa_intolerancia").show();
    } else {
        $("#div_row_listado_alergias").hide();
        $("#div_anafilaxia").hide();
        $("#div_causa_intolerancia").hide();
    }




    // Eventos para check y uncheck 1
  $('#posee_intolerancia_si').on('change.radiocheck', function () {
        // Do something

        if ($("#posee_intolerancia_si").is(':checked')) {
            $("#div_row_listado_alergias").show();
            $("#div_anafilaxia").show();
            $('#posee_intolerancia_no').radiocheck('uncheck');
            $("#div_causa_intolerancia").show();

        } else {
            $("#div_row_listado_alergias").hide();
            $("#div_anafilaxia").hide();
            $("#div_causa_intolerancia").hide();
            $("#div_causas_intolerancias").hide();
            $('#posee_causa_intolerancia_si').radiocheck('uncheck');
            $('#posee_causa_intolerancia_no').radiocheck('uncheck');
            $("#div_causas_intolerancias :checkbox").radiocheck("uncheck");

        }
    });
      $('#posee_intolerancia_no').on('change.radiocheck', function () {
        if ($("#posee_intolerancia_no").is(':checked')) {
            $('#posee_intolerancia_si').radiocheck('uncheck');
            $("#div_row_listado_alergias").hide();
            $("#div_anafilaxia").hide();
            $("#div_causa_intolerancia").hide();
            $("#div_row_listado_alergias :checkbox").radiocheck("uncheck");
            $("#div_row_listado_alergias :input[type=text]").val("");
            $("#div_causas_intolerancias").hide();
            $("#div_causas_intolerancias :checkbox").radiocheck("uncheck");
        }
    });


    // Inicialización de los checks 2
    if ($("#posee_causa_intolerancia_si").is(':checked')) {
        $("#div_causas_intolerancias").show();
    } else {
        $("#div_causas_intolerancias").hide();
    }

    // Eventos de los checks 2
    $('#posee_causa_intolerancia_si').on('change.radiocheck', function () {
        // Do something

        if ($("#posee_causa_intolerancia_si").is(':checked')) {
            $("#div_causas_intolerancias").show();
            $('#posee_causa_intolerancia_no').radiocheck('uncheck');
        } else {
            $("#div_causas_intolerancias").hide();
        }
    });
    $('#posee_causa_intolerancia_no').on('change.radiocheck', function () {
        if ($("#posee_causa_intolerancia_no").is(':checked')) {
            $("#div_causas_intolerancias :checkbox").radiocheck("uncheck");
            $('#posee_causa_intolerancia_si').radiocheck('uncheck');
            
        } 

        $("#div_causas_intolerancias :checkbox:checked").radiocheck('uncheck');
        $("#div_causas_intolerancias :input:text").val("");
    });

    //clickeamos los check de al empezar a escribir
    $("input[data-action='check-si']").on("keypress", function () {
        id = $(this).data('target');
        if ($(this).val() == "") {
            $("#" + id).prop("checked", false);
        }
        else {
            $("#" + id).prop("checked", true);
        }
    }
    );

    //limpiamos el texto de "otros" cuando se deshabilita el checkbox
    $(":checkbox[data-action='clean-val']").click(function () {

        if ($(this).prop("checked") == false) {
            id = $(this).data("target");
            $("#" + id).val("");
        }
    });




//    renderUI2("section_perfil_alergias");
    /*$('#posee_causa_intolerancia_switch').bootstrapSwitch('onText', 'SI');
     $('#posee_causa_intolerancia_switch').bootstrapSwitch('offText', 'NO');
     
     
     $('#posee_intolerancia_switch').bootstrapSwitch('onText', 'SI');
     $('#posee_intolerancia_switch').bootstrapSwitch('offText', 'NO');
     
     $('#posee_intolerancia_switch').on('switchChange.bootstrapSwitch', function(event, state) {
     if(state){
     $("#div_row_listado_alergias").show();
     $("#div_anafilaxia").show();
     }else{
     $("#div_row_listado_alergias").hide();
     $("#div_anafilaxia").hide();
     }
     });
     
     $('#posee_causa_intolerancia_switch').on('switchChange.bootstrapSwitch', function(event, state) {
     if(state){
     $("#div_causas_intolerancias").show();
     }else{
     $("#div_causas_intolerancias").hide();
     }
     });
     */

    $("#save").click(function () {

        //validamos que se haya ingresado al menos una opcion 
        if ($("#posee_intolerancia_si").prop("checked") && $("#anafilaxia").prop("checked") == false && $("#div_row_listado_alergias :checkbox:checked").length == 0) {
        
            x_alert(x_translate("Seleccione al menos una alergia o intolerancia"));
            return false;
        }

        if ($("#posee_causa_intolerancia_si").prop("checked") && $("#div_causas_intolerancias :checkbox:checked").length == 0) {
                           x_alert(x_translate("Ingrese al menos un agente que produce su alergia o intolerancia"));
            return false;
        }

        x_sendForm($('#alergias_form'),
                true,
                function (data) {
               x_alert(data.msg);
                   actualizar_menu_status_perfilsalud();
                    if (data.result) {
                        
                        $(".modal.fade.in:visible").modal('toggle');
                       
                    }
                });
            
        
    });
});
