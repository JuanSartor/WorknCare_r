<!-- /accesso directos menu -->
{*banner agenda*}
<section class="agenda-header td-agenda-header">
    <div class="container">
        <div class="calendar-sort pull-left">
            <ul class="sort agenda-header-icons">
                <li><button onclick="window.location.href = '{$url}panel-medico/agenda/agenda-diaria/?idconsultorio={$idconsultorio}'" class="dp-day day"></button></li>
                <li class="hidden-xs"><button onclick="window.location.href = '{$url}panel-medico/agenda/agenda-semanal/?idconsultorio={$idconsultorio}'" class="dp-week week"></button></li>
                <li><button onclick="window.location.href = '{$url}panel-medico/agenda/agenda-mensual/?idconsultorio={$idconsultorio}'" class="dp-month month"></button></li>
            </ul>
            <h1 class="agenda-title hidden-xs"> {"Agenda"|x_translate}</h1>


        </div>


        <div class="pull-right">
            <a href="javascript:;" id="agenda-menu-trg" class="td-agenda-menu">
                <span></span>
                <span></span>
                <span></span>
            </a>


        </div>
        <div class="pull-right">
            <a href="{$url}professionnel/agenda/vacances.html"class="btn-vacaciones"><i class="fa fa-calendar-times-o"></i>&nbsp;{"Vacaciones"|x_translate}</a>
        </div>
    </div>
</section>
{*consultorios*}
{if $smarty.request.modulo=="agenda"}
    <section class="okm-row medico-agenda-nav">
        <div class="agenda-flotante-box">
            <a href="javascript:;" class="agenda-flotante-btn" id="datepicker">
                <figure class="agenda-flotante-circle">
                    <i class="icon-doctorplus-calendar-day"></i>
                </figure>
            </a>

            <div class="agenda-flotante-calendar">
                <div class="agenda-flotante-calendar-box">
                    <div class="afc hidden" id="afc">
                    </div>
                </div>
            </div>

        </div>
        <div class="agenda-header-nav">

            <div class="{if $smarty.request.submodulo=="agenda_semanal"}hidden-xs{/if} okm-row">
                <div class="agenda-consultorios-list-box">

                    <input type="hidden" id="idconsultorio" value="{$idconsultorio}" />
                    {foreach from=$consultorio_list item=consultorio}
                        <a href="javascript:;" data-id="{$consultorio.idconsultorio}" class="select-consultorio {if $consultorio.idconsultorio == $idconsultorio} selected {/if}">

                            {if $consultorio.is_virtual =="0"}
                                <i class="icon-doctorplus-map-plus-rounded" style="display:inline !important;"></i>
                                <span>{"Consultorio Físico"|x_translate}</span>
                            {else}
                                <i class="icon-doctorplus-consultorio-virtual" style="display:inline !important;"></i>
                                <span>{"Consultorio Virtual"|x_translate}</span>
                            {/if}

                        </a>
                    {/foreach}

                </div>
            </div>
        </div>


        <a href="{$url}panel-medico/perfil-profesional/consultorios/?asignarhorario=1&idconsultorio={$idconsultorio}"  class="btn-add-horario {if $smarty.request.submodulo=="agenda_semanal"}hidden-xs{/if}" > 
            <figure>
                <i class="icon-doctorplus-plus"></i>
                <span class="div-oculto"> {"Agregar horario"|x_translate}</span>
            </figure>
        </a>

    </section>  
{/if}

