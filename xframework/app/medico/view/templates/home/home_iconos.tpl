<section class="consulta-express-submenu home homepaciente" id="home-iconos-container">
    <div class="container">

        <div class="row">
            <div class="col-sm-12">
                <h1>{"Consulte con sus pacientes por mensaje o video"|x_translate}</h1>
            </div>
            <div class="col-sm-12  menu-consulta-item">
                <div class="consulta-express-submenu-icon-holder-lg">
                    <a href="{$url}panel-medico/consultaexpress/">
                        <div id="">
                            <figure><i class="icon-doctorplus-chat"></i></figure>
                        </div>
                        <div id="div_home_cant_consultaexpress">
                            {if $cantidad_notificaciones.notificacion_general>0}
                                <span>{$cantidad_notificaciones.notificacion_general}</span>
                            {/if}

                        </div>
                        <span>{"CONSULTA EXPRESS"|x_translate}</span>
                    </a>
                </div>
                <div class="consulta-express-submenu-icon-holder-lg">
                    <a href="{$url}panel-medico/videoconsulta/">
                        <div id="">
                            <figure><i class="icon-doctorplus-video-call"></i></figure>
                            <span class="mvc-entrar-sala  mvc-cam-animation"  {if $videoconsulta_notificaciones.en_curso==0}style="display:none;"{/if} ><i class="icon-doctorplus-video-cam"></i></span>
                        </div>
                        <div id="div_home_cant_videoconsulta">
                            {if $videoconsulta_notificaciones.notificacion_general>0}
                                <span>{$videoconsulta_notificaciones.notificacion_general}</span> 
                            {/if}
                        </div>
                        <span>{"VIDEO CONSULTA"|x_translate}</span>
                    </a>
                </div>
                <div class="consulta-express-submenu-icon-holder-lg">
                    <a href="{$url}panel-medico/agenda/{if $proximo_turno_pendiente>0}?fecha={$proximo_turno_pendiente.fecha_formateada}&idconsultorio={$proximo_turno_pendiente.consultorio_idconsultorio}{/if}" class="visible-xs">
                        <div id="">
                            <figure><i class="icon-doctorplus-calendar"></i></figure>                     
                        </div>
                        <div id="div_home_cant_turnospendientes_xs">
                            {if $turnos_pendientes_notificaciones.cantidad_turnos_pendientes>0}
                                <span>{$turnos_pendientes_notificaciones.cantidad_turnos_pendientes}</span>
                            {/if}
                        </div>

                        <span>{"Agenda"|x_translate}</span>
                    </a>
                    <a href="{$url}panel-medico/agenda/agenda-semanal/{if $proximo_turno_pendiente>0}?fecha={$proximo_turno_pendiente.fecha_formateada}&idconsultorio={$proximo_turno_pendiente.consultorio_idconsultorio}{/if}" class="hidden-xs">
                        <div id="">
                            <figure><i class="icon-doctorplus-calendar"></i></figure>
                        </div>
                        <div id="div_home_cant_turnospendientes">
                            {if $turnos_pendientes_notificaciones.cantidad_turnos_pendientes>0}
                                <span>{$turnos_pendientes_notificaciones.cantidad_turnos_pendientes}</span>
                            {/if}

                        </div>

                        <span>{"Agenda"|x_translate}</span>
                    </a>
                </div>
                <div class="consulta-express-submenu-icon-holder-lg">
                    <a href="{$url}panel-medico/notificaciones/">
                        <div id="">
                            <figure><i class="fa fa-bell-o"></i></figure>
                        </div>
                        <div id="div_home_cant_notificaciones">
                            {if $info_menu.cantidad_notificaciones > 0}
                                <span>{$info_menu.cantidad_notificaciones}</span>
                            {/if}
                        </div>
                        <span>{"NOTIFICACIONES"|x_translate}</span>
                    </a>
                </div>
            </div>
        </div>
    </div>
    {if $medico_vacaciones.hasta!=""}
        <div class="container vacaciones-medico-container">
            <div class="label-container">

                <p>{"Usted se encuentra de vacaciones hasta el"|x_translate}&nbsp;{$medico_vacaciones.hasta_format}.</p>
                <p>{"Si desea gestionar sus vacaciones haga click en el siguiente boton."|x_translate}</p>
            </div>
            <div class="button-container">
                <button class="btn btn-default btn-primary" onclick="window.location.href = '{$url}professionnel/agenda/vacances.html';">{"Gestionar mis vacaciones"|x_translate}</button>
            </div>
        </div>
    {/if}
</section>