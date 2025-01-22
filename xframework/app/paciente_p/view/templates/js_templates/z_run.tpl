 {literal}
<script language="javascript" type="text/javascript" >
    
    
    
    //obtenemos el estado completado del perfil de salud y eliminamos las clases alert en el menu cuando se completan las secciones
    function actualizar_menu_status_perfilsalud() {
        
        x_doAjaxCall(
                'POST',
        BASE_PATH + 'get_status_perfilsalud.do',
        "",
        function (data) {
            console.log(data);
            //datos biometricos
            if (data.datosbiometricos == 1) {
                $("#menu_perfil_salud i.dpp-male").parent().removeClass("alert");
            } else {
                $("#menu_perfil_salud i.dpp-male").parent().addClass("alert");
            }
            
            //enfermedades y patologias
            if (data.patologias == 1 && data.enfermedades == 1) {
                $("#menu_perfil_salud i.dpp-patologia").parent().removeClass("alert");
            } else {
                $("#menu_perfil_salud i.dpp-patologia").parent().addClass("alert");
            }
            
            //enfermedades y patologias
            if (data.antecedentes_familiares == 1 && data.antecedentes_pediatricos == 1) {
                $("#menu_perfil_salud i.dpp-dna").parent().removeClass("alert");
            } else {
                $("#menu_perfil_salud i.dpp-dna").parent().addClass("alert");
            }
            
            //ginecologico
            if (data.ginecologico_antecedentes == 1 && data.ginecologico_controles == 1 && data.ginecologico_embarazo == 1) {
                $("#menu_perfil_salud i.dpp-ginecologia").parent().removeClass("alert");
            } else {
                $("#menu_perfil_salud i.dpp-ginecologia").parent().addClass("alert");
            }
            
            //cirugias
            /*if (data.cirugias_protesis == 1) {
                     $("#menu_perfil_salud i.dpp-cirugia").parent().removeClass("alert");
                     } else {
                     $("#menu_perfil_salud i.dpp-cirugia").parent().addClass("alert");
                     }
             */
            //alergias
            if (data.alergias_intolerancias == 1) {
                $("#menu_perfil_salud i.dpp-alergia").parent().removeClass("alert");
            } else {
                $("#menu_perfil_salud i.dpp-alergia").parent().addClass("alert");
            }
            //control visual
            /*  if (data.control_visual == 1) {
                     $("#menu_perfil_salud i.dpp-ojo").parent().removeClass("alert");
                     } else {
                     $("#menu_perfil_salud i.dpp-ojo").parent().addClass("alert");
                     }*/
            //estilo de vida
            /*if (data.estilovida == 1) {
                     $("#menu_perfil_salud i.dpp-sonrisa").parent().removeClass("alert");
                     } else {
                     $("#menu_perfil_salud i.dpp-sonrisa").parent().addClass("alert");
                     }*/
            
            //videoconsulta
            if (data.PermitidoVideoConsulta == 1) {
                //habilitada
                if (!($("#menu_perfil_salud i.icon-doctorplus-video-call").parent().find("span").hasClass("green"))) {
                    
                }
                $("#menu_perfil_salud i.icon-doctorplus-video-call").parent().find("span").remove();
                $("#menu_perfil_salud i.icon-doctorplus-video-call").parent().append('<span class="green"><i class="fui-check"></i></span>');
                $("#shortcuts_original a.icon-doctorplus-video-call small").remove();
                $("#shortcuts_original a.icon-doctorplus-video-call").parent().removeClass("inactive");
                
                
            }
            else {
                //deshabilitada
                $("#menu_perfil_salud i.icon-doctorplus-video-call").parent().find("span").remove();
                $("#menu_perfil_salud i.icon-doctorplus-video-call").parent().append('<span><strong>-</strong></span>');
            }
            
            //consulta express
            if (data.PermitidoConsultaExpress == 1) {
                //habilitada
                if ($("#shortcuts_original a.dp-express small").length > 0) {
                    $("#modal-completo-perfil-salud").modal('show');
                }
                $("#menu_perfil_salud i.dpp-express").parent().find("span").remove();
                $("#menu_perfil_salud i.dpp-express").parent().append('<span class="green"><i class="fui-check"></i></span>');
                $("#shortcuts_original a.dp-express small").remove();
                $("#shortcuts_original a.dp-express").parent().removeClass("inactive");
                
                
                
            }
            else {
                //deshabilitada
                $("#menu_perfil_salud i.dpp-express").parent().find("span").remove();
                $("#menu_perfil_salud i.dpp-express").parent().append('<span><strong>-</strong></span>');
            }
            
            
        });
    }
    ;
    
    
    /* Metodo que obtiene las notificaciones que no han sido alertadas mediante una notificacion emergente*/
    function get_notificaciones_alerta_sistema() {
        //solo la mostramos una vez cuando se inicia la session
        var show = sessionStorage.getItem("show_notify_alerta_sistema");
        
        if (show != "NO") {
            
            x_doAjaxCall(
                    'POST',
            BASE_PATH + 'get_notificacion_alerta_sistema_p.do',
            ''
            , function (data) {
                
                $.each(data, function (key, notificacion) {
                    
                    
                    notify({title: notificacion.title, text: notificacion.text, style: notificacion.style});
                    
                }
                        );
                sessionStorage.setItem("show_notify_alerta_sistema", "NO");
                
                
            });
        }
        
        
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
            get_notificaciones_alerta_sistema();
            window.name = "doctorplus";
            {/if}
                {literal}
                
                
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
{*NO APLICA - FUNCIONA IOS*}
{*
{if $smarty.request.modulo=="videoconsulta" || $smarty.request.modulo=="consultaexpress"}
<script>
            var modulo = "{$modulo}";
            var submodulo = "{$submodulo}";
            {literal}
           /* $(function () {
                var mostrar_modal_usabilidad_ios_ce = sessionStorage.getItem("mostrar-modal-usabilidad-ios-ce");
                var mostrar_modal_usabilidad_ios_vc = sessionStorage.getItem("mostrar-modal-usabilidad-ios-vc");
                if (/iPad|iPhone|iPod/.test(navigator.platform) && modulo == "videoconsulta" && (mostrar_modal_usabilidad_ios_vc != "0" || submodulo == "videoconsulta_mobile" ) ){
                    x_doAjaxCall('POST',
                    BASE_PATH + 'panel-paciente/get_browser_info.do',
                    '',
                    function (data) {
                        if (data.hasOwnProperty("mobile")&&data.hasOwnProperty("ios")&&!data.hasOwnProperty("safari") ) { 
                            $("#modal-usabilidad-ios").modal("show");
                        }
                    });
                    
                }
                
                
                
                
        $("#modal-usabilidad-ios .close").click(function () {
            if (window.sessionStorage) {
                if (modulo == "consultaexpress") {
                    sessionStorage.setItem("mostrar-modal-usabilidad-ios-ce", "0");
                }
                if (modulo == "videoconsulta") {
                    sessionStorage.setItem("mostrar-modal-usabilidad-ios-vc", "0");
                }
                
            }
                
        });
            });*/
             {/literal}
                
</script>
{/if}
*}