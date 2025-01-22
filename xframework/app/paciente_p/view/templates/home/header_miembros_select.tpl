<style>
    .paciente-nav-usr .paciente-nav-trigger i {
        font-size: 14px;
        margin-left: 4px;
        color: #fff;
        position: relative;
        top: 8px;
    }


    .active-user .perfil-dropdown {
        width: max-content;
    }
    .active-user .perfil-dropdown li {
        display: flex;
        align-items: center;
        justify-content: flex-start;
        padding: 5px;
        text-transform: capitalize;
    }
    .active-user .perfil-dropdown li label  {
        margin: 0 16px;
        cursor:pointer;
    }
    a.selector-urs-circle.inactive:hover {
        background-color: #ddd;
    }
    a.selector-urs-circle figure {
        width: 50px;
        height: 50px;
        line-height: 74px !important;
    }
    a.selector-urs-circle.all i{
        position: absolute;
        top: -11px;
        left: 8px;
        font-size: 28px;
    }
    a.selector-urs-circle.all i.mascota{
        position: absolute;
        top: 8px;
        left: 8px;
        font-size: 28px;
    }

    .paciente-nav-usr .gotmsg {
        display: block;
        width: 14px;
        height: 14px;
        background-color: #108c7d;
        border: 2px solid #fff;
        border-radius: 50%;
        position: absolute;
        right: 4px;
        top: 12px;
        z-index: 1000;
    } 

    @media (max-width: 600px){
        .paciente-nav-usr .paciente-nav-trigger i {
            display: inline-block;
        }
    }

</style>
<input type="hidden" id="filtro" value="{$header_info.filter_selected}" />
<div class="paciente-nav-usr" id="header_miembros_select">
    <div class="active-user">
        <a href="javascript:;" class="paciente-nav-trigger">
            {*Seccion miembros- titular seleccionado*}
            {if $header_info.filter_selected=="all"}
                {if $account.mi_logo}
                    <img id="imagen_menu_privado_perfil" src="{$url}xframework/files/entities/pacientes/{$account.paciente.idpaciente}/{$account.paciente.idpaciente}_perfil.jpg?{$smarty.now}" class="img-responsive img-circle dl-trigger " title="{$account.paciente.nombre} {$account.paciente.apellido}">
                {else}
                    <img id="imagen_menu_privado_perfil" src="{$IMGS}extranet/noimage-paciente.jpg?{$smarty.now}" title="{$account.paciente.nombre} {$account.paciente.apellido}">
                {/if}
                <label>{$account.name} {$account.lastname}</label>

            {else}
                {if $paciente.image.perfil != ""}
                    <img  id="imagen_menu_privado_perfil" src="{$paciente.image.perfil}?{$smarty.now}" class="img-responsive img-circle dl-trigger " title="{$paciente.nombre} {$paciente.apellido}">
                {else}
                    {if $paciente.animal==1}
                        <img  id="imagen_menu_privado_perfil" src="{$IMGS}extranet/noimage-animal.jpg?{$smarty.now}" title="{$paciente.nombre} {$paciente.apellido}">
                    {else}
                        <img  id="imagen_menu_privado_perfil" src="{$IMGS}extranet/noimage-paciente.jpg?{$smarty.now}" title="{$paciente.nombre} {$paciente.apellido}">
                    {/if}
                    <small class="nombre-corto">{$paciente.nombre_corto}</small>
                {/if}
                <label>{$paciente.nombre} {$paciente.apellido}</label>
            {/if}
            <figure class="gotmsg bounce" id="paciente-gotmsg" style="display:none">
            </figure>
            <i class="fa fa-chevron-down"></i>
        </a>


        <div class="perfil-dropdown selector-usr-slide">
            <ul>
                {if $header_info.all_members|@count > 0}
                    {foreach from=$header_info.all_members item=miembro} 

                        <li {if $miembro.email!=""}id="label_self"{else}id="label_{$miembro.idpaciente}"{/if}  class="a_miembro a_change_member" {if $miembro.email!=""}data-requerimiento="self"{else}data-requerimiento="{$miembro.idpaciente}"{/if} data-id="{$miembro.idpaciente}" title="{$miembro.nombre} {$miembro.apellido}">
                            <a href="javascript:;" class="selector-urs-circle picture" >
                                <figure>
                                    {if $miembro.image.perfil != ""}
                                        <img src="{$miembro.image.usuario}" alt="{$miembro.nombre}" title="{$miembro.nombre} {$miembro.apellido}"/>
                                    {else}
                                        {if $miembro.animal=="1"}
                                            <img src="{$IMGS}extranet/noimage-animal.jpg" alt="{$miembro.nombre_corto}" title="{$miembro.nombre} {$miembro.apellido}"/>
                                        {else}
                                            <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="{$miembro.nombre_corto}" title="{$miembro.nombre} {$miembro.apellido}"/>
                                        {/if}
                                        <small class="nombre-corto">{$miembro.nombre_corto}</small>
                                    {/if}

                                </figure>
                                {if $miembro.info_extra.cant_total>0}<span class="notificacion">{$miembro.info_extra.cant_total}</span>{/if}

                                {*quitamos check - PS completo*}
                                {*
                                {if $miembro.info_extra.is_permitido==1}
                                <small class="subcircle"><i class="icon-doctorplus-check-thin"></i></small>
                                {else}
                                <small class="subcircle alert"><i class="icon-doctorplus-minus"></i></small>
                                {/if}
                                *}
                            </a>
                            <label>{$miembro.nombre} {$miembro.apellido} </label>
                        </li>
                    {/foreach}
                {/if}	
                <li class="a_change_member" data-requerimiento="all">
                    <a href="javascript:;"   class="selector-urs-circle all">
                        <figure><i class="icon-doctorplus-user-add-circle"></i></figure>
                    </a>
                    <label>{"Crear nuevo miembro"|x_translate} </label>
                </li>
                <li class="a_change_member" data-requerimiento="all" data-mascota="1">
                    <a href="javascript:;"   class="selector-urs-circle all">
                        <figure><i class="fas fa-dog mascota"></i></figure>
                    </a>
                    <label>{"Agregar animal"|x_translate}</label>
                </li>
            </ul>
            <span><i class="dp-arrow-down"></i></span>
        </div>	

    </div>
