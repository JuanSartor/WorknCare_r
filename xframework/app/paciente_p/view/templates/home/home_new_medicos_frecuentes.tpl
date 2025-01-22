<style>
    @media(min-width:601px){
        .pcuh-pf-slide-actions{
            display: flex;
            justify-content: center;
        }

        .pcuh-pf-slide-actions a   {
            display: inline-block;
            max-width:160px;
            min-width:130px;
        }
    }
    .pcuh-profesionales-frecuentes-card .slick-track{
        margin:auto
    }
    .pcuh-pf-slide-actions a  span {
        display: block;
        font-size: 12px;

    }
    .pcuh-pf-slide-actions a figure{
        margin-bottom: 10px;
    }

    @media(max-width:600px){
        .pcuh-pf-slide-item figure img {
            width: 80px;
        }
        .pcuh-pf-slide-actions {
            display:block;
            padding: 12px 0px;
        }
        .pcuh-pf-slide-actions a {
            display: flex ;
            align-items: center;
            padding: 8px 12px;
            border-radius: 8px;
            background-color: #00A79D;
            color: #fff;
            margin-bottom: 10px;

        }

        .pcuh-pf-slide-actions a span {
            display: inline-block;
            font-size: 12px;
        }
        .pcuh-pf-slide-actions a figure{
            display: inline-block;
            width: 56px;
            background-color: transparent;
            line-height: 1;
            padding:0;
            font-size: 20px;
            margin-bottom: 0px;
        } 
        .pcuh-pf-slide-actions a figure i {
            display: inline;
        }

    }
</style>
{if $medicos_frecuentes_list && $medicos_frecuentes_list|@count>"0"}
    {*
    <div class="okm-container msg-home-new" style="    background-color: #f2f2f2; margin-top: 20px; margin-bottom: 20px;">
    <h2>{"Consulte a sus profesionales frecuentes como prioridad como parte del proceso de tratamiento"|x_translate}</h2>    
    {if $paciente.pais_idpais==1}
    <h3>{"Su Video Consulta es reembolsable por la Seguridad Social"|x_translate}</h3>
    {else}
    <h3>{"Puede hacer una cita en la oficina o consultar de forma remota."|x_translate}</h3>
    {/if}
    </div>
    *}
    <!-- Medicos frecuentes-->
    <div id="div_listado_medicos_frecuentes" class="relative">
        {*<div class="pcuh-divider"></div>*}

        <section class="container pul-profesionales-frecuentes">

            <div class="pcuh-row pcuh-user-row">

                <div class="pcuh-perfil-salud pcuh-profesionales-frecuentes-card"  style="padding-right: 0px;">
                    <div class="pcuh-profesionales-frecuentes">
                        {*
                        <div class="pcuh-pf-title">
                        <h3>
                        <figure><i class="icon-doctorplus-user-add-like"></i></figure>
                        <span>{"Elegir profesional"|x_translate}</span>
                        </h3>
                        </div>
                        *}
                        <div class="pcuh-pf-slide-holder">
                            <div class="okm-row pcuh-pf-slide-box">
                                <a href="javascript:;" class="pcuh-pf-slide-control left"><i class="icon-doctorplus-left-arrow"></i></a>
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
                                                </figure>
                                                <div class="pcuh-pf-slide-item-data">
                                                    <p>{$medico.titulo_profesional} {$medico.nombre} {$medico.apellido}</p>
                                                    <span>{$medico.especialidad.0.especialidad}</span>
                                                    {if $medico.medico_cabecera==1}<p style="color:#cf3244;">{"Médico de cabecera"|x_translate}</p>{/if}
                                                </div>
                                            </a>
                                        {/if}

                                    {/for}

                                </div>
                                <a href="javascript:;" class="pcuh-pf-slide-control right"><i class="icon-doctorplus-right-arrow"></i></a>
                            </div>
                            <div class="okm-row" id="div_consultas_profesional"  style="min-height: 100px;">
                                {*mensaje medico vacaciones*}
                                {for $i=0 to $medicos_frecuentes_list|@count }
                                    {assign var=medico value=$medicos_frecuentes_list[$i]}

                                    {if $medico.vacaciones.hasta!=""}
                                        <div class="vacaciones-turno-wrapper home" data-idmedico="{$medico.idmedico}" style="display:none;">
                                            <p>{"Profesional de vacaciones"|x_translate}</p>
                                            <p>{"Responderá sus consultas luego del"|x_translate}&nbsp;{$medico.vacaciones.hasta_format}</p>
                                        </div>
                                    {/if}
                                {/for}
                                <div class="pcuh-pf-slide-actions">



                                    <a href="javascript:;" id="select-profesional-frecuente-ce"  data-permitido="{$paciente.is_permitido}"  title='{"Enviar Consulta Express"|x_translate}'>
                                        <figure>
                                            <i class="icon-doctorplus-chat"></i>
                                        </figure>
                                        <span>{"Consulta Express"|x_translate}</span>
                                        <span>&nbsp;{"(inmediata)"|x_translate}</span>
                                    </a>


                                    <a href="javascript:;" id="select-profesional-frecuente-vc" data-permitido="{$paciente.is_permitido}"  title='{"Video Consulta Inmediata"|x_translate}'>
                                        <figure>
                                            <i class="icon-doctorplus-video-cam"></i>
                                        </figure>
                                        <span>{"Video Consulta"|x_translate}</span>
                                        <span>&nbsp;{"(inmediata)"|x_translate}</span>

                                    </a>
                                    <a href="javascript:;" id="btnVideoconsultaTurno" data-permitido="{$paciente.is_permitido}"  title='{"Solicitar Video Consulta"|x_translate}'>
                                        <figure>
                                            <i class="icon-doctorplus-video-call"></i>
                                        </figure>
                                        <span>{"Video Consulta"|x_translate}</span>
                                        <span>&nbsp;{"(con turno)"|x_translate}</span>
                                    </a>
                                    <a href="javascript:;" id="btnConsultaPresencial" title='{"Sacar turno presencial"|x_translate}'>
                                        <figure>
                                            <i class="icon-doctorplus-ficha-check"></i>
                                        </figure>
                                        <span>{"Consulta presencial"|x_translate}</span>
                                        <span>&nbsp;{"(con turno)"|x_translate}</span>
                                    </a>

                                </div>	
                            </div>

                        </div>

                    </div>
                    <div class="pcuh-pf-action-footer">
                        <a href="{$url}panel-paciente/profesionales-frecuentes/" style="background-color: #007D8B;">{"Ver todos"|x_translate}</a>
                    </div>
                </div>
                {*
                <div class="pcuh-card pcuh-upload-card">
                <div class="pcuh-upload-card-title">
                <figure><i class="icon-doctorplus-camera"></i></figure>
                <h4>{"Estudios e imágenes"|x_translate}</h4>
                </div>
    
    
                <div class="pcu-card-upload">
                <a href="{$url}panel-paciente/perfil-salud/estudios-imagenes.html">
                <div class="upload-widget">
                <div class="dz-message needsclick">
                <i class="icon-doctorplus-plus"></i>
                <h3>{"Agregar exámen, estudio o foto"|x_translate}</h3>
                <small>{"Admite archivos jpg tamaño max. 8 MB."|x_translate}</small>
                </div>
                </div>
                </a>
                </div>
                <div class="pcuh-card-upload-footer">
                <a href="{$url}panel-paciente/perfil-salud/estudios-imagenes.html?show_all=1"><i class="icon-doctorplus-search"></i> {"Ver todos mis archivos"|x_translate}</a>
                </div>
                </div>
                *}
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
                centerMode: true,
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
                        settings: {slidesToShow: 1, slidesToScroll: 1, centerMode: false}
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
                    /*
                     $(this).removeAttr('selected');
                     
                     if ($(this).hasClass('active')) {
                     $(this).toggleClass('active');
                     }
                     if (!$(this).hasClass('disabled')) {
                     $(this).toggleClass('disabled');
                     }*/
                });
            }