{*menu lateral desplegable*}
<div class="agenda-menu-box">
    <div class="agenda-menu">

        <div id="menu-agenda" class="agenda-menu-index">
            <div class="agenda-menu-header">
                <h2>{"Agenda"|x_translate}</h2>
                <a href="javascript:;" class="menu-close-trg"><i class="icon-doctorplus-cruz"></i></a>
            </div>
            <div class="menu-agenda-body">
                <ul>
                    <li><a href="javascript:;" data-target="menu-exportar" class="withArrow">{"Exportar Agenda"|x_translate}</a></li>
                        {if $smarty.request.modulo=="turno"}
                        <li>
                            <a href="{$url}panel-medico/agenda/imprimir-detalle-turno-{$smarty.request.id}.html" class="withArrow" target="_blank">{"Imprimir"|x_translate}</a>
                        </li>
                    {/if}
                    <li><a href="javascript:;" data-target="menu-referencia" class="withArrow">{"Referencias"|x_translate}</a></li>
                    <li><a href="javascript:;" data-target="menu-resumen" class="withArrow">{"Resumen"|x_translate}</a></li>
                </ul>
            </div>
        </div>

        <div id="menu-exportar" class="agenda-menu-index withBack">
            <div class="agenda-menu-header">
                <a href="javascript:;" class="agenda-back-btn"><i class="icon-doctorplus-left-arrow"></i></a>
                <h2>
                    {"Exportar"|x_translate}
                </h2>
                <a href="javascript:;" class="menu-close-trg"><i class="icon-doctorplus-cruz"></i></a>
            </div>
            <div class="menu-agenda-body withCalendar">
                <ul>
                    <li><a href="{$url}panel-medico/agenda/exportar_agenda_xls.do?agenda=1&fecha={$dia_agenda}" target="_blank" >
                            <figure>
                                <i class="icon-doctorplus-turno-disponible"></i>
                                <span>1</span>
                            </figure>
                            {"Día de hoy"|x_translate}
                        </a>
                    </li>
                    <li><a href="{$url}panel-medico/agenda/exportar_agenda_xls.do?agenda=3&fecha={$dia_agenda}" target="_blank">
                            <figure>
                                <i class="icon-doctorplus-turno-disponible"></i>
                                <span>7</span>
                            </figure>
                            {"Próximos 7 días"|x_translate}
                        </a>
                    </li>
                    <li><a href="{$url}panel-medico/agenda/exportar_agenda_xls.do?agenda=4&fecha={$dia_agenda}" target="_blank">
                            <figure>
                                <i class="icon-doctorplus-turno-disponible"></i>
                                <span>15</span>
                            </figure>
                            {"Próximos 15 días"|x_translate}
                        </a>
                    </li>
                    <li><a href="{$url}panel-medico/agenda/exportar_agenda_xls.do?agenda=5&fecha={$dia_agenda}" target="_blank" >
                            <figure>
                                <i class="icon-doctorplus-turno-disponible"></i>
                                <span>30</span>
                            </figure>
                            {"Próximos 30 días"|x_translate}
                        </a>
                    </li>
                    <li><a href="{$url}panel-medico/agenda/exportar_agenda_xls.do?agenda=2&fecha={$dia_agenda}" target="_blank" >
                            <figure>
                                <i class="icon-doctorplus-turno-disponible"></i>
                                <span></span>
                            </figure>
                            {"Este mes"|x_translate}
                        </a>
                    </li>

                </ul>
            </div>
        </div>

        <div id="menu-referencia" class="agenda-menu-index withBack">
            <div class="agenda-menu-header">
                <a href="javascript:;" class="agenda-back-btn"><i class="icon-doctorplus-left-arrow"></i></a>
                <h2>
                    {"Referencias"|x_translate}
                </h2>
                <a href="javascript:;" class="menu-close-trg"><i class="icon-doctorplus-cruz"></i></a>
            </div>
            <div class="menu-agenda-body withReference">
                <ul>
                    <li><div>
                            <figure class="disponible"><i class="icon-doctorplus-disponible"></i></figure>

                            {"Disponible"|x_translate}
                        </div>
                    </li>
                    <li><div>
                            <figure class="confirmado"><i class="icon-doctorplus-check-circle"></i></figure>

                            {"Confirmado"|x_translate}
                        </div>
                    </li>
                    <li><div>
                            <figure class="confirmacion"><i class="icon-doctorplus-pendiente"></i></figure>

                            {"Pendiente"|x_translate}
                        </div>
                    </li>

                    <li><div>
                            <figure class="ausente"><i class="icon-doctorplus-ausente"></i></figure>

                            {"Ausente"|x_translate}
                        </div>
                    </li>
                    <li><div>
                            <figure class="declinado"><i class="fa fa-calendar-times-o"></i></figure>

                            {"Declinado"|x_translate}
                        </div>
                    </li>


                </ul>
            </div>
        </div>



        <div id="menu-resumen" class="agenda-menu-index withBack withResume">
            <div class="agenda-menu-header resumeHeader">
                <a href="javascript:;" class="agenda-back-btn"><i class="icon-doctorplus-left-arrow"></i></a>
                <h2>
                    {"Resumen"|x_translate} <span>{$titulo_resumen}</span>
                </h2>
                <a href="javascript:;" class="menu-close-trg"><i class="icon-doctorplus-cruz"></i></a>
            </div>
            <div class="withScroll">
                {foreach from=$datos_consultorios item=datos}
                    <div class="menu-agenda-body withReference withCant">
                        <h3>
                            {if $datos.is_virtual=="0"}
                                <i class="icon-doctorplus-map-plus-rounded"></i>
                                {"Consultorio Físico"|x_translate}
                            {else}
                                <i class="icon-doctorplus-consultorio-virtual"></i>
                                {"Consultorio Virtual"|x_translate}
                            {/if}

                        </h3>
                        <ul>
                            <li><div>
                                    <figure class="disponible"><i class="icon-doctorplus-disponible"></i></figure>
                                        {"Disponible"|x_translate}
                                    <span class="agenda-reference-cant">{$datos.turnos_disponibles}</span>
                                </div>
                            </li>
                            <li><div>
                                    <figure class="confirmado"><i class="icon-doctorplus-check-circle"></i></figure>
                                        {"Confirmado"|x_translate}
                                    <span class="agenda-reference-cant">{$datos.turnos_confirmados}</span>
                                </div>
                            </li>
                            <li><div>
                                    <figure class="confirmacion"><i class="icon-doctorplus-pendiente"></i></figure>

                                    {"Pendiente"|x_translate}
                                    <span class="agenda-reference-cant">{$datos.turnos_pendientes}</span>
                                </div>
                            </li>
                            <li><div>
                                    <figure class="ausente"><i class="icon-doctorplus-ausente"></i></figure>

                                    {"Ausente"|x_translate}
                                    <span class="agenda-reference-cant">{$datos.turnos_ausentes}</span>
                                </div>
                            </li>
                            <li><div>
                                    <figure class="declinado"><i class="fa fa-calendar-times-o"></i></figure>
                                        {"Declinado"|x_translate}
                                    <span class="agenda-reference-cant">{$datos.turnos_declinados}</span>
                                </div>
                            </li>



                        </ul>
                    </div>
                {/foreach}

            </div>
        </div>



    </div>

