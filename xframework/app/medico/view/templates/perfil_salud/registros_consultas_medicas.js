$("ul.slider-menu li a").removeClass("active");
$("ul.slider-menu li i.dpp-consulta").parent().addClass("active");


$("#btnRegistrosOtrosProfesionales").click(function () {


    $("body").spin("large");
    x_loadModule('perfil_salud', 'registros_otros_profesionales', 'do_reset=1&idpaciente=' + $("#idpaciente").val(), 'div_registros_otros_profesionales', BASE_PATH + "medico").then(function () {
        $("#div_mis_registros_paciente").hide();
        $("#btnRegistrosOtrosProfesionales").hide();
        $("#div_registros_otros_profesionales").show();
        $("#btnMisRegistros").show();
        $("#div_historico_consultas").hide();
    });
});

$("#btnMisRegistros").click(function () {

    $("#div_mis_registros_paciente").show();
    $("#btnRegistrosOtrosProfesionales").show();
    $("#div_registros_otros_profesionales").hide();
    $("#div_historico_consultas").hide();
    $("#btnMisRegistros").hide();
});

$("#btnImpresionPerfilSalud").attr("href", "javascript:;");
$("#btnImpresionPerfilSalud").click(function (e) {
    e.preventDefault();
    $("#modal-imprimir-registros-consultas-medicas").modal("show");

});

$("#btnImprimirResigtroConsultas").click(function () {
    $("#f_imprimir_registro_consultas").submit();
});
//opciones date picker de fechas
$("#datetimepicker1")
        .datetimepicker({
            pickTime: false,
            language: 'fr'
        });
$("#fecha_desde").inputmask("d/m/y");
$("#datetimepicker2")
        .datetimepicker({
            pickTime: false,
            language: 'fr'
        });
$("#fecha_hasta").inputmask("d/m/y");



        