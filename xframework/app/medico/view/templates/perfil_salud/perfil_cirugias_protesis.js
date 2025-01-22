$(document).ready(function () {
    $("ul.slider-menu li a").removeClass("active");
    $("ul.slider-menu li i.dpp-cirugia").parent().addClass("active");
    
    renderUI2("div_cirugias_protesis");


    // Eventos para check y uncheck de cirugias
    $('#check_cirugia_si').on('change.radiocheck', function () {
        // Do something

        if ($("#check_cirugia_si").is(':checked')) {
            $("#div_listado_cirugias").show();
            $("#div_add_cirugia").show();
            $('#check_cirugia_no').radiocheck('uncheck');
        } else {

            $("#div_listado_cirugias").hide();
            $("#div_add_cirugia").hide();
        }
    });
    $('#check_cirugia_no').on('change.radiocheck', function () {
        if ($("#check_cirugia_no").is(':checked')) {
            $("#div_listado_cirugias").hide();
            $("#div_add_cirugia").hide();

            $('#check_cirugia_si').radiocheck('uncheck');
        }
    });

    $("#btnGrabarDatos").click(function () {

        if ($("#check_cirugia_si").is(":checked") && $("#cantidad_cirugias").val() == "0") {
            x_alert(x_translate("Ingrese al menos una cirugia"));
            return false;
        }
        if ($("#check_protesis_si").is(":checked") && $("#cantidad_protesis").val() == "0") {
            x_alert(x_translate("Ingrese al menos una protesis"));
            return false;
        }

        var cirugia = "";
        var protesis = "";
        if ($("#check_cirugia_si").is(":checked")) {
            cirugia = 1;
        }
        if ($("#check_cirugia_no").is(":checked")) {
            cirugia = 0;
        }
        if ($("#check_protesis_si").is(":checked")) {
            protesis = 1;
        }
        if ($("#check_protesis_no").is(":checked")) {
            protesis = 0;
        }

        x_doAjaxCall(
                'POST',
                BASE_PATH + 'posee_cirugias_protesis_m.do',
                "paciente_idpaciente=" + $("#idpaciente").val() + "&idperfilSaludCirugiasProtesis=" + $("#idperfilSaludCirugiasProtesis").val() + "&posee_cirugia=" + cirugia + "&posee_protesis=" + protesis,
                function (data) {
                    actualizar_menu_status_perfilsalud();
                    x_alert(data.msg);
                }
        );
        if ($("#listado_cirugias").val() == 1) {
            if ($("#check_cirugia_si").is(":checked")) {
                $("#health-profile").spin("large");
                x_sendForm(
                        $('#cirugia_modificaciones_form'),
                        true,
                        function (data) {
                               actualizar_menu_status_perfilsalud();
                            $("#health-profile").spin(false);

                        }
                );
            } else {
                //Si no está checkado
                x_doAjaxCall(
                        'POST',
                        BASE_PATH + 'delete_all_cirugias_m.do',
                        'id=' + $("#idpaciente").val(),
                        function (data) {

                            $("#health-profile").spin(false);
                           if (data.result) {
                                window.location.href = "";
                            }
                        }
                );
            }
        }
        if ($("#listado_protesis").val() == 1) {
            if ($("#check_protesis_si").is(":checked")) {
                $("#health-profile").spin("large");
                x_sendForm(
                        $('#protesis_modificaciones_form'),
                        true,
                        function (data) {
                               actualizar_menu_status_perfilsalud();
                            $("#health-profile").spin(false);

                        }
                );
            } else {
                //Si no está checkado
                x_doAjaxCall(
                        'POST',
                        BASE_PATH + 'delete_all_protesis_m.do',
                        'id=' + $("#idpaciente").val(),
                        function (data) {

                            $("#health-profile").spin(false);
                            if (data.result) {
                                window.location.href = "";
                            }
                        }
                );
            }
        }
    });



// Eventos para check y uncheck de protesis
    $('#check_protesis_si').on('change.radiocheck', function () {
        // Do something

        if ($("#check_protesis_si").is(':checked')) {
            $("#div_listado_protesis").show();
            $("#div_add_protesis").show();
            $('#check_protesis_no').radiocheck('uncheck');
        } else {

            $("#div_listado_protesis").hide();
            $("#div_add_protesis").hide();
        }
    });
    $('#check_protesis_no').on('change.radiocheck', function () {
        if ($("#check_protesis_no").is(':checked')) {
            $("#div_listado_protesis").hide();
            $("#div_add_protesis").hide();

            $('#check_protesis_si').radiocheck('uncheck');
        }
    });




    $("#cantidad_cirugias").change(function () {


        if (parseInt($(this).val()) == 0) {
            $("#btnSaveCirugias").hide();
        } else {
            $("#btnSaveCirugias").show();
        }
    });

    $("#cantidad_protesis").change(function () {
        if (parseInt($(this).val()) == 0) {
            $("#btnSaveProtesis").hide();
        } else {
            $("#btnSaveProtesis").show();
        }
    });




    /**
     * 
     * CIRUGÍAS
     */

    if ($("#check_cirugia_si").is(':checked')) {
        $("#div_listado_cirugias").show();
        $("#div_add_cirugia").show();
    } else {
        $("#div_listado_cirugias").hide();
        $("#div_add_cirugia").hide();
    }

    $("#div_listado_cirugias")
            .on('click', '.delete_cirugia', function () {
                delete_cirugia($(this));
            });



    $("#div_listado_cirugias")
            .on('click', '.delete_cirugia', function () {
                delete_cirugia($(this));
            });

    /**
     * Agregar cirugías
     */
    $(".agregar_cirugias").click(function () {
        $("#cirugia_form").empty();

        var valido = true;
        $.each($("#div_add_cirugia").find("input"),
                function (index, value) {
                    $element_input = $(this).clone();
                    if ($element_input.val() != "") {
                        $($element_input).appendTo($("#cirugia_form"));
                    } else {
                        x_alert(x_translate("Todos los campos son obligatorios"));
                        valido = false;
                        $("#cirugia_form").empty();
                        return false;
                    }
                });
        if (valido) {
            $("#div_add_cirugia").spin("large");

            x_sendForm(
                    $('#cirugia_form'),
                    true,
                    function (data) {
                        $("#div_add_cirugia").spin(false);
                        x_alert(data.msg);

                        if (data.result) {
                            str = "<div class=\"row\" id=\"div_row_" + data.entitie.idperfilSaludCirugias + "\">" +
                                    "<div class=\"col-md-3\">" +
                                    "<div class=\"form-group item-multiple\">" +
                                    " <input class=\"input-inline\" type=\"text\" name=\"cirugia\" placeholder=\"Chirurgie\" value=\"" + data.entitie.cirugia + "\" style=\"margin-top:6px\">" +
                                    "</div>" +
                                    "</div>" +
                                    "<input type=\"hidden\" name=\"idperfilSaludCirugias\" value=\"" + data.entitie.idperfilSaludCirugias + "\"/>" +
                                    "<div class=\"col-md-9\">" +
                                    "<div class=\"form-group item-multiple\">" +
                                    "<table class=\"table-responsive\">" +
                                    "<tbody id=\"tbody_" + data.entitie.idperfilSaludCirugias + "\">" +
                                    "<tr>" +
                                    "<td><input class=\"input-inline\"  type=\"text\" placeholder=\"Quand?\" value=\"" + data.entitie.cuando + "\" name=\"cuando[" + data.entitie.idperfilSaludCirugias + "]\"></td>" +
                                    "<td><input class=\"input-inline\"  type=\"text\" placeholder=\"Comment?\" value=\"" + data.entitie.como + "\" name=\"como[" + data.entitie.idperfilSaludCirugias + "]\"></td>" +
                                    "<td><button class=\"dp-trash delete delete_cirugia\" data-id=\"" + data.entitie.idperfilSaludCirugias + "\"></button></td>" +
                                    "</tr>" +
                                    "<tr>" +
                                    "<td><input class=\"input-inline\"  type=\"text\" placeholder=\"Où?\" value=\"" + data.entitie.donde + "\" name=\"donde[" + data.entitie.idperfilSaludCirugias + "]\"></td>" +
                                    "<td><input class=\"input-inline\"  type=\"text\" placeholder=\"Parce que?\" value=\"" + data.entitie.porque + "\" name=\"porque[" + data.entitie.idperfilSaludCirugias + "]\"></td>" +
                                    "<td></td>" +
                                    "</tr>" +
                                    "<tr><td></td><td></td><td></td>" +
                                    "</tr>" +
                                    "</tbody>" +
                                    "</table>" +
                                    "</div>" +
                                    "</div>" +
                                    "</div>";
                            $("#div_listado_cirugias").append(str);

                            $.each($("#div_add_cirugia").find("input").not(":hidden"),
                                    function (index, value) {
                                        $(this).val("");
                                    });

                            $("#cantidad_cirugias").val(parseInt($("#cantidad_cirugias").val()) + 1).trigger('change');
                            ;
                        
                        }
                    }
            );
        } else {
            return false;
        }

    });



    /**
     * 
     * PRÓTESIS
     */


    if ($("#check_protesis_si").is(':checked')) {
        $("#div_listado_protesis").show();
        $("#div_add_protesis").show();
    } else {
        $("#div_add_protesis").hide();
        $("#div_listado_protesis").hide();
    }



    $("#div_listado_protesis")
            .on('click', '.delete_cirugia', function () {
                delete_protesis($(this));
            });



    /**
     * Agregar Protesis
     */
    $(".agregar_protesis").click(function () {
        $("#protesis_form").empty();

        var valido = true;
        $.each($("#div_add_protesis").find("input"),
                function (index, value) {
                    $element_input = $(this).clone();
                    if ($element_input.val() != "") {
                        $($element_input).appendTo($("#protesis_form"));
                    } else {
                        x_alert(x_translate("Todos los campos son obligatorios"));
                        valido = false;
                        $("#protesis_form").empty();
                        return false;
                    }
                });
        if (valido) {
            $("#div_add_protesis").spin("large");

            x_sendForm(
                    $('#protesis_form'),
                    true,
                    function (data) {
                        $("#div_add_protesis").spin(false);
                        x_alert(data.msg);

                        if (data.result) {
                            str = "<div class=\"row\" id=\"div_row_protesis_" + data.entitie.idperfilSaludProtesis + "\">" +
                                    "<div class=\"col-md-9 col-md-offset-3\">" +
                                    "<input type=\"hidden\" name=\"idperfilSaludProtesis\" value=\"" + data.entitie.idperfilSaludProtesis + "\"/>  " +
                                    "<div class=\"form-group item-multiple\">" +
                                    "<table>" +
                                    "<tbody>" +
                                    "<tr>" +
                                    "<td><input class=\"input-inline\" name=\"tipo_aparato[" + data.entitie.idperfilSaludProtesis + "]\" type=\"text\" value=\"" + data.entitie.tipo_aparato + "\" placeholder=\"Type d'appareil\"></td>" +
                                    "<td><input class=\"input-inline\" name=\"desde_cuando[" + data.entitie.idperfilSaludProtesis + "]\" type=\"text\" value=\"" + data.entitie.desde_cuando + "\" placeholder=\"Depuis quand?\"></td>" +
                                    "<td><button data-id=\"" + data.entitie.idperfilSaludProtesis + "\" class=\"dp-trash delete delete_protesis\"></button></td>" +
                                    "</tr>" +
                                    "<tr>" +
                                    "<td></td>" +
                                    "<td></td>" +
                                    "<td></td>" +
                                    "</tr>" +
                                    "</tbody>" +
                                    "</table>" +
                                    "</div>" +
                                    "</div>" +
                                    "</div>";

                            $("#div_listado_protesis").append(str)
                                    .on('click', '.delete_protesis', function () {
                                        delete_protesis($(this));
                                    });

                            $.each($("#div_add_protesis").find("input").not(":hidden"),
                                    function (index, value) {
                                        $(this).val("");
                                    });

                            $("#cantidad_protesis").val(parseInt($("#cantidad_protesis").val()) + 1).trigger("change");
                            
                        
                        }
                    }
            );
        } else {
            return false;
        }

    });


});

