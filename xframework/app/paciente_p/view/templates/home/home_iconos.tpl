<section style="margin-top: 0px !important;"  class="consulta-express-submenu home homepaciente homepaciente-nueva" id="home-iconos-container">
    <div class="">

        <div class="">
            <div class="menu-consulta-item menu-consulta-item-inicio">
                <div class="consulta-express-submenu-icon-holder-lg menu-consulta-item-nuevo">
                    <a href="{$url}panel-paciente/consultaexpress/">
                        <div  id="">
                            <figure class="figura-nueva"><i class="icon-doctorplus-chat i-nuevo"></i></figure>
                        </div>
                        <div id="div_home_cant_consultaexpress">
                            {if $cantidad_notificaciones.notificacion_general>0}
                                <div>
                                    <span class="div-span-nuevo">{$cantidad_notificaciones.notificacion_general}</span>
                                </div>
                            {/if}

                        </div>
                        <span class="span-nuevo">{"TCHAT"|x_translate}</span>
                    </a>
                </div>
                <div class="consulta-express-submenu-icon-holder-lg menu-consulta-item-nuevo">
                    <a href="{$url}panel-paciente/videoconsulta/" class="videoconsulta-home-iconos">
                        <div  id="">
                            <figure class="figura-nueva"><i class="icon-doctorplus-video-call i-nuevo"></i></figure>
                            <span class="mvc-entrar-sala mvc-cam-animation" {if $videoconsulta_notificaciones.en_curso==0}style="display:none;"{/if} ><i class="icon-doctorplus-video-cam"></i></span>

                        </div>
                        <div id="div_home_cant_videoconsulta">
                            {if $videoconsulta_notificaciones.notificacion_general>0}
                                <div>
                                    <span class="div-span-nuevo">{$videoconsulta_notificaciones.notificacion_general}</span> 
                                </div>
                            {/if}
                        </div>
                        <span class="span-nuevo">{"Video Consultas"|x_translate}</span>
                    </a>
                </div>
                <!--   <div class="consulta-express-submenu-icon-holder-lg">
                       <a href="{$url}panel-paciente/notificaciones/">
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
    </div> -->

            </div>
        </div>

    </div>
</section>
{literal}
    <script>
        $(function () {
            //si hay VC habilitada, llevamos directamente al consultorio
            $(".videoconsulta-home-iconos").click(function (e) {
                e.preventDefault();
                if ($(".videoconsulta-home-iconos .mvc-entrar-sala").is(":visible")) {
                    window.location.href = BASE_PATH + "panel-paciente/videoconsulta/sala/";
                } else {
                    window.location.href = BASE_PATH + "panel-paciente/videoconsulta/";
                }
            });
        });
    </script>
{/literal}