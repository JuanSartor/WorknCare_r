$(document).ready(function () {



    var validar_campos_requeridos_step1 = function () {

        //limpiar viejos tooltips
        $.each($("#frmRegistro input"), function (index, element) {
            var $element = $(element);
            $element.tooltip("destroy").removeClass("select-required");
        });

        $.each($("#frmRegistro select"), function (index, element) {
            var $element = $(element);
            $element.tooltip("destroy").removeClass("select-required");
        });

        //validaciones 

        if ($("#nombre_input").val() == "") {
            $("#nombre_input").tooltip("show").addClass("select-required");
            scrollToEl($("#nombre_input"));
            if (!$('#collapseOne').is(":visible")) {
                $('#collapseOne').collapse('show');
            }
            return false;
        }


        if ($("#tipo_animal_input").val() == "") {
            $("#tipo_animal_input").tooltip("show").addClass("select-required");
            scrollToEl($("#tipo_animal_input"));
            if (!$('#collapseOne').is(":visible")) {
                $('#collapseOne').collapse('show');
            }
            return false;
        }


        if ($("#fecha_nacimiento").val().length != 10 || (typeof (validatedate) == "function" && !validatedate($("#fecha_nacimiento").val()))) {
            $("#fecha_nacimiento").tooltip("show").addClass("select-required");
            scrollToEl($("#fecha_nacimiento"));
            if (!$('#collapseOne').is(":visible")) {
                $('#collapseOne').collapse('show');
            }
            return false;
        }

        //validar fecha futura
        var time_actual = new Date().getTime();
        var arr_split = $("#fecha_nacimiento").val().split("/");
        var fecha_nac = new Date(parseInt(arr_split[2]), parseInt(arr_split[1] - 1), parseInt(arr_split[0]));
        if (fecha_nac > time_actual) {
            $("#fecha_nacimiento").data("title", x_translate("La fecha de nacimiento no puede ser futura")).tooltip("show").addClass("select-required");
            $('html, body').animate({
                scrollTop: $("#fecha_nacimiento").offset().top - 200}, 1000);
            return false;
        }


        return true;

    };
    function alert_resultado(data) {
        $("body").spin(false);
        x_alert(data.msg, function () {
            x_doAjaxCall(
                    'POST',
                    BASE_PATH + 'panel-paciente/change_member.do',
                    "requerimiento=" + data.idpaciente,
                    function (data) {
                        if (data.result) {
                            window.location.href = BASE_PATH + "panel-paciente/home.html";
                        } else {
                            scrollToEl($("body"));
                            x_alert(data.msg);
                        }
                    }
            );
        });

    }
    //accion de validar y enviar el formulario para la creacion del miembro de grupo
    $("#btnCrearMascota").click(function () {

        if (validar_campos_requeridos_step1()) {
            $("body").spin("large");
            x_sendForm($('#frmRegistro'), true, alert_resultado);
        }
    });

//alerta al querer redimensionar imagen de perfil - cropper no disponible
    $("#a_img_cropper").click(function () {
        x_alert(x_translate("ATENCIÓN: La imagen que usted ha subido se encuentra cargada en forma temporal. Las funciones de edición están deshabilitadas. Tras la creación del miembro de grupo familiar, usted podrá modificar, recortar y rotar la misma haciendo click sobre la imagen."));
    });

    //inicializar mascara fecha nac
    $('#fecha_nacimiento').mask("00/00/0000", {placeholder: "jj/mm/aaaa"});

    //Privacidad del paciente

    /*Accion eliminar archivo subido - tarjetas identificacion*/
    $(".btn-delete-file").click(function () {
        var hash = $(this).data("hash");
        var name = $(this).data("name");
        var tipo = $(this).data("tipo");
        var $btn = $(this);
        $("body").spin("large");
        x_doAjaxCall(
                'POST',
                BASE_PATH + 'common.php?action=1&modulo=upload&submodulo=upload_gen',
                "delete=1&hash=" + hash + "&name=" + name,
                function (data) {
                    $("body").spin(false);
                    if (data.result) {
                        $btn.closest(".upload-filename").hide();
                        $(".cont-imagen." + tipo).hide();
                    } else {
                        x_alert(data.msg);
                    }

                }
        );
    });

});


