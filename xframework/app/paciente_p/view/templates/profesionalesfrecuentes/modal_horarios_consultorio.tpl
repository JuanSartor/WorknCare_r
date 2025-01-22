<div class="pnb-consultorios-holder">
    {foreach from=$consultorios_list item=consultorio}
        <div class="pbp-turno" id="modulo_listado_consultorios" style="min-height:200px;">

            <div class="pbp-turno-header"  id="target-consultorio-{if $consultorio.is_virtual=="0"}{$consultorio.idconsultorio}{else}virtual{/if}" >

                {if $consultorio.is_virtual=="0"}
                    <i class="icon-doctorplus-map-plus-rounded"></i>
                    <p> {"Consultorio Físico"|x_translate}</p>
                    <div class="pbp-turno-direccion">
                        <p>{$consultorio.direccion|ucfirst} {$consultorio.numero}, {$consultorio.localidad|lower|ucfirst}, {$consultorio.pais}</p>

                    </div>
                {else}
                    <i class="icon-doctorplus-consultorio-virtual"></i>
                    <p> {"Consultorio Virtual"|x_translate}</p>
                    <div class="pbp-turno-direccion">

                        <p></p>  
                    </div>
                {/if}
            </div>

            <div class="pbn-turnos-holder pbn-turnos-sm" id="pbn-turnos-holder-{$consultorio.idconsultorio}" data-fecha="" data-idmedico="{$consultorio.medico_idmedico}" data-idconsultorio="{$consultorio.idconsultorio}">

                <div class="pbn-turnos-sm-slide" id="div_busqueda_agenda_semanal_medico_{$consultorio.idconsultorio}" >

                    <!-- ACÁ VA EL CONTENIDO DEL MODULO-->

                </div>
                <script>


                    $("#div_busqueda_agenda_semanal_medico_{$consultorio.idconsultorio}").spin("large");
                    x_loadModule("profesionalesfrecuentes",
                            "agenda_semanal_medico",
                            "idmedico={$consultorio.medico_idmedico}&idconsultorio={$consultorio.idconsultorio}",
                            "div_busqueda_agenda_semanal_medico_{$consultorio.idconsultorio}", BASE_PATH + "paciente_p").then(function () {
                        $("#div_busqueda_agenda_semanal_medico_{$consultorio.idconsultorio}").spin(false);
                    });

                </script>

            </div>

        </div>
    {/foreach}
</div>

{literal}
    <script>

        function verMasTexto(trigger, obj, inner, height) {

            var animateObj = trigger.prev(obj);
            var innerObj = animateObj.children(inner);

            var altoIni = height;
            var altoSlide = innerObj.outerHeight();



            if (animateObj.outerHeight() <= altoIni) {

                animateObj.animate({
                    height: altoSlide
                }, 600);
                trigger.html('Moins');
            } else {
                animateObj.animate({
                    height: altoIni
                }, 600);
                trigger.html('Plus...');
            }


        }

        function getHeightText(trigger, obj, inner, height) {

            $.each(trigger, function (i, val) {

                var animateObj = $(this).prev(obj);
                var innerObj = animateObj.children(inner);

                var altoIni = height;
                var altoSlide = innerObj.outerHeight();


                if (altoSlide <= altoIni) {
                    $(this).hide();

                }

            });



        }
        $(function () {


            $(".pbp-prepagas-list").mCustomScrollbar({
                theme: "dark-3"
            });
            if ($('.pbp-medico-ficha').length > 0) {

                getHeightText($('.pbp-ver-mas-trigger'), '.pbp-perfil-profesional-expand-text', '.pbp-perfil-profesional-expand-text-inner', 100);

                $('.pbp-ver-mas-trigger').on('click', function (e) {
                    e.preventDefault();
                    verMasTexto($(this), '.pbp-perfil-profesional-expand-text', '.pbp-perfil-profesional-expand-text-inner', 100);

                });



            }

            if ($('.map-static-btn').length > 0) {

                $('.map-static-btn').on('click', function (e) {
                    e.preventDefault();
                    $('#mapa').slideToggle();
                });
            }



            if ($('.pbp-tarifa-tipo-trigger').length > 0) {

                $('.pbp-tarifa-tipo-trigger').on('click', function (e) {
                    e.preventDefault();
                    if ($('.pbp-tarifa-tipo-trigger').hasClass('selected')) {
                        $('.pbp-tarifa-tipo-trigger').removeClass('selected');
                    }
                    $(this).addClass('selected');
                    var tipoData = $(this).data('type');

                    $.each($('.pbp-presencial'), function (i, val) {
                        if ($(this).data('src') == tipoData) {
                            if ($(this).hasClass('hidden')) {
                                $(this).removeClass('hidden');
                            }
                        } else {
                            if (!$(this).hasClass('hidden')) {
                                $(this).addClass('hidden');
                            }
                        }
                    });
                });
            }
            function scrollToObj(trgObj) {
                var trgObjHeight = trgObj.outerHeight();
                $('html, body').animate({
                    scrollTop: trgObj.offset().top - trgObjHeight
                }, 1000);
            }

            $('.pbp-turno-trigger').on('click', function (e) {
                e.preventDefault();
                var dTarget = $(this).attr('href');
                scrollToObj($(dTarget));
            });

            if ($('.pbp-card').length > 0) {

                var vpw = $(window).width() + getScrollBarWidth();
                if (vpw <= 800) {

                    $('.pbp-card').find('h3').on('click', function (e) {
                        $(this).next('.pbp-card-slide').slideToggle(function () {

                            if ($(this).is(':visible')) {
                                textcut(".pbp-perfil-profesional-expand-text", $(".pbp-perfil-profesional-expand-text").data('linesrsp'));
                            }

                        });
                        $(this).toggleClass('selected');
                    });
                } else {
                    textcut(".pbp-perfil-profesional-expand-text", $(".pbp-perfil-profesional-expand-text").data('lines'));
                }


            }

            $('#modulo_listado_consultorios').on('click', '.pbn-turnos-holder .a_semana_next,.pbn-turnos-holder .a_semana_previous,.pbn-turnos-holder .a_semana_next_turno', function () {

                $this = $(this);
                //Div que tiene la data del consultorio, médico y semana
                $div_with_data = $this.parents(".pbn-turnos-holder");
                var semana;
                if ($this.hasClass("a_semana_next")) {
                    semana = "&week=next";
                } else if ($this.hasClass("a_semana_previous")) {
                    semana = "&week=previous";
                } else {
                    semana = "&diferencia_semanas=" + $this.data("cantidad_semanas");
                }

                $("#div_busqueda_agenda_semanal_medico_" + $div_with_data.data("idconsultorio")).spin("large");
                x_loadModule("profesionalesfrecuentes",
                        "agenda_semanal_medico",
                        "idmedico=" + $div_with_data.data("idmedico") + "&idconsultorio=" + $div_with_data.data("idconsultorio")
                        + semana + "&fecha=" + $div_with_data.data("fecha"),
                        "div_busqueda_agenda_semanal_medico_" + $div_with_data.data("idconsultorio"), BASE_PATH + "paciente_p");
            });

        });

    </script>
{/literal}