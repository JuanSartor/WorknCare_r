{literal}
<script language="javascript" type="text/javascript" >
    function actualizar_notificaciones() {

        x_doAjaxCall(
                'POST',
                BASE_PATH + 'get_cantidad_notificaciones.do',
                "",
                function (data) {

                    $("#shorcuts_cant_notificaciones").val(data.cant_notificaciones);
                    if (parseInt($("#shorcuts_cant_notificaciones").val()) > 0) {
                        $("#div_shorcuts_cant_notificaciones").html("<span>" + $("#shorcuts_cant_notificaciones").val() + "</span>");
                    } else {
                        $("#div_shorcuts_cant_notificaciones").html("");
                    }

                    if (parseInt(data.cant_notificaciones_controles) > 0) {
                        $("#div_shorcuts_cant_notificaciones_controles").html("<span>" + data.cant_notificaciones_controles + "</span>");
                    } else {
                        $("#div_shorcuts_cant_notificaciones_controles").html("");
                    }
                }
        );


    }
    ;



    //obtenemos el estado completado del perfil de salud y eliminamos las clases alert en el menu cuando se completan las secciones
    function actualizar_menu_status_perfilsalud() {

        x_doAjaxCall(
                'POST',
                BASE_PATH + 'get_status_perfilsalud.do',
                "",
                function (data) {

                    //datos biometricos
                    if (data.datosbiometricos == 1) {
                        $("i.dpp-male").parent().removeClass("alert");
                    } else {
                        $("i.dpp-male").parent().addClass("alert");
                    }

                    //enfermedades y patologias
                    if (data.patologias == 1 && data.enfermedades == 1) {
                        $("i.dpp-patologia").parent().removeClass("alert");
                    } else {
                        $("i.dpp-patologia").parent().addClass("alert");
                    }

                    //enfermedades y patologias
                    if (data.antecedentes_familiares == 1 && data.antecedentes_pediatricos == 1) {
                        $("i.dpp-dna").parent().removeClass("alert");
                    } else {
                        $("i.dpp-dna").parent().addClass("alert");
                    }

                    //ginecologico
                    if (data.ginecologico_antecedentes == 1 && data.ginecologico_controles == 1 && data.ginecologico_embarazo == 1) {
                        $("i.dpp-ginecologia").parent().removeClass("alert");
                    } else {
                        $("i.dpp-ginecologia").parent().addClass("alert");
                    }

                    //cirugias
                    if (data.cirugias_protesis == 1) {
                        $("i.dpp-cirugia").parent().removeClass("alert");
                    } else {
                        $("i.dpp-cirugia").parent().addClass("alert");
                    }

                    //alergias
                    if (data.alergias_intolerancias == 1) {
                        $("i.dpp-alergia").parent().removeClass("alert");
                    } else {
                        $("i.dpp-alergia").parent().addClass("alert");
                    }

                    //estilo de vida
                    if (data.estilovida == 1) {
                        $("i.dpp-sonrisa").parent().removeClass("alert");
                    } else {
                        $("i.dpp-sonrisa").parent().addClass("alert");
                    }

                    //consulta express
                    if (data.PermitidoConsultaExpress == 1) {
                        //habilitada
                        if(!($(".dpp-express").parent().find("span").hasClass("green"))) {
                        $("#modal-completo-perfil-salud").modal('show'); 
                    }
                        $(".dpp-express").parent().find("span").remove();
                        $(".dpp-express").parent().append('<span class="green"><i class="fui-check"></i></span>');
                       
                     
                    }
                    else {
                        //deshabilitada
                        $(".dpp-express").parent().find("span").remove();
                        $(".dpp-express").parent().append('<span><strong>-</strong></span>');
                    }


                });
    }
    ;




    $(document).ready(function () {
        $("#hideAll").fadeOut(1000);
        renderUI2();


//intercambiamos los accesos directos e iconos flotantes

$(window).on('scroll', function() {
    
    if ( $("#visible-mobile").css("display") == 'none') {
                if ($(window).scrollTop() >= 250) {
                    if ($("#float-nav").css("display") == 'none') {
                        $("#float-nav").fadeIn();
                        $("#float-nav").addClass('visible-md');
                        $("#float-nav").addClass('visible-lg');
                    }
                } else {
                    if ($("#float-nav").css("display") == 'block') {
                        $("#float-nav").fadeOut();
                        $("#float-nav").removeClass('visible-md');
                        $("#float-nav").removeClass('visible-lg');
                    }
                }
            }
        });

        $(window).resize(function () {

       if (window.sessionStorage && sessionStorage.getItem("mostrar_modal_usabilidad") !== "0") {
            if ($("#check_window_orientation").css("display") == "block") {
                $("#active_modal_usabilidad").click();
            }
            else {
                $("#usabilidad-modal").modal("hide");
            }
        }
        });



        /**
         * INICIO JAVASCRIPT TRIXIO
         * @param {type} data
         * @param {type} id
         * @returns {undefined}
         */

        $('.slider-nav').on('click', function () {
            var direction = $(this).data('slide-to');
            var slider = $(this).parent().siblings('.slider');
            var list = $(slider).children('li');
            var step = $(this).parents('.nav-container').data('slide-value') - 30 + 'px';
            if ((direction) == 'right') {
                $(this).attr('data-slide-to', 'left');
                $(list).css('transform', 'translateX(-' + step + ')');
            } else {
                $(this).attr('data-slide-to', 'right');
                $(list).css('transform', 'translateX(' + step + ')');
            }
            ;
        });

        $('.modal-btn').on('click', function () {

            var targetId = '#' + $(this).data('target');
            $(targetId).modal();
        });
        $('.toggle-features').on('click', function () {
            $(this).siblings('.special-features').slideToggle();
        });
        $('.step-btn').on('click', function () {
            var toggleIndicator = $('#signup-steps').find('.active').removeClass();
            $(toggleIndicator).next('li').addClass('active');
        });
        $('.promo-code-btn').on('click', function () {
            $('.promo-code').addClass('active');
        });

        $('button').on('click', function (event) {

            var button = event.target;
            var objClass = $(this).attr('class');
            if ($(this).parent('ul') && $(this).parents('ul').attr('id')) {
                var menuOrigin = $(this).parents('ul').attr('id');
            }

            buttonTriggers(button, menuOrigin, objClass);
        });

        $('.customer-box').on('click', function () {

            var targetClass = $(this)[0];
            $(targetClass).addClass('pop-up');
            var html = $(this)[0].outerHTML;
            $(targetClass).removeClass('pop-up');
            var id = 'modal-box';
            modalData(html, id);
        });

        $('.modal').on('show.bs.modal', function (e) {
            var windowWidth = $(this).find('.w').css('width');
            $(this).find('.modal-dialog').css('width', windowWidth);
        });
        $('.modal').on('hidden.bs.modal', function (e) {
            $(this).find('.modal-dialog').removeAttr('id');
        });

        $('#patient-lookup').on('input', function () {
            alert('true');
        });

        $(document).on('shown.bs.tab', function (e) {
            if ($(this).attr('class', 'w')) {
                var object = $(e.target).attr('href');
                var windowWidth = $(object).css('width');
                var test = $(object).parents('.modal-dialog').css('width', windowWidth);
            }
        });

        $('#compare-btn').on('click', function () {
            $('#comparison-table').slideToggle('fast');
        });
        /**
         * FIN JAVASCRIPT TRIXIO
         */

    });

    function modalData(data, id) {
//[data-customerID="22"]
        $modal = $('.modal:not([data-load="no"])');
        if (typeof id !== 'undefined') {
            $modal.find('.modal-dialog').attr('id', id);
        }

        var body = $modal.find('.modal-body').html(data);

        $modal.find('.modal-body select').select2();

        $modal.find(':radio, :checkbox').radiocheck();

        $modal.find(":checkbox[data-toggle='switch']").each(function () {
            var $checkbox = $(this);
            $checkbox.bootstrapSwitch();
        });
        /*
         $(':radio').each(function() {
         var $radio = $(this);
         $radio.radiocheck();
         });
         })();*/

        body.find('.hidden').removeClass('hidden');
        $modal.modal();
    }

    /*
     function modalData(data, id) {
     if (typeof id !== 'undefined'){
     $('.modal').find('.modal-dialog').attr('id', id);
     }
     $('.modal').find('.modal-body').html(data);
     $('.modal').modal();
     }*/


    function buttonTriggers(button, menuOrigin, objClass) {



        // Modal

        if ($(button).data('modal') == 'yes') {
            var object = $(button).siblings('[class^="modal-"]');

            //console.log(object.attr("id"));


            var parse = object.html();
            if ($(button).data('id')) {
                var id = $(button).data('id');
            } else {
                var id = object.attr("id");
            }
            modalData(parse, id);
        }

        // Small Menus

        if ($(button).hasClass('back')) {
            var targetDisable = '#' + menuOrigin;
            $(targetDisable).removeClass('active');
            $('#action-main').toggleClass('disabled');
        }
        if (typeof $(button).data('toggle-menu') !== 'undefined') {
            var menuToggle = '#' + $(button).data('toggle-menu');
            $(menuToggle).toggleClass('active');
            if ($(menuToggle).attr('id') == 'summary') {
                var winWidth = $(menuToggle).css('width');
                $('#action-main').css('width', winWidth);
            }
            if ($('.sub-menu').hasClass('active')) {
                $('#action-main').toggleClass('disabled');
            }
        }
    }


</script>
{/literal}