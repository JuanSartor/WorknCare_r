$(document).ready(function () {
    //x_runJS();


    renderUI2("busqueda_profesional");
    //desmarcamos los programas que no son ofrecidos por la empresa
    if (ids_excepciones_programa !== "") {

        if (ids_excepciones_programa !== "ALL") {
            ids_excepciones_programa.split(',').forEach(function (id) {
                $(".programa-destacado-tag[data-id=" + id + "]").addClass("hide");
            });
            $(".programa-destacado-tag:not(.hide)").show();
        } else {
            $(".programa-destacado-tag").show();
        }
    }
    //marcamos el programa o categoria seleccionado
    $(".select-programa").click(function (e) {
        e.preventDefault();
        e.stopPropagation();
        let idprograma = $(this).data("idprograma");
        $(".select-programa").not("[data-idprograma=" + idprograma + "]").removeClass("open");
        $(this).toggleClass("open");
    });
    //marcamos el programa o categoria seleccionado
    $(".select-categoria").click(function (e) {
        e.preventDefault();

        $(".item-seleccionado").html("");
        $("#idprograma_categoria").val("");
        $("#idprograma_salud").val("");
        if ($(this).data("idprograma") != "") {
            let idprograma = $(this).data("idprograma");
            $(".item-seleccionado").append($(".nombre-programa[data-idprograma=" + idprograma + "]").clone());
            $("#idprograma_salud").val(idprograma);
        }
        if ($(this).data("idcategoria") != "") {
            let idcategoria = $(this).data("idcategoria");
            $(".item-seleccionado").append($(".nombre-categoria[data-idcategoria=" + idcategoria + "]").clone());
            $("#idprograma_categoria").val(idcategoria);
        }

        $(".label-default").hide();
        $(".item-seleccionado").show();
    });

    $(':checkbox').radiocheck();

    $("#pbr-btn-advanced-search").on('click', function (e) {
        e.preventDefault();
        $('#pbr-advanced-search').slideToggle();
        $("#btn_buscar_1").hide();
        $("#pbr-btn-advanced-search").hide();
    });

    $("#pbr-cancel-advanced-search").on('click', function (e) {
        e.preventDefault();
        $('#pbr-advanced-search').slideToggle();
        $("#btn_buscar_1").show();
        $("#pbr-btn-advanced-search").show();
    });




    if ($("#pais_ti").val() == "1") {
        $("#row_sector").slideDown();
    } else {
        $("#row_sector").slideUp();
    }

    $("#pais_ti").change(function () {

        if ($("#pais_ti").val() == "1") {

            $("#row_sector").slideDown();

        } else {
            $("#row_sector").slideUp();
        }
    });


    $("#btn_buscar_1, #btn_buscar_2").click(function () {
        //REalizo validaciones
        if ($("#especialidad_ti").val() == "" && $("#medico_ti").val() == "" && $("#idprograma_salud").val() == "") {
            x_alert(x_translate("Ingrese al menos un parámetro de búsqueda de profesionales"));
            return false;
        }


        $("#f_busqueda_profesionales").submit();
    });



});