</div>


{literal}
    <script>
        $(function () {

            /// MEnu agenda
            if ($('.agenda-menu-box').length > 0) {
                var viewPortRest = $('nav.navbar').outerHeight() + $('.resumeHeader').outerHeight();

                var viewPortHeight = $(window).height();

                var viewPortRes = viewPortHeight - viewPortRest;

                var topH = $('nav.navbar').outerHeight();

                var bodyH = $('body').outerHeight();

                function agendaScroll(trgObj) {
                    $('html, body').animate({
                        scrollTop: trgObj.offset().top - 100
                    }, 200);
                }


                function agendaMenuMove(obj, prop) {
                    obj.animate({
                        width: prop + "px"
                    },
                            200,
                            function () {
                                if (prop > 0) {
                                    //agendaScroll($('body'));
                                } else {
                                    //agendaScroll($('#agenda-menu-trg'));
                                }
                            }
                    );
                }


                $(".agenda-menu-box").outerHeight(bodyH);
                //		
                //		$(".withScroll").mCustomScrollbar({
                //			theme:"dark-3"
                //		});
                //		
                $('.menu-close-trg').on('click', function (e) {
                    e.preventDefault();
                    agendaMenuMove($(".agenda-menu-box"), 0);

                    $('.agenda-menu-index').removeClass('isItemMenuVisible');
                });


                $('#agenda-menu-trg').on('click', function (e) {
                    e.preventDefault();
                    agendaMenuMove($(".agenda-menu-box"), 310);
                });

                $('.menu-agenda-body').find('a').on('click', function (e) {
                    //e.preventDefault();

                    if ($(this).data('target')) {

                        var mTarget = $(this).data('target');
                        $('#' + mTarget).addClass('isItemMenuVisible');


                    } else {
                        if ($('#' + mTarget).hasClass('isItemMenuVisible')) {
                            $('#' + mTarget).removeClass('isItemMenuVisible');
                        }
                    }


                });

                $('.agenda-back-btn').on('click', function () {
                    $(this).closest('.agenda-menu-index').removeClass('isItemMenuVisible');
                });



                var menuItemHeight = 0;
                //		
                //		$(window).on('scroll', function () {
                //			var currentTop = $(window).scrollTop();
                //
                //			if($(".agenda-menu-box").outerWidth() == 310){
                //			
                //			if($('.isItemMenuVisible').length > 0){
                //				 menuItemHeight = ($('.isItemMenuVisible').offset().top + $('.isItemMenuVisible').outerHeight())-100;
                //				
                //				if(currentTop > menuItemHeight){
                //					agendaMenuMove($(".agenda-menu-box"),0);
                //					if($('.agenda-menu-index').hasClass('isItemMenuVisible')){
                //					 $('.agenda-menu-index').removeClass('isItemMenuVisible');
                //					 }
                //				}
                //				
                //				
                //			}else{
                //				menuItemHeight = ($('#menu-agenda').offset().top + $('#menu-agenda').outerHeight())-100;
                //				
                //				
                //				if(currentTop > menuItemHeight){
                //					agendaMenuMove($(".agenda-menu-box"),0);
                //				}
                //				
                //			}
                //			
                //			}
                //				
                //		});
                //		
            }



            //menu flotante
            if ($('.agenda-flotante-box').length > 0) {

                var headerHeight = $('#menu').height() + 50;
                var elepos = $('.agenda-flotante-box').offset().top;
                var topspace = elepos - headerHeight;





                $(window).on('scroll', function () {
                    var currentTop = $(window).scrollTop();
                    var currentElePos = $('.agenda-flotante-box').offset().top;
                    var currentElePosH = $('.agenda-flotante-box').offset().left;
                    var btnposV = currentElePos - currentTop;


                    if (currentTop > topspace) {

                        $('.agenda-flotante-box').css({
                            position: 'fixed',
                            top: 120,
                            left: '0px',
                            'z-index': 9000
                        });

                    } else if (currentTop < topspace) {

                        $('.agenda-flotante-box').css({
                            position: 'absolute',
                            top: '0px',
                            left: '0px',
                            'z-index': 1
                        });
                    }
                });
            }


            pickmeup.defaults.locales['fr'] = {
                days: [x_translate("Domingo"), x_translate("Lunes"), x_translate("Martes"), x_translate("Miércoles"), x_translate("Jueves"), x_translate("Viernes"), x_translate("Sábado")],
                daysShort: [x_translate("Dom"), x_translate("Lun"), x_translate("Mar"), x_translate("Mie"), x_translate("Jue"), x_translate("Vie"), x_translate("Sab")],
                daysMin: [x_translate("Do"), x_translate("Lu"), x_translate("Ma"), x_translate("Mi"), x_translate("Ju"), x_translate("Vi"), x_translate("Sa")],
                months: [x_translate("Enero"), x_translate("Febrero"), x_translate("Marzo"), x_translate("Abril"), x_translate("Mayo"), x_translate("Junio"), x_translate("Julio"), x_translate("Agosto"), x_translate("Septiembre"), x_translate("Octubre"), x_translate("Noviembre"), x_translate("Diciembre")],
                monthsShort: [x_translate("En"), x_translate("Feb"), x_translate("Mar"), x_translate("Abr"), x_translate("May"), x_translate("Jun"), x_translate("Jul"), x_translate("Ago"), x_translate("Sep"), x_translate("Oct"), x_translate("Nov"), x_translate("Dic")]
            };

            var now = new Date();
            now.setHours(0, 0, 0, 0);
            var dayEvents = [
                now.setDate(15),
                now.setDate(17),
                now.setDate(1)
            ];

            pickmeup('.afc', {
                flat: true,
                locale: 'fr',
                format: 'd-m-Y',
                class_name: 'agenda-float',
                first_day: 0,
                mode: 'single',
                render: function (date) {
                    dateNoHours = date.setHours(0, 0, 0, 0);
                    for (var i = 0; i < dayEvents.length; i++) {

                        if (dateNoHours == dayEvents[i]) {
                            return {disabled: false, class_name: 'date-with-event'};
                        }

                    }


                    return {};
                }
            });

            pickmeup(".afc");
            $('.afc').on('pickmeup-change', function (e) {
                var fecha_str = e.originalEvent.detail.formatted_date;
                var fecha = fecha_str.split("-");
                $("body").spin("large");
                window.location.href = BASE_PATH + "panel-medico/agenda/agenda-diaria/" + fecha[0] + "-" + fecha[1] + "-" + fecha[2] + "/?idconsultorio=" + $("#idconsultorio").val();

            })


            //calendario
            $('#datepicker').on('click', function (e) {
                e.preventDefault();
                $('.afc').toggleClass('hidden');
            });

            /*
             if($('.agenda-flotante-box').length > 0){
             
             var headerHeight = $('#menu').height() + 50;
             var elepos = $('.agenda-flotante-box').offset().top;
             var topspace = elepos - headerHeight;
             
             
             
             
             
             $(window).on('scroll', function () {
             var currentTop = $(window).scrollTop();
             var currentElePos = $('.agenda-flotante-box').offset().top;
             var currentElePosH = $('.agenda-flotante-box').offset().left;
             var btnposV = currentElePos - currentTop;
             
             
             if(currentTop > topspace){
             
             $('.agenda-flotante-box').css({
             position:'fixed',
             top: 120,
             left: '0px',
             'z-index': 9000
             });
             
             }else if(currentTop < topspace){
             
             $('.agenda-flotante-box').css({
             position:'absolute',
             top: '0px',
             left: '0px',
             'z-index': 1
             });
             }
             });
             }
             */


        });
    </script>
{/literal}