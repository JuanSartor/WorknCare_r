{if $submodulo != "miembros_list"}
{if  $submodulo == "home_new" && $paciente.titular==1 &&  $paciente.beneficios_reintegro==1 && $paciente.pais_idpais==1 && $paciente.cobertura_facturacion_step!=4}
{*no mostrar menu-mostramos wizard cobertura facturacion*}
{else}
   
<input type="hidden" id="shorcuts_cant_notificaciones" value="{$info_menu.cantidad_notificaciones}"/>
<section id="shortcuts_original" class="user-actions user-paciente {if $submodulo =="home_new" || $modulo =="turno"}hidden{else}hidden-xs hidden-sm{/if}" >
    <div class="container">
        <ul>
            <li><a href="{$url}panel-paciente/miembros/" class="dp-miembro" title='{"Miembros"|x_translate}'><p>{"Miembros"|x_translate}</p></a></li>
            <li><a href="{$url}panel-paciente/busqueda-profesional/" class="dp-search" title='{"Buscador de profesionales"|x_translate}' ><p>{"Buscador de profesionales"|x_translate}</p></a></li>
            <li><a href="{$url}panel-paciente/informacion-paciente/" class="dp-user" title='{"Información del paciente"|x_translate}'><p>{"Información del paciente"|x_translate}</p></a></li>			
            <li><a href="{$url}panel-paciente/perfil-salud/" class="dp-health-info" title='{"Perfil de Salud"|x_translate}'><p>{"Perfil de Salud"|x_translate}</p></a></li>
            <li><a href="{$url}panel-paciente/profesionales-frecuentes/" class="dp-frequent-dr" title='{"Profesionales frecuentes"|x_translate}'><p>{"Profesionales frecuentes"|x_translate}</p></a></li>
            <li  {if $paciente.is_permitido!=1}class="inactive"{/if}><a href="{$url}panel-paciente/videoconsulta/" class="icon-doctorplus-video-call"  title='{"Video Consulta"|x_translate}'><p>{"Video Consulta"|x_translate}</p>{if $paciente.is_permitido!=1}<small><i class="icon-doctorplus-lock"></i></small>{/if}
                    <div id="div_shorcuts_cant_videoconsulta">
                        {if $videoconsulta_notificaciones.notificacion_general>0}
                        <span>{$videoconsulta_notificaciones.notificacion_general}</span>
                        {/if}
                    </div>
                </a></li>
            <li  {if $paciente.is_permitido!=1}class="inactive"{/if}><a href="{$url}panel-paciente/consultaexpress/" class="dp-express" title='{"Consulta Express"|x_translate}'><p>{"Consulta Express"|x_translate}</p>{if $paciente.is_permitido!=1}<small><i class="icon-doctorplus-lock"></i></small>{/if}
                    <div id="div_shorcuts_cant_consultaexpress">
                        {if $cantidad_notificaciones.notificacion_general>0}
                        <span>{$cantidad_notificaciones.notificacion_general}</span>
                        {/if}
                    </div>
                </a></li>			
            <li>
                <a href="{$url}panel-paciente/notificaciones/" class="dpp-flag" title='{"Notificaciones"|x_translate}'><p>{"Notificaciones"|x_translate}</p> 
                    <div id="div_shorcuts_cant_notificaciones">
                        {if $info_menu.cantidad_notificaciones>0}
                        <span>{$info_menu.cantidad_notificaciones}</span>
                        {/if}
                    </div>
                </a>
            </li>
        </ul>
    </div>
</section>
{/if}

