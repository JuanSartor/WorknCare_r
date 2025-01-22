$(function () {
//listener seleccionar plan
    $(".btn-suscribir").click(function () {
        $("#btnVolverPlanes").hide();
        var id = $(this).data("id");
        console.log("plan:" + id);
        var tipo = $(this).data("tipo");
        console.log("tipo:" + tipo);
        var costo_plan = $(this).data("costo_plan");
        console.log("costo_plan:" + costo_plan);
        // detecto si es un plan gratuito o no
        if (id == '21' || id == '23') {
            $("#packPago").hide();
            $("#packFree").show();
            $("#pack500").hide();
        } else {
            $("#packFree").hide();
        }
        if (id == '22') {
            $("#planPago").hide();
            $("#planFree").show();
        } else {
            $("#planFree").hide();
        }
        $("#plan_idplan").val(id);
        $("#tipo_plan").val(tipo);
        $("#costo_plan").val(costo_plan);
        // si el plan es el 20 el 500 enterprise entonces se inicia con 500
        if (id == 20) {
            $("#cant_empleados").val(500);
        } else {
            $("#cant_empleados").val(1);
        }

        if (id == 21 || id == 22 || id == 23) {
            $(".adhesion-input").hide();
            $(".cupon-input").hide();
        }

//mostramos los campos que requeridos para empreas/OS en el formulario
        toggle_campos_visibles(tipo);
        $(".item-plan").removeClass("selected");
        $(this).addClass("selected");
        $(".planes-wrapper").hide();
        scrollToEl($("body"));
        $(".form-wrapper").fadeIn();
    });
//listener botones para mostrar  planes de empresa/obras sociales
    $("#oferta-empresas,#oferta-obras-sociales").click(function () {
        $(".btn-switch-planes").removeClass("active");
        $(this).addClass("active");
        let target = $(".btn-switch-planes.active").data("target");
        //mostramos los planes correspondientes
        $(".listado-planes").hide();
        $("#" + target + "-list").show();
        //mostramos el header correspondiente
        $(".header-title").hide();
        $(".header-title." + target).show();
        $("#packFree").hide();
        $("#planFree").hide();
    });
    // esto surjio despues para un pack de minimo 500
    $("#oferta-empresa-500").click(function () {
        $(".btn-switch-planes").removeClass("active");
        $(this).addClass("active");
        let target = $(".btn-switch-planes.active").data("target");
        //mostramos los planes correspondientes
        $(".listado-planes").hide();
        $("#" + target + "-list").show();
        //mostramos el header correspondiente
        $(".header-title").hide();
        $(".header-title." + target).show();
    });
    //metodo que muestra/oculta los campos visibles segun  el tipo de plan/pack a contratar
    var toggle_campos_visibles = function (tipo) {
        console.log("toggle_campos_visibles", tipo);
        //campos visibles para packs de OS
        console.log($("#costo_plan").val());
        if (tipo === "pack") {

            //calculamos el costo total de los packs de Obra Social= precio * cantidad
            console.log("costoplan", parseInt($("#costo_plan").val()));
            console.log("cant pack", parseInt($("#cant_empleados").val()));
            $(".precio-total-pack").html("€" + parseInt($("#costo_plan").val()) * parseInt($("#cant_empleados").val()));
            $("#tipo_cuenta_empresa").radiocheck("check");
            $("#tipo_cuenta_container").hide();
            if (parseInt($("#costo_plan").val()) > 0) {
                $("#cant_empleados_container").show();
            } else {
                $("#cant_empleados_container").hide();
            }

        } else {
            //campos visibles para planes de empresas
            $("#tipo_cuenta_container").show();
            $("#cant_empleados_container").hide();
        }

    };
// bandera para detectar click en banner de achatdepack 
    if ($("#achatdepack").val() == '1') {

        $("#oferta-obras-sociales").trigger("click");
    }


    if (FREE == 1) {

        $("#btn-22").trigger("click");

    }

});