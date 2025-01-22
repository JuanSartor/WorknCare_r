

$("#div_date_picker")
        .datetimepicker({
            pickTime: false,
            language: 'fr'
        });


x_runJS();



function submitForm() {

    $("#consulta_form").validate({
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
            x_sendForm($('#consulta_form'), true, function(data) {
                x_alert(data.msg);
                if (data.result) {
                    x_loadModule('perfil_salud', 'consulta', 'id=' + $("#idpaciente").val() + "&idperfilSaludConsulta=" + data.id, "Main", BASE_PATH + "medico");
                }
            });
        }
    });
}

$("#btnSaveAnotacion").click(function() {
    x_sendForm($('#anotacion_form'), true, function(data) {
        if (data.result) {
            $("#anotaciones").modal('hide');
            //x_loadModule('perfil_salud', 'consulta', 'id=' + $("#idpaciente").val() + "&idperfilSaludConsulta=" + data.id, "Main", BASE_PATH + "medico");
            $("#anotacion").val($("#anotacion_win").val());
        }
    });
});