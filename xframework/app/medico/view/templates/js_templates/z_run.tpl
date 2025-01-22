{literal}
<script language="javascript" type="text/javascript" >


    //obtenemos el estado completado del perfil de salud y eliminamos las clases alert en el menu cuando se completan las secciones
    function actualizar_menu_status_perfilsalud() {

        x_doAjaxCall(
                'POST',
                BASE_PATH + 'get_status_perfilsalud_m.do',
                "",
                function (data) {

                    //datos biometricos
                    if (data.datosbiometricos == 1) {
                        $("i.dpp-male").parent().removeClass("alert");
                    } else{
                        $("i.dpp-male").parent().addClass("alert");
                    }

                    //enfermedades y patologias
                    if (data.patologias == 1 && data.enfermedades == 1) {
                        $("i.dpp-patologia").parent().removeClass("alert");
                    } else{
                        $("i.dpp-patologia").parent().addClass("alert");
                    }

                    //enfermedades y patologias
                    if (data.antecedentes_familiares == 1 && data.antecedentes_pediatricos == 1) {
                        $("i.dpp-dna").parent().removeClass("alert");
                    } else{
                        $("i.dpp-dna").parent().addClass("alert");
                    }

                    //ginecologico
                    if (data.ginecologico_antecedentes == 1 && data.ginecologico_controles == 1 && data.ginecologico_embarazo == 1) {
                        $("i.dpp-ginecologia").parent().removeClass("alert");
                    } else{
                        $("i.dpp-ginecologia").parent().addClass("alert");
                    }

                    //cirugias
                    /*if (data.cirugias_protesis == 1) {
                        $("i.dpp-cirugia").parent().removeClass("alert");
                    } else{
                        $("i.dpp-cirugia").parent().addClass("alert");
                    }*/

                    //alergias
                    if (data.alergias_intolerancias == 1) {
                        $("i.dpp-alergia").parent().removeClass("alert");
                    } else{
                        $("i.dpp-alergia").parent().addClass("alert");
                    }

                    //estilo de vida
                   /* if (data.estilovida == 1) {
                        $("i.dpp-sonrisa").parent().removeClass("alert");
                    } else{
                        $("i.dpp-sonrisa").parent().addClass("alert");
                    }*/

                    //consulta express
                    if (data.PermitidoConsultaExpress == 1) {
                        //habilitada
                        $(".dpp-express").parent().find("span").remove();
                        $(".dpp-express").parent().append('<span class="green"><i class="fui-check"></i></span>');

                    }
                    else{
                        //deshabilitada
                        $(".dpp-express").parent().find("span").remove();
                        $(".dpp-express").parent().append('<span><strong>-</strong></span>');
                    }


                });
    }
    ;


    //metodo ejecutado en callback para quitar el spinner a un elemento id
    function spinOff(id) {
        id.spin(false);
    }

    $(document).ready(function () {
        $("#hideAll").fadeOut(1000);
        renderUI2();
        {/literal}
        {* seteamos el nombre del tab para sala de videoconsulta o  navegacion general *}
        {if $smarty.request.modulo == "videoconsulta" && $smarty.request.submodulo == "videoconsulta"}
        //window.name = "videoconsulta";
         window.name = "doctorplus";

        {else}
        window.name = "doctorplus";
        {/if}
        {literal}



//intercambiamos los accesos directos e iconos flotantes

        $(window).on('scroll', function () {
            //quitamos icono flotante
            /*if ($("#visible-mobile").css("display") == 'none') {
                if ($(window).scrollTop() >= 250) {
                    if ($("#float-nav").css("display") == 'none') {
                        $("#float-nav").fadeIn();
                        $("#float-nav").addClass('visible-md');
                        $("#float-nav").addClass('visible-lg');
                    }
                } else{
                    if ($("#float-nav").css("display") == 'block') {
                        $("#float-nav").fadeOut();
                        $("#float-nav").removeClass('visible-md');
                        $("#float-nav").removeClass('visible-lg');
                    }
                }
            }*/
        });


        $(window).resize(function () {
            if (window.sessionStorage && sessionStorage.getItem("mostrar_modal_usabilidad") !== "0") {
                if ($("#check_window_orientation").css("display") == "block") {
                    $("#active_modal_usabilidad").click();
                }
                else{
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

        $('button, .role-button').on('click', function (event) {

            var button = event.target;
            var objClass = $(this).attr('class');
            if ($(this).parent('ul') && $(this).parents('ul').attr('id')) {
                var menuOrigin = $(this).parents('ul').attr('id');
            }

            buttonTriggers(button, menuOrigin, objClass);
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
            scrollToEl($('#comparison-table'));
        });
        /**
         * FIN JAVASCRIPT TRIXIO
         */

    });

    function modalData(data, id) {

        $modal = $('.modal:not([data-load="no"])');
        if (typeof id !== 'undefined') {
            $modal.find('.modal-dialog').attr('id', id);
        }

        var body = $modal.find('.modal-body').html(data);

        body.find('.hidden').removeClass('hidden');

        $modal.find(":checkbox[data-toggle='switch']").each(function () {
            var $checkbox = $(this);
            $checkbox.bootstrapSwitch();
        });

        $modal.find('.modal-body select').select2();

        $modal.find(':radio, :checkbox').radiocheck();
        $modal.modal();

        if ($('.modal-inside').find('li a').hasClass('gallery-imc')) {
            $('.gallery-imc').featherlightGallery({
                gallery: {fadeIn: 300, fadeOut: 300}
            });
        }
        if ($('.modal-inside').find('li a').hasClass('gallery-perc')) {
            $('.gallery-perc').featherlightGallery({
                gallery: {fadeIn: 300, fadeOut: 300}
            });
        }
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
            var parse = object.html();
            if ($(button).data('id')) {
                var id = $(button).data('id');
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
{*NO APLICA - FUNCIONA IOS*}
{*
{if $smarty.request.modulo=="videoconsulta" || $smarty.request.modulo=="consultaexpress"}
<script>
   var modulo = "{$modulo}";
   var submodulo = "{$submodulo}";
    {literal}
    /*
    $(function () {
           var mostrar_modal_usabilidad_ios_ce = sessionStorage.getItem("mostrar-modal-usabilidad-ios-ce");
            var mostrar_modal_usabilidad_ios_vc = sessionStorage.getItem("mostrar-modal-usabilidad-ios-vc");
            //modal usabilidad VC on iOS
                if (/iPad|iPhone|iPod/.test(navigator.platform) && modulo == "videoconsulta" && (mostrar_modal_usabilidad_ios_vc != "0" || submodulo == "videoconsulta_mobile" ) ){
                    x_doAjaxCall('POST',
                    BASE_PATH + 'panel-medico/get_browser_info.do',
                    '',
                    function (data) {
                        if (data.hasOwnProperty("mobile")&&data.hasOwnProperty("ios")&&!data.hasOwnProperty("safari") ) { 
                            $("#modal-usabilidad-ios").modal("show");
                        }
                    });
                    
                }
      if (true || /iPad|iPhone|iPod/.test(navigator.platform) && modulo == "consultaexpress" && $('.chat-mic-rec').length>0){
                    x_doAjaxCall('POST',
                    BASE_PATH + 'panel-medico/get_browser_info.do',
                    '',
                    function (data) {
                         
                           
                        if (data.hasOwnProperty("mobile")&&data.hasOwnProperty("ios")&&!data.hasOwnProperty("safari") ) { 
                            $('.chat-mic-rec').off();
                          $('.chat-mic-rec').on('click', function(e) {
                            $("#modal-usabilidad-ios").modal("show");
                        });
                        }
                    
                   
                    
                })
            }
        $("#modal-usabilidad-ios .close").click(function () {
            if (window.sessionStorage) {
                 if(modulo=="consultaexpress"){
                  sessionStorage.setItem("mostrar-modal-usabilidad-ios-ce", "0");  
                }
                if(modulo=="videoconsulta"){
                  sessionStorage.setItem("mostrar-modal-usabilidad-ios-vc", "0");  
                }
                

            }

        });
      
    });
    */
    {/literal}

</script>
{/if}
*}