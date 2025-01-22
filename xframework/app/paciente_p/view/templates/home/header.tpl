
<!-- end NAV -->
<nav class="paciente-nav">
    <div class="paciente-nav-container">
        {include file="home/header_miembros_select.tpl"}

        <div class="paciente-nav-logo">
            <a href="{$url}" title="DoctorPlus">
                <img src="{$IMGS}logo_pass_bienetre_blanco.png" alt="PassBienEtre"/>
            </a>
        </div>
        <div class="paciente-nav-menu">
            <a class="paciente-nav-menu-burger" id="paciente-nav-menu-burger">
                {if $videoconsulta_notificaciones.notificacion_general>0 || $info_menu.cantidad_notificaciones > 0 || $cantidad_notificaciones.notificacion_general>0}
                    {assign "show_got_msg" true}
                {/if}
                <figure class="gotmsg bounce" id="menu-gotmsg" {if $show_got_msg}style="display:block"{else}style="display:none"{/if}>
                </figure>
                <i class="icon-doctorplus-burger"></i>
            </a>
            <ul class="paciente-nav-menu-rsp" id="burger-menu">
                <li>
                    <a href="{$url}">
                        <i class="icon-doctorplus-home"></i>
                        <label>{"Home"|x_translate}</label>
                    </a>
                </li>
                <li>
                    <a href="{$url}panel-paciente/miembros/" class="fn-list-action-item {*fn-mdc-usr-trigger*}">
                        <i class="icon-doctorplus-usr-group"></i>
                        <label>{"Miembros"|x_translate}</label>
                    </a>
                </li>
                <li>
                    <a href="{$url}panel-paciente/busqueda-profesional/" class="fn-list-action-item fn-usr">
                        <i class="icon-doctorplus-search"></i>
                        <label>{"Buscador de profesionales"|x_translate}</label>
                    </a>
                </li>

                <li>
                    <a href="{$url}panel-paciente/perfil-salud/" class="fn-list-action-item fn-usr">
                        <i class="icon-doctorplus-pharmaceutics"></i>
                        <label>{"Informes médicos"|x_translate}</label>
                    </a>
                </li>
                <li>
                    <a href="{$url}panel-paciente/profesionales-frecuentes/" class="fn-list-action-item fn-usr">
                        <i class="icon-doctorplus-user-add-like"></i>
                        <label>{"Profesionales Frecuentes"|x_translate}</label>
                    </a>
                </li>
                <!-- <li>
                     <a href="{$url}patient/programmes-bienetre.html" class="fn-list-action-item ">
                         <i><img class="white pass" src="{$IMGS}pass_bienetre_icon_blank.png"></i>
                         <label>{"PROGRAMAS DE SALUD"|x_translate}</label>
                     </a>
                 </li> -->
                <li>
                    <a href="{$url}panel-paciente/consultaexpress/" id="icono_float_consultaexpress" class="fn-list-action-item fn-usr">
                        <i class="icon-doctorplus-chat"></i>

                        <label>{"Consulta Express"|x_translate}</label>
                        <div id="div_shorcuts_cant_consultaexpress" class="shorcuts-counter">
                            {if $cantidad_notificaciones.notificacion_general>0}
                                <span>{$cantidad_notificaciones.notificacion_general}</span>
                            {/if}
                        </div>
                    </a>
                </li>
                <li>
                    <a href="{$url}panel-paciente/videoconsulta/"  id="icono_float_videoconsulta" class="fn-list-action-item fn-usr">
                        <i class="icon-doctorplus-video-call"></i>
                        <label>{"Video Consulta"|x_translate}</label>
                        <div id="div_shorcuts_cant_videoconsulta" class="shorcuts-counter">
                            {if $videoconsulta_notificaciones.notificacion_general>0}
                                <span>{$videoconsulta_notificaciones.notificacion_general}</span>
                            {/if}
                        </div>
                    </a>
                </li>
                <li>
                    <a href="{$url}panel-paciente/notificaciones/" id="icono_float_notificaciones" class="fn-list-action-item fn-usr">
                        <i class="fa fa-bell-o"></i>
                        <label>{"Notificaciones"|x_translate}</label>
                        <div id="div_shorcuts_cant_notificaciones" class="shorcuts-counter">
                            {if $info_menu.cantidad_notificaciones>0}
                                <span>{$info_menu.cantidad_notificaciones}</span>
                            {/if}
                        </div>
                    </a>
                </li>
                <li>
                    <a href="{$url}panel-paciente/estado-cuenta/" class="fn-list-action-item fn-usr">
                        <i class="icon-doctorplus-dollar-circular"></i> 
                        <label>{"Estado de cuenta"|x_translate} </label>
                    </a>
                </li>
                {if $account.user.empresa.tipo_cuenta == "2" } 
                    <li>
                        <a href="{$url}pass-bienetre/factures.html">
                            <i class="icon-doctorplus-dollar-sheet"></i>
                            <label>{"Facturas"|x_translate}</label>
                        </a>
                    </li>
                {/if}
                <li>
                    <a href="javascript:;" class="submenu open-submenu" >
                        <i class="icon-doctorplus-gear open-submenu"></i>
                        <label class="open-submenu">{"Configuración"|x_translate}</label>
                        <i class="fa fa-chevron-down open-submenu"></i>
                    </a>
                    <ul>
                        <li>
                            <a href="{$url}panel-paciente/informacion-paciente/" >
                                <i class="icon-doctorplus-ficha-tecnica"></i>
                                <label>{"Información del paciente"|x_translate}</label>
                            </a>
                        </li>
                        <li>
                            <a  href="{$url}panel-paciente/datos-administrador/" >
                                <i class="icon-doctorplus-profile-sheet"></i> 
                                <label>{"Datos administrador"|x_translate} </label>
                            </a>
                        </li>
                        <li>
                            <a  href="{$url}panel-paciente/privacidad/" >
                                <i class="icon-doctorplus-unlock"></i> 
                                <label>{"CONFIGURACIÓN DE PRIVACIDAD"|x_translate} </label>
                            </a>
                        </li>
                        <li>
                            <a  href="{$url}panel-paciente/guia-de-uso/" >
                                <i class="icon-doctorplus-info-circle"></i> 
                                <label>{"Preguntas frecuentes"|x_translate} </label>
                            </a>
                        </li>
                    </ul>
                </li>
                <li>
                    <a href="javascript:;" data-idioma="{$TRADUCCION_DEFAULT}"  title='{"Cerrar sesión"|x_translate}' class="btnSalir">
                        <i class="icon-doctorplus-onoff"></i>
                        <label>{"Cerrar sesión"|x_translate}</label>
                    </a>
                </li>
            </ul>
        </div>
    </div>
