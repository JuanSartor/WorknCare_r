<!-- end NAV -->
<nav class="paciente-nav">
    <div class="paciente-nav-container">
        <div class="paciente-nav-usr">
            <a href="{$url}panel-medico/perfil-profesional/" title='{"Información Profesional"|x_translate}' class="paciente-nav-trigger">				
                {if $imagen_medico && $imagen_medico.perfil != ""}
                    <img src="{$imagen_medico.perfil}?{$smarty.now}"  id="imagen_menu_privado_perfil">
                {else}
                    <img src="{$IMGS}extranet/noimage_perfil.png" id="imagen_menu_privado_perfil">
                {/if}
                <label><span id="nombre_menu_privado_perfil">{$medico.tituloprofesional} {$medico.nombre} {$medico.apellido}</span></label>
            </a>
        </div>

        <div class="paciente-nav-logo">
            <a href="{$url}panel-medico/" title="DoctorPlus">
                <img src="{$IMGS}logo_pass_bienetre_blanco.png" alt="DoctorPlus"/>
            </a>
        </div>
        <div class="paciente-nav-menu">
            <a id="paciente-nav-menu-burger" class="paciente-nav-menu-burger">
                {if $videoconsulta_notificaciones.notificacion_general>0 || $info_menu.cantidad_notificaciones > 0 || $cantidad_notificaciones.notificacion_general>0 || $info_menu.cantidad_pacientes==0}
                    {assign "show_got_msg" true}
                {/if}
                <figure class="gotmsg bounce" id="menu-gotmsg" {if $show_got_msg}style="display:block"{else}style="display:none"{/if}>
                </figure>

                <i class="icon-doctorplus-burger"></i>
            </a>
            <ul class="paciente-nav-menu-rsp" id="burger-menu">
                <li>
                    <a href="{$url}panel-medico/">
                        <i class="icon-doctorplus-home"></i>
                        <label>{"Home"|x_translate}</label>
                    </a>
                </li>

                <li>
                    <a href="{$url}panel-medico/mis-pacientes/" >
                        <i class="icon-doctorplus-pacientes"></i>
                        <label>{"Mis Pacientes"|x_translate}</label>
                        <div id="div_no_pacientes" class="shorcuts-counter">
                            {if $consultorios_completo==1 && $info_menu.cantidad_pacientes==0}
                                <span>!</span>
                            {/if}
                        </div>
                    </a>
                </li>
                <li class="visible-xs">
                    <a href="{$url}panel-medico/agenda/{if $proximo_turno_pendiente>0}?fecha={$proximo_turno_pendiente.fecha_formateada}&idconsultorio={$proximo_turno_pendiente.consultorio_idconsultorio}{/if}" >
                        <i class="icon-doctorplus-calendar"></i>
                        <label>{"Mi Agenda"|x_translate}</label>
                        <div id="div_shorcuts_cant_turnospendientes_xs"  class="shorcuts-counter">
                            {if $turnos_pendientes_notificaciones.cantidad_turnos_pendientes>0}
                                <span>{$turnos_pendientes_notificaciones.cantidad_turnos_pendientes}</span>
                            {/if}
                        </div>
                    </a>
                </li>
                <li class="hidden-xs">
                    <a href="{$url}panel-medico/agenda/agenda-semanal/{if $proximo_turno_pendiente>0}?fecha={$proximo_turno_pendiente.fecha_formateada}&idconsultorio={$proximo_turno_pendiente.consultorio_idconsultorio}{/if}" >
                        <i class="icon-doctorplus-calendar"></i>
                        <label>{"Mi Agenda"|x_translate}</label>
                        <div id="div_shorcuts_cant_turnospendientes"  class="shorcuts-counter">
                            {if $turnos_pendientes_notificaciones.cantidad_turnos_pendientes>0}
                                <span>{$turnos_pendientes_notificaciones.cantidad_turnos_pendientes}</span>
                            {/if}
                        </div>
                    </a>
                </li>


                <li>
                    <a href="{$url}panel-medico/consultaexpress/" >
                        <i class="icon-doctorplus-chat"></i>
                        <label>{"Consulta Express"|x_translate} </label>
                        <div id="div_shorcuts_cant_consultaexpress"  class="shorcuts-counter">
                            {if $cantidad_notificaciones.notificacion_general>0}
                                <span>{$cantidad_notificaciones.notificacion_general}</span>
                            {/if}
                        </div>
                    </a>
                </li>
                <li><a href="{$url}panel-medico/videoconsulta/" >
                        <i class="icon-doctorplus-video-call"></i>
                        <label>{"Video Consulta"|x_translate}</label>
                        <div id="div_shorcuts_cant_videoconsulta"  class="shorcuts-counter">
                            {if $videoconsulta_notificaciones.notificacion_general>0}
                                <span>{$videoconsulta_notificaciones.notificacion_general}</span>
                            {/if}
                        </div>
                    </a>
                </li>
                <li>
                    <a href="{$url}panel-medico/notificaciones/" >
                        <i class="fa fa-bell-o"></i>
                        <label>{"Notificaciones"|x_translate}</label>
                        <div id="div_shorcuts_cant_notificaciones"  class="shorcuts-counter">
                            {if $info_menu.cantidad_notificaciones > 0}
                                <span>{$info_menu.cantidad_notificaciones}</span>
                            {/if}
                        </div>
                    </a>
                </li>
                <li>
                    <a href="{$url}panel-medico/mi-cuenta/" >
                        <i class="icon-doctorplus-dollar-sheet"></i>
                        <label>{"Movimientos de Cuenta"|x_translate}</label>
                    </a>
                </li>
                <li>
                    <a href="{$url}panel-medico/busqueda-profesional/">
                        <i class="icon-doctorplus-search"></i>
                        <label>{"Buscador de profesionales"|x_translate}</label>
                    </a>
                </li>
                <li>
                    <a href="javascript:;" class="submenu open-submenu" >
                        <i class="icon-doctorplus-gear open-submenu"></i>
                        <label class="open-submenu">{"Configuración"|x_translate}</label>
                        <i class="fa fa-chevron-down open-submenu"></i>
                    </a>
                    <ul>
                        <li>
                            <a href="{$url}panel-medico/perfil-profesional/" >
                                <i class="icon-doctorplus-ficha-tecnica"></i>
                                <label>{"Información Profesional"|x_translate}</label>
                            </a>
                        </li>	
                        <li>
                            <a href="{$url}panel-medico/datos-administrador/">
                                <i class="icon-doctorplus-profile-sheet"></i> 
                                <label>{"Datos administrador"|x_translate} </label>
                            </a>
                        </li>
                        <li>
                            <a href="{$url}panel-medico/configuracion/" >
                                <i class="fa fa-cogs"></i>
                                <label>{"Servicios que ofrece"|x_translate} </label>
                            </a>
                        </li>
                        <li>
                            <a href="{$url}panel-medico/pagos-vencimientos/" >
                                <i class="icon-doctorplus-dollar-circular"></i>
                                <label>{"Pagos y vencimientos"|x_translate} </label>
                            </a>
                        </li>
                        <li>
                            <a href="{$url}panel-medico/consejos.html" >
                                <i class="icon-doctorplus-info-circle"></i>
                                <label>{"Consejos"|x_translate} </label>
                            </a>
                        </li>
                    </ul>
                </li>
                <li>
                    <a href="javascript:;"  title='{"Cerrar sesión"|x_translate}' class="btnSalir">
                        <i class="icon-doctorplus-onoff"></i>
                        <label>{"Cerrar sesión"|x_translate}</label>
                    </a>
                </li>

            </ul>
        </div>
    </div>
