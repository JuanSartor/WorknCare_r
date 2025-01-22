x_runJS();

$(document).ready(function() {
 $("ul.slider-menu li a").removeClass("active");
    $("ul.slider-menu li i.dpp-dna").parent().addClass("active");

    $('.select-box li').on('click', function() {
        $(this).parent('.select-box').find('li').removeClass('active');
        $(this).addClass('active');
    });


    $('.add-items').on('click', function(event) {
        event.preventDefault();

        var id_tipo_familiar = $('#ul_tipo_familiar').find('.active').data("id");
        var tipo_familiar = $('#ul_tipo_familiar').find('.active').text();

        var id_tipo_patologia = $('#ul_tipo_patologia').find('.active').data("id");
        var tipo_patologia = $('#ul_tipo_patologia').find('.active').text();

        if (typeof id_tipo_familiar == "undefined") {
            x_alert(x_translate("Elija tipo familiar"));
            return false;
        } else {
            $("#tipoFamiliar_idtipoFamiliar").val(id_tipo_familiar);
        }

        if (typeof id_tipo_patologia  == "undefined") {
            x_alert(x_translate("Elija tipo patología"));
            return false;
        } else {
            $("#tipoPatologia_idtipoPatologia").val(id_tipo_patologia);
        }


        $("#form_patologia_familiar").spin("large");

        x_sendForm(
                $('#form_patologia_familiar'),
                true,
                function(data) {
                    $("#form_patologia_familiar").spin(false);
                    x_alert(data.msg);
                       actualizar_menu_status_perfilsalud();
                    if (data.result) {
                        $('#antecedentes_tag_input').tagsinput('add', {"value": data.id, "text": tipo_familiar + ' - ' + tipo_patologia});
                  $('#no_antecedentesfamiliares').radiocheck('uncheck');
                  
                    }
                }
        );
    });
    //funcionamiento cuando se checkea "Ningun Patologia"  se borran las cargadas previamente
          $("#no_antecedentesfamiliares").on('change.radiocheck', function () {
              if ($("#no_antecedentesfamiliares").is(':checked')) {
                 //si hay antecedentes cargados
              if($("#antecedentes_tag_input").val()!=""){
                jConfirm({
                title: "",
                text: x_translate('Al seleccionar se eliminarán las patologías cargadas actualmente.'),
                confirm: function() {
                   
                     x_doAjaxCall(
                'POST',
                BASE_PATH + 'no_antecedente_familiar_m.do',
               "paciente_idpaciente="+$("#paciente_idpaciente").val()+ "&idperfilSaludAntecedentes="+$("#idperfilSaludAntecedentes").val(),
                function (data) {
                 
                    if(data.result){
                               x_alert(data.msg,recargar);
                    }else{
                           x_alert(data.msg);
                    }
                    
                }
        );
                },
                cancel: function() {
  $('#no_antecedentesfamiliares').radiocheck('uncheck');
                },
                confirmButton: "Aceptar",
                cancelButton: "Cancelar"
            });
                 }
               //si no hay antecedentes cargados
                  else{
                             x_doAjaxCall(
                'POST',
                BASE_PATH + 'no_antecedente_familiar_m.do',
               "paciente_idpaciente="+$("#paciente_idpaciente").val()+ "&idperfilSaludAntecedentes="+$("#idperfilSaludAntecedentes").val(),
                function (data) {
                   
                    if(data.result){
                                 x_alert(data.msg,recargar);
                    }else{
                           x_alert(data.msg);
                    }
                    
                }
        );
              }
              }
     
    });
    

    $("#btn_antecedentes_1").click(function() {
        var actualice = true;
        if ($("#idperfilSaludAntecedentes").val() != "") {
            actualice = false;
        }



        $("#antecedentes_form_1").validate({
            showErrors: function(errorMap, errorList) {

                // Clean up any tooltips for valid elements
                $.each(this.validElements(), function(index, element) {
                    var $element = $(element);

                    $element.data("title", "") // Clear the title - there is no error associated anymore
                            .removeClass("error")
                            .tooltip("destroy");
                });

                // Create new tooltips for invalid elements
                $.each(errorList, function(index, error) {
                    var $element = $(error.element);

                    $element.tooltip("destroy") // Destroy any pre-existing tooltip so we can repopulate with new tooltip content
                            .data("title", error.message)
                            .addClass("error")
                            .tooltip(); // Create a new tooltip based on the error messsage we just set in the title

                });
            },
            submitHandler: function(form) {
                $("#antecedentes_form_1").val("large");
                x_sendForm(
                        $('#antecedentes_form_1'),
                        true,
                        function(data) {
                            $("#antecedentes_form_1").spin(false);
                           
                            if (data.result) {
                                   actualizar_menu_status_perfilsalud();
                                if (actualice && data.result) {
                                       x_alert(data.msg,recargar);
                                }else{
                                       x_alert(data.msg);
                                }
                            }else{
                                   x_alert(data.msg);
                            }
                        }
                );
            }
        });

    });

    $("#btn_antecedentes_2").click(function() {
        var actualice = true;
        if ($("#idperfilSaludAntecedentes").val() != "") {
            actualice = false;
        }


        $("#antecedentes_form_2").val("large");
        x_sendForm(
                $('#antecedentes_form_2'),
                true,
                function(data) {
                    $("#antecedentes_form_2").spin(false);
                   
                       actualizar_menu_status_perfilsalud();
                    if (actualice && data.result) {
                           x_alert(data.msg,recargar);
                    }else{
                           x_alert(data.msg);
                    }
                }
        );
    });



    $('#is_parto').change(function(e) {
        $('#is_cesarea').prop('checked', false);
    });

    $('#is_cesarea').change(function(e) {
        $('#is_parto').prop('checked', false);
    });
    
    
    
});