</nav>	
<!-- end NAV -->     
{literal}   
    <script language="javascript" type="text/javascript">
        $(function () {



            /* $('.paciente-nav-trigger').on('click', function (e) {
             e.preventDefault();
             $pacienteMenu = $('#paciente-menu');
             $pacienteMenu.toggleClass('menu-show');
             
             });*/

            //abrir menu desplegable
            $('.paciente-nav-menu-burger').on('click', function (e) {
                e.preventDefault();
                var vpw = $(window).width() + getScrollBarWidth();
                $burgerMenu = $('#burger-menu');
                $burgerMenu.toggleClass('menu-show');
            });

            //litener cerrar menu - click fuera
            $(document).on('click', function (event) {
                if ((!$(event.target).closest('.paciente-nav-menu-burger').length) && $('.paciente-nav-menu-burger').is(':visible') && !$(event.target).hasClass("open-submenu")) {
                    $('#burger-menu').removeClass('menu-show');
                    $("#burger-menu li a.submenu").removeClass('open');
                }
            });
            //abrir submenu
            $("#burger-menu li .submenu").click(function (e) {
                e.preventDefault();
                $("#burger-menu li a.submenu").toggleClass("open");
            });



            $('.btnSalir').on("click", function () {
                if ($(this).data("idioma") == 'fr') {
                    x_LogOut();
                } else {
                    x_LogOutEN();
                }
            });


        });
    </script>        
{/literal}