/*
            spfItems.on('click', function (e) {
                e.preventDefault();
                spfDisable(spfItems);

                if ($(this).hasClass('disabled')) {
                    $(this).removeClass('disabled');
                }
                $(this).addClass('active');
                $(this).attr('selected', 1);

            });*/


            $('[data-toggle="tooltip"]').tooltip();




            //handler seleccionar profesional
            $(".select_prof_frecuente").click(function () {
                if ($(this).data("id") != "") {

                    if ($(this).data("consultorio-fisico") == 1) {
                        $("#btnConsultaPresencial").show();
                    } else {
                        $("#btnConsultaPresencial").hide();
                    }
                    if ($(this).data("virtual") == 1) {
                        $("#btnVideoconsultaTurno").show();
                        $("#select-profesional-frecuente-vc").show();
                    } else {
                        $("#btnVideoconsultaTurno").hide();
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

            //comportamiento boton consulta presencial y videoconsulta turno ->lleva al listado de turnos en la parte inferior
            $("#btnConsultaPresencial").click(function () {

                var idmedico = $(".select_prof_frecuente.active").data('id');
                if (parseInt(idmedico) > 0) {
                    var nombre = $(".select_prof_frecuente.active").data('nombre');
                    var apellido = $(".select_prof_frecuente.active").data('apellido');
                    window.location.href = BASE_PATH + "panel-paciente/profesionales/" + idmedico + "-" + nombre + "-" + apellido + ".html#modulo_listado_consultorios";
                } else {
                    x_alert(x_translate("Seleccione un profesional frecuente para solicitar el turno"));
                    return false;
                }
            });
            $("#btnVideoconsultaTurno").click(function () {
                if ($(this).data("permitido") != 1) {
                    x_alert(x_translate("Complete el Perfil de Salud para realizar a una Video Consulta"));
                    return false;
                }
                var idmedico = $(".select_prof_frecuente.active").data('id');
                if (parseInt(idmedico) > 0) {
                    var nombre = $(".select_prof_frecuente.active").data('nombre');
                    var apellido = $(".select_prof_frecuente.active").data('apellido');
                    window.location.href = BASE_PATH + "panel-paciente/profesionales/" + idmedico + "-" + nombre + "-" + apellido + ".html#modulo_listado_consultorios";
                } else {
                    x_alert(x_translate("Seleccione un profesional frecuente para solicitar el turno de Video Consulta"));
                    return false;
                }
            });
        });
    </script>
{/literal}
