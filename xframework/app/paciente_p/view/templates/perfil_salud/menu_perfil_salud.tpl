{if $paciente.animal!=1}
    <nav class="tablero-box" style="bottom: 70px;">


        <input type="hidden" id="item_menu" value="{$item_menu}" />
        <input type="hidden" id="sexo" value="{$paciente.sexo}" />
        <div class="container ">
            <div class="row">
                {*
                <div class="col-xs-3 col-sm-2 col-md-1">

                <a href="{$url}panel-paciente/perfil-salud/" role="button" class="tablero-box-icon"><i class="dpp-grid"></i></a>
                <a href="">
                {if $paciente.image.perfil != ""}
                <img src="{$paciente.image.perfil}?{$smarty.now}" alt="{$paciente.nombre} {$paciente.apellido}">
                {else}
                <img src="{$IMGS}extranet/noimage-paciente.jpg " alt="{$paciente.nombre} {$paciente.apellido}">
                {/if}
                </a>					
                
                </div>*}
                <div class="col-xs-2 col-sm-1 col-md-1">
                    <a href="javascript:;" class="slider-arrow slider-menu-prev"></a>
                </div>	
                <div class="col-xs-8 col-sm-10 col-md-10">
                    <ul id="menu_perfil_salud" class="slider-menu">
                        {*<li><a href="{$url}panel-paciente/consultaexpress/" title='{"Consulta Express"|x_translate}'><i class="dpp-express"></i>{if $ConsultaExpressPermitida=="1"}<span class="green"><i class="fui-check"></i></span>{else}<span><strong>-</strong></span>{/if}</a></li>*}
                        {*<li><a href="{$url}panel-paciente/videoconsulta/" title='{"Video Consulta"|x_translate}'><i class="icon-doctorplus-video-call"></i>{if $VideoConsultaPermitida=="1"}<span class="green"><i class="fui-check"></i></span>{else}<span><strong>-</strong></span>{/if}</a></li>*}
                        <li><a href="{$url}panel-paciente/perfil-salud/registro-consultas-medicas.html" title='{"Registro consultas médicas"|x_translate}'><i class="dpp-consulta"></i></a></li>
                        <li><a href="{$url}panel-paciente/perfil-salud/controles-chequeos.html"  title='{"Controles y Chequeos"|x_translate}' class="icon-notificaciones" ><i class="dpp-chequeos"></i><div id="div_shorcuts_cant_notificaciones_controles">{if $info_menu.cantidad_controles_chequeos > 0}<span>{$info_menu.cantidad_controles_chequeos}</span>{/if}</div></a></li>
                        <li><a href="{$url}panel-paciente/perfil-salud/estudios-imagenes.html" title='{"Estudios e Imágenes"|x_translate}'><i class="fui-clip"></i></a></li>
                        <li><a href="{$url}panel-paciente/perfil-salud/medicacion.html" title='{"Medicamentos"|x_translate}'><i class="dpp-medicina"></i></a></li>
                        <li><a href="{$url}panel-paciente/perfil-salud/datos-biometricos.html" title='{"Datos biométricos"|x_translate}' {if $estadoTablero.datosbiometricos==0}class="alert"{/if}><i class="dpp-male"></i></a></li>
                        <li><a href="{$url}panel-paciente/perfil-salud/enfermedades-patologias.html"  title='{"Enfermedades y Patologías"|x_translate}' {if $estadoTablero.enfermedades==0 || $estadoTablero.patologias==0}class="alert"{/if}><i class="dpp-patologia"></i></a></li>
                        <li><a href="{$url}panel-paciente/perfil-salud/antecedentes.html" title='{"Antecedentes"|x_translate}' {if $estadoTablero.antecedentes_familiares==0 || $estadoTablero.antecedentes_pediatricos==0}class="alert"{/if}><i class="dpp-dna"></i></a></li>
                        <li><a href="{$url}panel-paciente/perfil-salud/alergias-intolerancias.html" title='{"Alergias e Intolerancias"|x_translate}' {if $estadoTablero.alergias_intolerancias==0}class="alert"{/if}><i class="dpp-alergia"></i></a></li>
                                {if $paciente.sexo == 0}
                            <li><a href="{$url}panel-paciente/perfil-salud/ginecologico-obstetrico.html" title='{"Ginecológico y Obstétrico"|x_translate}' {if $estadoTablero.ginecologico_controles=="0" || $estadoTablero.ginecologico_embarazo=="0" ||$estadoTablero.ginecologico_antecedentes=="0"}class="alert"{/if}><i class="dpp-ginecologia"></i></a></li>
                                {/if}
                        <li><a href="#{*{$url}panel-paciente/perfil-salud/vacunas.html*}" title='{"Vacunas"|x_translate}'><i class="dpp-vacuna"></i></a></li>
                        <li><a href="{$url}panel-paciente/perfil-salud/cirugias-protesis.html" title='{"Cirugías y Prótesis"|x_translate}'><i class="dpp-cirugia"></i></a></li>
                        <li><a href="{$url}panel-paciente/perfil-salud/control-visual.html"  title='{"Visión"|x_translate}'><i class="dpp-ojo"></i></a></li>
                        <li><a href="{$url}panel-paciente/perfil-salud/estilo-vida.html" title='{"Estilo de Vida"|x_translate}'><i class="dpp-sonrisa"></i></a></li>
                        <li><a href="{$url}panel-paciente/perfil-salud/control-dental.html" title='{"Dental"|x_translate}'><i class="dpp-dental"></i></a></li>
                        <li><a href="{$url}panel-paciente/perfil-salud/control-auditivo.html" title='{"Oido"|x_translate}'><i class="dpp-oido"></i></a></li>
                    </ul>
                </div>	
                <div class="col-xs-2 col-sm-1 col-md-1">
                    <a href="javascript:;" class="slider-arrow slider-menu-next"></a>
                </div>				

            </div>	
        </div>
    </nav>


    <!--	ALERTAS - Perfil de Salud completo - felicitaciones	-->


    <div id="modal-completo-perfil-salud" data-load="no" class="modal fade bs-example-modal-lg modal-perfil-completo" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title">{"¡Felicitaciones!"|x_translate}</h4>
                </div>
                <div class="modal-body">
                    <p>
                        {"Se encuentra habilitado para realizar consultas médicas a distancia."|x_translate}

                    </p>
                    <div class="modal-perfil-completo-action-holder">
                        <button onclick="window.location.href = '{$url}panel-paciente/consultaexpress/nuevaconsulta.html'" ><i class="icon-doctorplus-chat"></i>{"Consulta Express"|x_translate}</button>
                        <button onclick="window.location.href = '{$url}panel-paciente/videoconsulta/nuevavideoconsulta.html'" ><i class="icon-doctorplus-video-call"></i>{"Video Consulta"|x_translate}</button>

                    </div>
                </div>
            </div>
        </div>
    </div>	

    <!--	ALERTAS - Perfil de Salud incompleto - completar	-->


    <div id="modal-perfil-salud-incompleto" data-load="no" class="modal fade bs-example-modal-lg modal-perfil-completo" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title">{"Las secciones indicadas en color tienen datos importantes"|x_translate}</h4>
                </div>
                <div class="modal-body">

                    <div class="tablero-box" style="background-color:#fff">
                        <ul id="secciones_ps_incompleto" class="slider-menu">

                            <li><a href="{$url}panel-paciente/perfil-salud/datos-biometricos.html" title='{"Datos biométricos"|x_translate}' {if $estadoTablero.datosbiometricos==0}class="alert" style="display:block;"{else}style="display:none;"{/if}><i class="dpp-male"></i></a></li>
                            <li><a href="{$url}panel-paciente/perfil-salud/enfermedades-patologias.html"  title='{"Enfermedades y Patologías"|x_translate}' {if $estadoTablero.enfermedades==0 || $estadoTablero.patologias==0}class="alert" style="display:block;"{else}style="display:none;"{/if}><i class="dpp-patologia"></i></a></li>
                            <li><a href="{$url}panel-paciente/perfil-salud/antecedentes.html" title='{"Antecedentes"|x_translate}'  {if $estadoTablero.antecedentes_familiares==0 || $estadoTablero.antecedentes_pediatricos==0}class="alert" style="display:block;"{else}style="display:none;"{/if}><i class="dpp-dna"></i></a></li>
                            <li><a href="{$url}panel-paciente/perfil-salud/alergias-intolerancias.html" title='{"Alergias e Intolerancias"|x_translate}' {if $estadoTablero.alergias_intolerancias==0}class="alert" style="display:block;"{else}style="display:none;"{/if}><i class="dpp-alergia"></i></a></li>
                                    {if $paciente.sexo == 0}
                                <li><a href="{$url}panel-paciente/perfil-salud/ginecologico-obstetrico.html" title='{"Ginecológico y Obstétrico"|x_translate}'  {if $estadoTablero.ginecologico_controles=="0" || $estadoTablero.ginecologico_embarazo=="0" ||$estadoTablero.ginecologico_antecedentes=="0"}class="alert" style="display:block;"{else}style="display:none;"{/if}><i class="dpp-ginecologia"></i></a></li>
                                    {/if}

                        </ul>

                    </div>

                    <div class="text-center">
                        <strong class="">
                            {"Completa los datos y queda habilitado para efectuar Video Consultas o Consultas Express"|x_translate}

                        </strong>
                    </div>
                    <div class="clearfix">&nbsp;</div>
                    <div class="">
                        <label class="checkbox">
                            <input type="checkbox"  id="no_mostrar_secciones_ps_incompleto">
                            {"No volver a mostrar este mensaje"|x_translate}
                        </label>

                    </div>
                </div>
            </div>
        </div>
    </div>

    {literal}
        <script type="text/javascript">

            $(document).ready(function () {
                actualizar_menu_status_perfilsalud();
                /*
                 if ($("#secciones_ps_incompleto .alert").length > 0 && window.localStorage.getItem('no_mostrar_secciones_ps_incompleto') != 1) {
                 $("#modal-perfil-salud-incompleto").modal("show");
                 }
                 $("#no_mostrar_secciones_ps_incompleto").click(function () {
                 console.log("no mostrar");
                 $("#modal-perfil-salud-incompleto").modal("hide");
                 window.localStorage.setItem('no_mostrar_secciones_ps_incompleto', 1);
                 });*/


                $('#menu_perfil_salud').slick({
                    centerMode: false,
                    dots: false,
                    draggable: false,
                    focusOnSelect: false,
                    infinite: false,
                    nextArrow: '.slider-menu-next',
                    prevArrow: '.slider-menu-prev',
                    slidesToScroll: 11,
                    slidesToShow: 11,
                    touchMove: false,
                    responsive: [
                        {
                            breakpoint: 1024,
                            settings: {slidesToShow: 6, slidesToScroll: 6}
                        },
                        {
                            breakpoint: 768,
                            settings: {slidesToShow: 4, slidesToScroll: 4}
                        },
                        {
                            breakpoint: 600,
                            settings: {slidesToShow: 3, slidesToScroll: 3}
                        },
                        {
                            breakpoint: 480,
                            settings: {slidesToShow: 3, slidesToScroll: 1}
                        }
                    ]
                });


                if ($("#item_menu").val() != "") {
                    $(".slider").find(".icon-svg.circle." + $("#item_menu").val()).addClass("active");
                }
            });
        </script>
    {/literal}
{/if}