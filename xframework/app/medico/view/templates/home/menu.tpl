
<div {*class="main-content"*}>
    <div class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-body"></div>
            </div><!-- /.modal-content -->
        </div><!-- /.modal-dialog -->
    </div><!-- /.modal -->
    <input type="hidden" id="shorcuts_cant_notificaciones" value="{$info_menu.cantidad_notificaciones}"/>
   

    {*Barra icono flotante mobile*}
    <nav id="float-nav" class="float-nav fn-usr visible-xs visible-sm">
        <div class="fn-box">

            <a href="javascript:;" class="fn-usr-trigger">
                {if $videoconsulta_notificaciones.notificacion_general>0 || $info_menu.cantidad_notificaciones > 0 || $cantidad_notificaciones.notificacion_general>0 || $info_menu.cantidad_pacientes==0}
                <figure class="gotmsg"></figure>
                {/if}
                <i class="icon-doctorplus-usr-menu"></i>
            </a>

            <div class="fn-menu">

                <ul class="fn-action-list">
                    <li>
                        <a href="{$url}panel-medico/busqueda-profesional/" class="fn-list-action-item fn-usr">
                            <i class="icon-doctorplus-search"></i>
                            <figure class="fn-tooltip">
                                <span class="fn-item-content">{"Profesionales"|x_translate}</span>
                                <span class="fn-arrow"></span>
                            </figure>
                        </a>
                    </li>

                    <li>
                        <a href="{$url}panel-medico/perfil-profesional/" class="fn-list-action-item">
                            <i class="icon-doctorplus-sheet-edit"></i>
                            <figure class="fn-tooltip"> 
                                <span class="fn-item-content">{"Info Profesional y Comercial"|x_translate}</span>
                                <span class="fn-arrow"></span>
                            </figure>
                        </a>
                    </li>
                    <li>
                        <a href="{$url}panel-medico/mis-pacientes/" class="fn-list-action-item fn-usr">
                            {if $info_menu.cantidad_pacientes == 0}
                            <figure class="gotmsg"></figure>
                            {/if}
                            <i class="icon-doctorplus-pacientes"></i>
                            <figure class="fn-tooltip">

                                <span class="fn-item-content">{"Mis Pacientes"|x_translate}</span>
                                <span class="fn-arrow"></span>
                            </figure>
                        </a>
                    </li>
                    <li>
                        <a href="{$url}panel-medico/agenda/" class="fn-list-action-item fn-usr">


                            <i class="icon-doctorplus-calendar"></i>

                            <figure class="fn-tooltip">
                                <span class="fn-item-content">{"Mi Agenda"|x_translate}</span>
                                <span class="fn-arrow"></span>
                            </figure>
                        </a>
                    </li>

                    <li>
                        <a href="{$url}panel-medico/videoconsulta/" id="icono_float_videoconsulta" class="fn-list-action-item fn-usr">
                            {if $videoconsulta_notificaciones.notificacion_general>0}
                            <figure class="gotmsg"></figure>
                            {/if}
                            <i class="icon-doctorplus-video-call"></i>

                            <figure class="fn-tooltip">
                                <span class="fn-item-content">{"Video Consulta"|x_translate}</span>
                                <span class="fn-arrow"></span>
                            </figure>
                        </a>
                    </li>
                    <li>
                        <a href="{$url}panel-medico/consultaexpress/" id="icono_float_consultaexpress" class="fn-list-action-item fn-usr">
                            {if $cantidad_notificaciones.notificacion_general>0}
                            <figure class="gotmsg"></figure>
                            {/if}
                            <i class="icon-doctorplus-chat"></i>

                            <figure class="fn-tooltip">
                                <span class="fn-item-content">{"Consulta Express"|x_translate}</span>
                                <span class="fn-arrow"></span>
                            </figure>
                        </a>
                    </li>
                    <li>
                        <a href="{$url}panel-medico/notificaciones/" id="icono_float_notificaciones" class="fn-list-action-item fn-usr">
                            {if $info_menu.cantidad_notificaciones > 0}
                            <figure class="gotmsg"></figure>
                            {/if}
                            <i class="icon-doctorplus-flag"></i>

                            <figure class="fn-tooltip">
                                <span class="fn-item-content">{"Notificaciones"|x_translate}</span>
                                <span class="fn-arrow"></span>
                            </figure>
                        </a>
                    </li>
                    <li>
                        <a href="{$url}panel-medico/mi-cuenta/" class="fn-list-action-item">


                            <i class="icon-doctorplus-sheet"></i>

                            <figure class="fn-tooltip">
                                <span class="fn-item-content">{"Movimientos de Cuenta"|x_translate}</span>
                                <span class="fn-arrow"></span>
                            </figure>
                        </a>
                    </li>

                </ul>
                <a href="javascript:;" class="fn-close"><i class="icon-doctorplus-cruz"></i></a>
            </div>
        </div>
    </nav>	
</div>
{literal}
<script>
    $(function () {

        //codigo JS asociado a la barra de iconos flotante
        if ($('#float-nav').length > 0) {

            $('.fn-usr-trigger').on('click', function (e) {
                e.preventDefault();

                $(this).hide().next('.fn-menu').slideDown();
            });

            $('.fn-close').on('click', function (e) {
                $(this).parent().slideUp(function () {
                    $(this).prev('.fn-usr-trigger').fadeIn();
                });


            });

            $('.fn-mdc-usr-trigger').on('click', function (e) {
                e.preventDefault();
                $(this).toggleClass('selected-submenu');
                $(this).next('.fn-mdc-usr-holder').fadeToggle();
            });


        }
        //FIN codigo JS  barra de iconos flotante
    });
</script>
{/literal}