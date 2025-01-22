
{if $medicos_frecuentes_list && $medicos_frecuentes_list|@count>"0"}

    <!-- Medicos frecuentes-->
    <div id="div_listado_medicos_frecuentes" class="relative">
        {*<div class="pcuh-divider"></div>*}

        <section class="container pul-profesionales-frecuentes">

            <div class="pcuh-row pcuh-user-row">

                <div class="pcuh-perfil-salud pcuh-profesionales-frecuentes-card"  style="padding-right: 0px;">
                    <div class="pcuh-profesionales-frecuentes">

                        <div class="pcuh-pf-slide-holder">
                            <div class="okm-row pcuh-pf-slide-box cotainer-slider-medicos-frecuentes">
                                <a href="javascript:;" class="pcuh-pf-slide-control left slider-control-medicos-frecuentes"><i class="icon-doctorplus-left-arrow"></i></a>
                                <div class="pcuh-pf-slide">

                                    {for $i=0 to $medicos_frecuentes_list|@count }
                                        {assign var=medico value=$medicos_frecuentes_list[$i]}

                                        {if $medico.idmedico!=""}
                                            <a href="javascript:;" data-consultorio-fisico="{$medico.tiene_consultorio_fisico}" class="pcuh-pf-slide-item select_prof_frecuente"  {if $medico.consultorio_virtual.idconsultorio!=""}data-virtual='1'{else}data-virtual='0'{/if} data-id="{$medico.idmedico}" data-nombre="{$medico.nombre|str2seo}" data-apellido="{$medico.apellido|str2seo}">
                                                <figure>
                                                    {if !$medico.imagen}
                                                        <img src="{$IMGS}extranet/noimage_perfil.png" title="{$medico.nombre} {$medico.apellido}" alt="{$medico.nombre} {$medico.apellido}">
                                                    {else}
                                                        <img src="{$path_files}/entities/medicos/{$medico.idmedico}/{$medico.idmedico}_list.jpg?t={$smarty.now}" title="{$medico.nombre} {$medico.apellido}" alt="{$medico.nombre} {$medico.apellido}">
                                                    {/if}
                                                    <div class="pcuh-pf-slide-item-data">
                                                        <p>{$medico.titulo_profesional} {$medico.nombre} {$medico.apellido}</p>
                                                        <span>{$medico.especialidad.0.especialidad}</span>
                                                        {if $medico.medico_cabecera==1}<p style="color:#cf3244;">{"Médico de cabecera"|x_translate}</p>{/if}
                                                        <button class="btnPerfil" data-url="{$url}panel-paciente/profesionales/{$medico.idmedico}-{$medico.nombre|str2seo}-{$medico.apellido|str2seo}.html" >{"Ver"|x_translate}</button>
                                                    </div>


                                                </figure>                 
                                            </a>
                                        {/if}

                                    {/for}

                                </div>
                                <a href="javascript:;" class="pcuh-pf-slide-control right slider-control-medicos-frecuentes"><i class="icon-doctorplus-right-arrow"></i></a>
                            </div>


                        </div>

                    </div>
                </div>

            </div>
        </section>
    </div>
{/if}
{literal}
    <script>
        $(function () {
            //seleccion elemento previo - marcamos como activo
            $('.pcuh-pf-slide-control.left,.pcuh-pf-slide-control.right').on('click', function (e) {
                e.preventDefault();
            });

            $('.pcuh-pf-slide').slick({
                //centerMode: true,
                dots: false,
                draggable: true,
                focusOnSelect: true,
                infinite: true,
                speed: 250,
                nextArrow: '.pcuh-pf-slide-control.right',
                prevArrow: '.pcuh-pf-slide-control.left',
                slidesToScroll: 1,
                slidesToShow: 3,
                responsive: [
                    {
                        breakpoint: 990,
                        settings: {slidesToShow: 3, slidesToScroll: 1, centerMode: true}
                    },
                    {
                        breakpoint: 740,
                        settings: {slidesToShow: 2, slidesToScroll: 1, centerMode: false}
                    },
                    {
                        breakpoint: 720,
                        settings: {slidesToShow: 2, slidesToScroll: 1, centerMode: false}
                    },
                    {
                        breakpoint: 600,
                        settings: {slidesToShow: 1, slidesToScroll: 1, centerMode: false, autoplay: true, speed: 1000}
                    }
                ]
            });
            // On before slide change
            $('.pcuh-pf-slide').on('afterChange', function (event, slick, currentSlide, nextSlide) {
                if ($(".select_prof_frecuente").length >= 3) {
                    if ($(".select_prof_frecuente[aria-hidden=false]").length >= 3) {
                        $(".select_prof_frecuente[aria-hidden=false]:eq(1)").trigger("click");
                    } else {
                        $(".select_prof_frecuente[aria-hidden=false]:first").trigger("click");
                    }

                } else {
                    $(".select_prof_frecuente:first").trigger("click");
                }
            });

            var spfItems = $('.pcuh-pf-slide-item');

            function spfDisable(items) {
                items.each(function (index) {

                    $(this).removeAttr('selected');

                    if ($(this).hasClass('active')) {
                        $(this).toggleClass('active');
                    }
                    if (!$(this).hasClass('disabled')) {
                        $(this).toggleClass('disabled');
                    }
                });
            }

            spfItems.on('click', function (e) {
                e.preventDefault();
                spfDisable(spfItems);

                if ($(this).hasClass('disabled')) {
                    $(this).removeClass('disabled');
                }
                $(this).addClass('active');
                $(this).attr('selected', 1);

            });


            $('[data-toggle="tooltip"]').tooltip();




            //handler seleccionar profesional
            $(".select_prof_frecuente").click(function () {
                if ($(this).data("id") != "") {

                    if ($(this).data("consultorio-fisico") == 1) {

                    } else {


                    }
                    if ($(this).data("virtual") == 1) {

                        $("#select-profesional-frecuente-vc").show();
                    } else {

                        $("#select-profesional-frecuente-vc").hide();
                    }

                    //mostramos el banner de vacaciones si existe
                    $(".vacaciones-turno-wrapper").hide();
                    $(".vacaciones-turno-wrapper[data-idmedico=" + $(this).data("id") + "]").show();
                    //$("#div_consultas_profesional .pcuh-pf-slide-actions").slideDown();
                }
            });
            //seleccionamos el central
            if ($(".select_prof_frecuente").length >= 3) {
                $(".select_prof_frecuente:eq(1)").trigger("click");
            } else {
                $(".select_prof_frecuente:first").trigger("click");
            }


            //botones para crear la videoconsulta asociada a un medico
            $("#select-profesional-frecuente-vc").click(function () {
                if ($(this).data("permitido") != 1) {
                    x_alert(x_translate("Complete el Perfil de Salud para realizar una Video Consulta"));
                    return false;
                }

                if ($(".select_prof_frecuente.active").length == 0) {
                    x_alert(x_translate("Seleccione un profesional frecuente para realizar una Video Consulta"));
                    return false;
                } else {
                    var idmedico = $(".select_prof_frecuente.active").data('id');
                }

                if (parseInt(idmedico) > 0) {
                    x_doAjaxCall(
                            'POST',
                            BASE_PATH + 'set_medico_videoconsulta.do',
                            'medico_idmedico=' + idmedico,
                            function (data) {

                                if (data.result) {
                                    window.location.href = BASE_PATH + "panel-paciente/videoconsulta/nuevavideoconsulta.html?continue=true";
                                } else {
                                    x_alert(data.msg);
                                }

                            }

                    );
                }

            });

            //botones para crear la consulta express asociada a un medico
            $("#select-profesional-frecuente-ce").click(function () {
                if ($(this).data("permitido") != 1) {
                    x_alert(x_translate("Complete el Perfil de Salud para realizar una Consulta Express"));
                    return false;
                }
                if ($(".select_prof_frecuente.active").length == 0) {
                    x_alert(x_translate("Seleccione un profesional frecuente para realizar una Consulta Express"));
                    return false;
                } else {
                    var idmedico = $(".select_prof_frecuente.active").data('id');
                }
                if (parseInt(idmedico) > 0) {
                    x_doAjaxCall(
                            'POST',
                            BASE_PATH + 'set_medico_consultaexpress.do',
                            'medico_idmedico=' + idmedico,
                            function (data) {

                                if (data.result) {
                                    window.location.href = BASE_PATH + "panel-paciente/consultaexpress/nuevaconsulta.html?continue=true";
                                } else {
                                    x_alert(data.msg);
                                }

                            }

                    );
                }

            });

            $(".btnPerfil").click(function (e) {
                e.preventDefault();
                e.stopPropagation();
                $(location).attr('href', $(this).data("url"));


            });
        });
    </script>
{/literal}
