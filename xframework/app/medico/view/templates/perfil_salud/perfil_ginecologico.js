
var unchecked = function(sel1, sel2, sel3) {
    $(sel1).change(function(e) {
        $(sel2).prop('checked', false);
        $(sel3).prop('checked', false);
    });

    $(sel2).change(function(e) {
        $(sel1).prop('checked', false);
        $(sel3).prop('checked', false);
    });

    $(sel3).change(function(e) {
        $(sel2).prop('checked', false);
        $(sel1).prop('checked', false);
    });


};



$(document).ready(function() {
	
	$("ul.slider-menu li a").removeClass("active");
    $("ul.slider-menu li i.dpp-ginecologia").parent().addClass("active");
	// Eventos para check y uncheck 1
	$('#posee_menarca_si').on('change.radiocheck', function() {
		  // Do something
		   
		  if($("#posee_menarca_si").is(':checked')){				
				$('#posee_menarca_no').radiocheck('uncheck');
				$('#menarca').prop("disabled",false);
			}else{
				
			}
	});
	// Eventos para check y uncheck 1
	$('#posee_menarca_no').on('change.radiocheck', function() {
		  // Do something
		   
		  if($("#posee_menarca_no").is(':checked')){				
				$('#posee_menarca_si').radiocheck('uncheck');
                                $('#menarca').val("");
				$('#menarca').prop("disabled",true);
				
			}else{
				
			}
	});
	
	// Eventos para check y uncheck 1
	$('#is_embarazada_si').on('change.radiocheck', function() {
		  // Do something
		   
		  if($("#is_embarazada_si").is(':checked')){				
				$('#is_embarazada_no').radiocheck('uncheck')
				
			}else{
				
			}
	});
	// Eventos para check y uncheck 1
	$('#is_embarazada_no').on('change.radiocheck', function() {
		  // Do something
		   
		  if($("#is_embarazada_no").is(':checked')){				
				$('#is_embarazada_si').radiocheck('uncheck')
				
			}else{
				
			}
	});
	
    $('#inicio-vida-sexual-activa-si').change(function(e) {
        $('#inicio-vida-sexual-activa-no').prop('checked', false);
    });

    $('#inicio-vida-sexual-activa-no').change(function(e) {
        $('#inicio-vida-sexual-activa-si').prop('checked', false);
    });



    if ($("#pap-nunca-ralizo:checked").length == 1) {
        $("#div_pap select").attr("disabled", true);
    } else {
        $("#div_pap select").removeAttr("disabled");
    }

    if ($("#mamografia-nunca-realizo:checked").length == 1) {
        $("#div_mam select").attr("disabled", true);
    } else {
        $("#div_mam select").removeAttr("disabled");
    }


    $("#pap-nunca-ralizo").change(function(e) {
        if ($("#pap-nunca-ralizo:checked").length == 1) {
            $("#div_pap select").attr("disabled", true);
        } else {
            $("#div_pap select").removeAttr("disabled");
        }
    });

    $("#mamografia-nunca-realizo").change(function(e) {
        if ($("#mamografia-nunca-realizo:checked").length == 1) {
            $("#div_mam select").attr("disabled", true);
        } else {
            $("#div_mam select").removeAttr("disabled");
        }
    });


    unchecked("#VPH-si", "#VPH-no", "#VPH-vacuna");


});

var alert_resultado = function(data) {
    x_alert(data.msg);
    if (data.result) {
          actualizar_menu_status_perfilsalud();
        $(".paciente_idpaciente").val(data.id);
    }
};

$("#save_1").click(function() {
    $("#antecedentes_ginecologicos_form1").validate({
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
            
              if ($("#div_menarca_cont input:checked").length == 0) {
                x_alert(x_translate("Debe seleccionar al menos una opcion de menarca"));
                return false;
            }
            
            if ($('#div_inicio_vida_sexual input:checked').length == 0) {
                x_alert(x_translate("Debe seleccionar al menos una opcion de vida sexual activa"));
                return false;
            }

            x_sendForm($('#antecedentes_ginecologicos_form1'), true, alert_resultado);
        }
    });

});

$("#save_2").click(function() {
    $("#antecedentes_ginecologicos_form2").validate({
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
            
            //Controlo de que haya ingresado al menos una VPH
            if($("#check_VPH input[type='radio']:checked").length != 1){
                x_alert(x_translate("Debe completar los campos de VPH"));
                return false;
            }
            
            x_sendForm($('#antecedentes_ginecologicos_form2'), true, alert_resultado);
        }
    });
});

$("#save_3").click(function() {
    $("#antecedentes_ginecologicos_form3").validate({
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
                //Controlo de que haya ingresado al menos una opcion a si se encuentra embarazada
            if($("#is_embarazada input[type='radio']:checked").length != 1){
                x_alert(x_translate("Debe seleccionar al menos una opcion"));
                return false;
            }
            x_sendForm($('#antecedentes_ginecologicos_form3'), true, alert_resultado);
        }
    });
});