/**
 * Eliminación de las prótesis
 * @param {type} element
 * @returns {undefined}
 */
var delete_protesis = function (element) {


    var id = element.data("id");
    var dom_id = "div_row_protesis_" + id;

    jConfirm({
        title: x_translate("Eliminar Prótesis"),
        text: x_translate('Desea eliminar la prótesis?'),
        confirm: function () {
            $("#" + dom_id).spin("large");

            x_doAjaxCall(
                    'POST',
                    BASE_PATH + 'delete_protesis_m.do',
                    'id=' + id,
                    function (data) {
                        x_alert(data.msg);
                        $("#" + dom_id).spin(false);
                        if (data.result) {
                            $("#cantidad_protesis").val(parseInt($("#cantidad_protesis").val()) - 1).trigger('change');
                            ;
                            $("#" + dom_id).remove();
                        }
                    }
            );
        },
        cancel: function () {

        },
        confirmButton: x_translate("Si"),
        cancelButton: x_translate("No")
    });
};


/**
 * Eliminación de las cirugías
 * @param {type} element
 * @returns {undefined}
 */
var delete_cirugia = function (element) {


    var id = element.data("id");
    var dom_id = "div_row_" + id;

    jConfirm({
        title: x_translate("Eliminar Cirugía"),
        text: x_translate('Desea eliminar la cirugía?'),
        confirm: function () {
            $("#" + dom_id).spin("large");

            x_doAjaxCall(
                    'POST',
                    BASE_PATH + 'delete_cirugias_m.do',
                    'id=' + id,
                    function (data) {
                        x_alert(data.msg);
                        $("#" + dom_id).spin(false);
                        if (data.result) {
                            $("#cantidad_cirugias").val(parseInt($("#cantidad_cirugias").val()) - 1).trigger('change');
                            ;
                            $("#" + dom_id).remove();
                        }
                    }
            );
        },
        cancel: function () {

        },
        confirmButton: x_translate("Si"),
        cancelButton: x_translate("No")
    });
};
