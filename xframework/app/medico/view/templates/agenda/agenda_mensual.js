$(document).ready(function () {
    $(':radio').radiocheck();
//cargar agenda mes anterior
    $("#a_get_dia_previous_month").click(function () {
        var fecha = $("#dia_agenda").val();
        $(this).off();
        $("#agenda_mensual_medico").spin("large");
        x_loadModule('agenda', 'agenda_mensual', 'previous=1&fecha=' + fecha + '&idconsultorio=' + $("#idconsultorio").val(), 'agenda_mensual_medico');
    });
//cargar agenda proximo mes
    $("#a_get_dia_next_month").click(function () {
        var fecha = $("#dia_agenda").val();
        $(this).off();
        $("#agenda_mensual_medico").spin("large");
        x_loadModule('agenda', 'agenda_mensual', 'next=1&fecha=' + fecha + '&idconsultorio=' + $("#idconsultorio").val(), 'agenda_mensual_medico');
    });

//seleccionar consultorio y cargar agenda de ese consultorio
    $("a.select-consultorio").on("click", (function () {

        var fecha = $("#dia_agenda").val();
       
        $(this).off();
        $("#agenda_mensual_medico").spin("large");
        x_loadModule('agenda', 'agenda_mensual', 'fecha=' + fecha + '&idconsultorio=' + $(this).data("id"), 'agenda_mensual_medico');
    }));
    
    
    
  


});