</div>
{literal}
    <script>
        $(function () {

            /*Listener cambiar de usuario seleccionado*/
            $(".paciente-nav-usr .a_change_member").click(function () {
                var requerimiento = $(this).data("requerimiento");
                var mascota = $(this).data("mascota");
                var id = $(this).data("id");
                x_doAjaxCall(
                        'POST',
                        BASE_PATH + 'panel-paciente/change_member.do',
                        "requerimiento=" + requerimiento + "&id=" + id,
                        function (data) {
                            if (data.result) {
                                if (requerimiento != "all") {
                                    window.location.href = BASE_PATH + "panel-paciente/home.html";
                                } else {
                                    console.log("mascota", mascota);
                                    if (mascota == 1) {
                                        window.location.href = BASE_PATH + "panel-paciente/alta-mascota-grupo-familiar/";
                                    } else {
                                        window.location.href = BASE_PATH + "panel-paciente/alta-miembro-grupo-familiar/";
                                    }

                                }
                            } else {
                                x_alert(data.msg);
                            }
                        }
                );
            });
            //selecciono el activo y los no seleccionados marco inactivos
            $(".paciente-nav-usr .a_miembro").not($("#label_" + $("#filtro").val())).find("a").addClass("inactive");
            $(".paciente-nav-usr #label_" + $("#filtro").val()).find("a").addClass("miembro_seleccionado");
            /*mostrar alerta de nueva notificacion - paciente no seleccionado*/
            if ($("#header_miembros_select .perfil-dropdown .a_miembro a").not(".miembro_seleccionado").find("span.notificacion").length > 0) {
                $("#paciente-gotmsg").slideDown();
            }

            /*Desplegar dropdown usuarios*/
            $('.paciente-nav-usr .active-user').on('click', function () {

                if ($(".paciente-nav-usr .perfil-dropdown").is(":visible")) {
                    $(".perfil-dropdown").stop().slideUp();
                } else {
                    $(".perfil-dropdown").stop().slideDown();
                }


            });
            /*Ocultar dropdown usuarios*/
            $('.paciente-nav-usr .dp-arrow-down').parent('span').on('click', function () {
                $(".perfil-dropdown").stop().slideUp();
                return false;
            });
        });
    </script>
{/literal}