</nav>	
<!-- end NAV -->        
<script language="javascript" type="text/javascript">
    $(function () {
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
        $("#burger-menu li a.submenu").click(function (e) {
            e.preventDefault();
            $(this).toggleClass("open");
        });

    });
</script>   
{*si hay consultas pendientes de finalizacion mostramos el modal*}
{if $videoconsulta_notificaciones.pendientes_finalizacion>0 || $cantidad_notificaciones.pendientes_finalizacion>0}
    {if $videoconsulta_notificaciones.pendientes_finalizacion>0}
        {literal}
            <script>
                $(function () {
                    $(".btnSalir").on("click", function () {
                        $("#modal-videoconsulta-pendiente_finalizacion").modal('show');
                        $("#modal-videoconsulta-pendiente_finalizacion .from_logout_vc").val("1");
                    });
                });
            </script>
        {/literal}
    {/if}
    {if $cantidad_notificaciones.pendientes_finalizacion>0}
        {literal}
            <script>
                $(function () {
                    $(".btnSalir").on("click", function () {
                        $("#modal-consultaexpress-pendiente_finalizacion").modal('show');
                        $("#modal-consultaexpress-pendiente_finalizacion .from_logout_ce").val("1");
                    });
                });
            </script>
        {/literal}
    {/if}
{else}
    {literal}
        <script>
            $(function () {
                $(".btnSalir").on("click", function () {
                    if (window.sessionStorage) {
                        sessionStorage.setItem("mostrar_inputs", "1");
                    }
                    x_LogOut();
                });
            });
        </script>
    {/literal}
{/if}