<nav id="float-nav" class="float-nav fn-mdc  {if $submodulo !="home_new"}visible-xs visible-sm{/if}" >
    <div class="fn-box">

        <a href="javascript:;" class="fn-usr-trigger">
                    {if $videoconsulta_notificaciones.notificacion_general>0 || $info_menu.cantidad_notificaciones > 0 || $cantidad_notificaciones.notificacion_general>0}
                <figure class="gotmsg"></figure>
                {/if}
            <i class="icon-doctorplus-usr-menu"></i>
        </a>

        <div class="fn-menu">

            <ul class="fn-action-list">
              
                <li>
                    <a href="{$url}panel-paciente/miembros/" class="fn-list-action-item {*fn-mdc-usr-trigger*}">
                        <i class="icon-doctorplus-usr-group"></i>
                           <figure class="fn-tooltip">
                            <span class="fn-item-content">{"Miembros"|x_translate}</span>
                            <span class="fn-arrow"></span>
                        </figure>
                    </a>
                    {*<div class="fn-mdc-usr-holder">
                        <ul>
                             {if $header_info.all_members|@count>1}
                            <li>
                                 <a href="javascript:;" onclick="window.location.href='{$url}panel-paciente/miembros/'">                             
                               <figure class="menu-float-usr-icon"><span>T</span></figure>
                            </a> 
                            </li>
                            {/if}
                            {foreach from=$header_info.all_members item=miembro} 
                            {if $paciente.idpaciente != $miembro.idpaciente}

                            <li class="select_member" data-id="{$miembro.idpaciente}">
                                {if $miembro.image.perfil != ""}
                                <a href="javascript:;"><img src="{$miembro.image.perfil}" alt="{$miembro.nombre_corto}" title="{$miembro.nombre} {$miembro.apellido}"/></a>
                                {else}
                                <a href="javascript:;"><img src="{$IMGS}extranet/noimage-paciente.jpg" alt="{$miembro.nombre_corto}" title="{$miembro.nombre} {$miembro.apellido}"/></a>

                                {/if}
                            </li>
                           
                            {/if}
                            {/foreach}
                            
                            
                           
                        </ul>
                    </div>
                    *}
                </li>
                
                <li>
                    <a href="{$url}panel-paciente/busqueda-profesional/" class="fn-list-action-item fn-usr">


                        <i class="icon-doctorplus-search"></i>


                        <figure class="fn-tooltip">
                            <span class="fn-item-content">{"Buscador de profesionales"|x_translate}</span>
                            <span class="fn-arrow"></span>
                        </figure>
                    </a>
                </li>

                <li>
                    <a href="{$url}panel-paciente/informacion-paciente/" class="fn-list-action-item fn-usr">


                        <i class="dp-user"></i>

                        <figure class="fn-tooltip">
                            <span class="fn-item-content">{"Informacion del paciente"|x_translate}</span>
                            <span class="fn-arrow"></span>
                        </figure>
                    </a>
                </li>
                <li>
                    <a href="{$url}panel-paciente/perfil-salud/" class="fn-list-action-item fn-usr">


                        <i class="icon-doctorplus-pharmaceutics"></i>

                        <figure class="fn-tooltip">
                            <span class="fn-item-content">{"Perfil de Salud"|x_translate}</span>
                            <span class="fn-arrow"></span>
                        </figure>
                    </a>
                </li>
                <li>
                    <a href="{$url}panel-paciente/profesionales-frecuentes/" class="fn-list-action-item fn-usr">

                        <i class="icon-doctorplus-user-add-like"></i>

                        <figure class="fn-tooltip">
                            <span class="fn-item-content">{"Profesionales Frecuentes"|x_translate}</span>
                            <span class="fn-arrow"></span>
                        </figure>
                    </a>
                </li>
                <li>
                    <a href="{$url}panel-paciente/videoconsulta/"  id="icono_float_videoconsulta" class="fn-list-action-item fn-usr">

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
                    <a href="{$url}panel-paciente/consultaexpress/" id="icono_float_consultaexpress" class="fn-list-action-item fn-usr">
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
                    <a href="{$url}panel-paciente/notificaciones/" id="icono_float_notificaciones" class="fn-list-action-item fn-usr">
                        {if $info_menu.cantidad_notificaciones>0}
                        <figure class="gotmsg"></figure>
                        {/if}
                        <i class="icon-doctorplus-flag"></i>

                        <figure class="fn-tooltip">
                            <span class="fn-item-content">{"Notificaciones"|x_translate}</span>
                            <span class="fn-arrow"></span>
                        </figure>
                    </a>
                </li>

            </ul>
            <a href="javascript:;" class="fn-close"><i class="icon-doctorplus-cruz"></i></a>
        </div>
    </div>
</nav>	
{/if}

{literal}
<script>
    $(function () {

        //codigo JS asociado a la barra de iconos flotante
     

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

            $(".select_member").click(function () {
                var id = $(this).data("id");

                if (parseInt(id) > 0) {
                    input_change = $("#label_" + id);
                    if (input_change.length == 0) {
                        input_change = $("#label_self");
                    }


                    x_doAjaxCall(
                            'POST',
                            BASE_PATH + 'panel-paciente/change_member.do',
                            "requerimiento=" + input_change.data("requerimiento") + "&id=" + id,
                            function (data) {
                                if (data.result) {
                                    window.location.href = "";
                                } else {
                                    x_alert(data.msg);
                                }
                            }
                    );
                }
            });


        
        //FIN codigo JS  barra de iconos flotante
    });
</script>
{/literal}