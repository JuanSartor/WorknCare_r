$(document).ready(function () {

// request para cantidad de pacientes
    var url = BASE_PATH + "xadmin.php?";
    var queryStr = "action=1&modulo=home&submodulo=consultar_cantidad_pacientes";

    x_doAjaxCall("POST",
            url,
            queryStr,
            function (data) {
                cantidadPacientes(data.cantidad);
            },
            "",
            "",
            true,
            true);

// request para cantidad de medicos
    var queryStr = "action=1&modulo=home&submodulo=consultar_cantidad_medicos";

    x_doAjaxCall("POST",
            url,
            queryStr,
            function (data) {
                cantidadMedicos(data.cantidad);
            },
            "",
            "",
            true,
            true);

// request para cantidad de beneficiarios
    var queryStr = "action=1&modulo=home&submodulo=consultar_cantidad_beneficiarios";

    x_doAjaxCall("POST",
            url,
            queryStr,
            function (data) {
                cantidadBeneficiarios(data.cantidad);
            },
            "",
            "",
            true,
            true);

// request para cantidad de empresas
    var queryStr = "action=1&modulo=home&submodulo=consultar_cantidad_empresas";

    x_doAjaxCall("POST",
            url,
            queryStr,
            function (data) {
                cantidadEmpresas(data.cantidad);
            },
            "",
            "",
            true,
            true);





});

function cantidadPacientes(cantidad) {

    document.getElementById('cantPacientes').textContent = cantidad;
}
function cantidadMedicos(cantidad) {

    document.getElementById('cantMedicos').textContent = cantidad;
}
function cantidadBeneficiarios(cantidad) {

    document.getElementById('cantBeneficiarios').textContent = cantidad;
}
function cantidadEmpresas(cantidad) {

    document.getElementById('cantEmpresas').textContent = cantidad;
}

