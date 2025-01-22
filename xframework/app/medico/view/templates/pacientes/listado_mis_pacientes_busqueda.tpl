{if $listado_mis_pacientes.rows && $listado_mis_pacientes.rows|@count > 0}
    <br>
    {foreach from=$listado_mis_pacientes.rows item=paciente}
        <div class="container-paciente" data-idpaciente="{$paciente.idpaciente}">
            <!--Paciente ya Agregado -  Invitado-->
            {if $paciente.idmedico_paciente_invitacion === "0"}

                <!-- Info paciente-->
                <article {if $paciente.sexo == 1}class="customer-box male w" {else}class="customer-box female w"{/if}>

                    <div class="data">
                        {if $paciente.imagenes.usuario != ""}
                            <img class="img-circle imagen-paciente" src="{$paciente.imagenes.usuario}" alt="{$paciente.nombre} {$paciente.apellido}">
                        {else}
                            {if $paciente.animal != 1}
                                <img class="img-circle imagen-paciente" src="{$IMGS}extranet/noimage-paciente.jpg" alt="{$paciente.nombre} {$paciente.apellido}">
                            {else}
                                <img class="img-circle imagen-paciente" src="{$IMGS}extranet/noimage-animal.jpg" alt="{$paciente.nombre} {$paciente.apellido}">
                            {/if}
                        {/if}
                        <h3 class="nombre-paciente">{$paciente.nombre} {$paciente.apellido}</h3>
                        <div class="more-data">
                            <p>DN {$paciente.fechaNacimiento|date_format:"%Y-%m-%d"}</p>
                            {if $paciente.pais_idpais==1 && $paciente.imagenes_tarjeta.vitale.path!=""}
                                <a href="{$paciente.imagenes_tarjeta.vitale.path}" target="_blank">
                                    <p>
                                        <i class="icon-doctorplus-ficha-tecnica"></i>&nbsp;{"Ver"|x_translate} {"Tarjeta Vitale"|x_translate}
                                    </p>
                                </a>
                            {/if}
                            {if $paciente.pais_idpais==2 && $paciente.imagenes_tarjeta.cns.path!=""}
                                <a href="{$paciente.imagenes_tarjeta.cns.path}" target="_blank">
                                    <p>
                                        <i class="icon-doctorplus-ficha-tecnica"></i>&nbsp;{"Ver"|x_translate} {"Tarjeta CNS"|x_translate}
                                    </p>
                                </a>
                            {/if}
                            {if $paciente.pais_idpais==3 && $paciente.imagenes_tarjeta.eID.path!=""}
                                <a href="{$paciente.imagenes_tarjeta.eID.path}" target="_blank">
                                    <p>
                                        <i class="icon-doctorplus-ficha-tecnica"></i>&nbsp;{"Ver"|x_translate} {"Tarjeta eID"|x_translate}
                                    </p>
                                </a>
                            {/if}
                            {if $paciente.pais_idpais==4 && $paciente.imagenes_tarjeta.pasaporte.path!=""}
                                <a href="{$paciente.imagenes_tarjeta.pasaporte.path}" target="_blank">
                                    <p>
                                        <i class="icon-doctorplus-ficha-tecnica"></i>&nbsp;{"Ver"|x_translate} {"Pasaporte"|x_translate}
                                    </p>
                                </a>
                            {/if}
                            {if $paciente.numeroCelular!=""}
                                <p class="tel">
                                    <i class="fa fa-phone"></i> {$paciente.numeroCelular}
                                </p>
                            {/if}
                            <a href="javascript:;" class="btnEnviarMensaje" data-idpaciente="{$paciente.idpaciente}">
                                <p class="tel"><i class="fa fa-envelope"></i> 
                                    {"Enviar mensaje"|x_translate}
                                </p>
                            </a>
                            {if $paciente.beneficia_ald==1} 
                                <strong>{"ALD exonérante"|x_translate}</strong>
                            {/if}
                        </div>

                    </div>



                    <div class="customer-options okm-user-options">
                        <ul>
                            <li  {if $acceso_perfil_salud!="1"}class="full-width"{/if}>
                                <a href="{$url}panel-medico/mis-pacientes/{$paciente.idpaciente}-{$paciente.nombre|str2seo}-{$paciente.apellido|str2seo}/mis-registros-consultas-medicas/"  class="consultas_medicas" data-id="{$paciente.idpaciente}">
                                    <i class="icon-doctorplus-sheet-edit-full"></i>
                                    {"Consultas médicas"|x_translate}
                                </a>
                            </li>
                            {if $acceso_perfil_salud=="1"}
                                <li><a href="javascript:;"  class="change_miembro" data-id="{$paciente.idpaciente}">
                                        <i class="icon-doctorplus-pharmaceutics"></i>
                                        {"Registros de otros profesionales"|x_translate}
                                    </a>
                                </li>
                            {/if}
                            {if !$paciente.pacientes_relacionados}
                                <li>
                                    <a  href="javascript:;"  role="button">
                                        <i class="icon-doctorplus-usr-group"></i>
                                        {"No posee pacientes relacionados"|x_translate}</a>
                                </li>
                            {/if}

                            {if $paciente.pacientes_relacionados && $paciente.pacientes_relacionados|@count > 0}
                                <li>
                                    {if $paciente.pacientes_relacionados|@count == 1}
                                        <a data-toggle="modal" href="{$url}medico.php?fromajax=1&modulo=pacientes&submodulo=pacientes_relacionados&idpaciente={$paciente.idpaciente}" data-target="#pacientes-relacionados" role="button">
                                            <i class="icon-doctorplus-usr-group"></i>
                                            {$paciente.pacientes_relacionados.0.nombre} {$paciente.pacientes_relacionados.0.apellido} {"es un paciente relacionado"|x_translate}
                                        </a>
                                    {else}
                                        <a data-toggle="modal" href="{$url}medico.php?fromajax=1&modulo=pacientes&submodulo=pacientes_relacionados&idpaciente={$paciente.idpaciente}" data-target="#pacientes-relacionados" role="button" >
                                            <i class="icon-doctorplus-usr-group"></i>
                                            {$paciente.pacientes_relacionados.0.nombre} {$paciente.pacientes_relacionados.0.apellido} {"y"|x_translate} {math equation="( x - y )" x=$paciente.pacientes_relacionados|@count y=1} {"pacientes relacionados"|x_translate}
                                        </a>
                                    {/if}
                                    <div class="tooltip top fade in">
                                        <div class="tooltip-arrow"></div>
                                        <div class="tooltip-inner">
                                            {"Pacientes relacionados"|x_translate}:
                                            {foreach from=$paciente.pacientes_relacionados item=relacionado}
                                                <a data-toggle="modal" href="{$url}medico.php?fromajax=1&modulo=pacientes&submodulo=pacientes_relacionados&idpaciente={$paciente.idpaciente}" data-target="#pacientes-relacionados" role="button">{$relacionado.nombre} {$relacionado.apellido}</a>
                                            {/foreach}
                                        </div>							
                                    </div>						
                                </li>
                            {/if}

                            {if !$paciente.medicos_relacionados}
                                <li>
                                    <a  href="javascript:;"  role="button" >
                                        <i class="icon-doctorplus-user-add-like"></i>
                                        {"No posee profesionales frecuentes"|x_translate}</a>
                                </li>
                            {/if}


                            {if $paciente.medicos_relacionados && $paciente.medicos_relacionados|@count > 0}
                                <li>
                                    {if $paciente.medicos_relacionados|@count == 1}
                                        <a data-toggle="modal" href="{$url}medico.php?fromajax=1&modulo=pacientes&submodulo=profesionales_frecuentes&idpaciente={$paciente.idpaciente}" data-target="#profesionales-frecuentes" role="button">
                                            <i class="icon-doctorplus-user-add-like"></i>
                                            {$paciente.medicos_relacionados.0.nombre} {$paciente.medicos_relacionados.0.apellido} {"es un profesional frecuente"|x_translate}
                                        </a>
                                    {else}
                                        <a data-toggle="modal" href="{$url}medico.php?fromajax=1&modulo=pacientes&submodulo=profesionales_frecuentes&idpaciente={$paciente.idpaciente}" data-target="#profesionales-frecuentes" role="button">
                                            <i class="icon-doctorplus-user-add-like"></i>
                                            {$paciente.medicos_relacionados.0.nombre} {$paciente.medicos_relacionados.0.apellido} {"y"|x_translate} {math equation="( x - y )" x=$paciente.medicos_relacionados|@count y=1} {"profesionales frecuentes"|x_translate}
                                        </a>
                                    {/if}

                                    <div class="tooltip top fade in">
                                        <div class="tooltip-arrow"></div>
                                        <div class="tooltip-inner">
                                            <strong>{"Profesionales frecuentes"|x_translate}:  </strong> 
                                            {foreach from=$paciente.medicos_relacionados item=relacionado}
                                                <a data-toggle="modal" href="{$url}medico.php?fromajax=1&modulo=pacientes&submodulo=profesionales_frecuentes&idpaciente={$paciente.idpaciente}" data-target="#profesionales-frecuentes">- {$relacionado.nombre} {$relacionado.apellido} ({$relacionado.mis_especialidades.0.especialidad}) </a> 
                                            {/foreach}
                                        </div>							
                                    </div>							
                                </li>


                            {/if}
                            <li>
                                {* <a href="javascript:;" data-id="{$paciente.idpaciente}" class="btn btn-inverse btnEliminarMisPacientes"> {"Eliminar de mis pacientes"|x_translate}</a>*}
                                {if $account.medico.planProfesional==1}
                                    <label {if $paciente.sin_cargo=="1"}checked{/if} class="btnSinCargo checkbox medico-paciente-list-check">
                                        <input type="checkbox" value="" data-toggle="checkbox">
                                        {"Consulta Express sin cargo"|x_translate}
                                    </label>
                                {else}
                                    <label class="checkbox medico-paciente-list-check" data-toggle="tooltip" title="Vous devez souscrire à l'abonnement pour pouvoir personnaliser l'utilisation de votre compte">
                                        <input type="checkbox" value=""  disabled >
                                        {"Consulta Express sin cargo"|x_translate}
                                    </label>
                                {/if}
                            </li>
                        </ul>						
                    </div>
                </article>


            {else}
                <!--paciente invitado-->
                <article class="customer-box solicitud-enviada w">
                    <div class="data">
                        {if $paciente.imagenes.usuario != ""}
                            <img class="img-circle imagen-paciente" src="{$paciente.imagenes.usuario}" alt="{$paciente.nombre} {$paciente.apellido}">
                        {else}
                            <img class="img-circle imagen-paciente" src="{$IMGS}extranet/noimage-paciente.jpg" alt="{$paciente.nombre} {$paciente.apellido}">
                        {/if}
                        <h3  class="nombre-paciente">{$paciente.nombre} {$paciente.apellido}</h3>
                        <div class="more-data">
                            <p><br> {"Pendiente de confirmación"|x_translate}</p>
                        </div>
                    </div>
                    <div class="customer-options">
                        <ul>
                            {if $paciente.ultimoenvio_format != ""}
                                <li class="long-list">{"Solicitud enviada el [[{$paciente.ultimoenvio_format}]] al paciente titular"|x_translate}</li>
                                {else}
                                <li class="long-list">{"Se le envió la notificación al paciente titular"|x_translate}</li>
                                {/if}
                            <li><a href="javascript:;" data-id="{$paciente.idmedico_paciente_invitacion}" class="btn btn-inverse btnEliminarInvitacion"> {"Eliminar de mis pacientes"|x_translate}</a></li>
                        </ul>						
                    </div>
                </article>

            {/if}
        </div>
    {foreachelse}
        <div class="sin-registros">
            <i class="dp-pacientes dp-icon"></i>
            <h6>{"¡La sección está vacía!"|x_translate}</h6>
            <p>{"Ud no tiene Pacientes"|x_translate}.</p>
        </div>	
    {/foreach}

    {if $listado_mis_pacientes.rows && $listado_mis_pacientes.rows|@count > 0}
        {x_paginate_loadmodule_v2  id="$idpaginate" modulo="pacientes"
submodulo="listado_mis_pacientes_busqueda" 
container_id="lista-pacientes-busqueda"
params="query_str=$query_str"}
    {/if}




    {literal}
        <script>
            $(document).ready(function () {
                $(':checkbox').radiocheck();
                $('[data-toggle="tooltip"]').tooltip();

                $("#lista-pacientes-busqueda .btnEliminarMisPacientes").click(function () {
                    var id = $(this).data("id");
                    if (parseInt(id) > 0) {
                        jConfirm({
                            title: x_translate("Eliminar Paciente"),
                            text: x_translate('Eliminar el paciente de su lista?'),
                            confirm: function () {
                                $("#lista-pacientes").spin("large");
                                x_doAjaxCall(
                                        'POST',
                                        BASE_PATH + 'eliminar_paciente_mis_pacientes.do',
                                        "id=" + id,
                                        function (data) {
                                            $("#lista-pacientes").spin(false);
                                            x_alert(data.msg);
                                            if (data.result) {
                                                x_loadModule('pacientes', 'listado_mis_pacientes_busqueda', 'do_reset=1&query_str=' + $("#buscar_paciente_input").val(), 'lista-pacientes-busqueda');
                                                x_loadModule('pacientes', 'listado_all_pacientes_busqueda', 'do_reset=1&query_str=' + $("#buscar_paciente_input").val(), 'lista-pacientes-full');
                                                x_loadModule('pacientes', 'mis_pacientes_listado', 'do_reset=1', 'lista-pacientes');
                                            }
                                        }
                                );
                            },
                            cancel: function () {

                            },
                            confirmButton: x_translate("Si"),
                            cancelButton: x_translate("No")
                        });
                    }
                });

                $("#lista-pacientes-busqueda .btnEliminarInvitacion").click(function () {
                    var id = $(this).data("id");

                    if (parseInt(id) > 0) {

                        jConfirm({
                            title: x_translate("Eliminar Paciente"),
                            text: x_translate('Eliminar el paciente de su lista?'),
                            confirm: function () {
                                $("#lista-pacientes").spin("large");
                                x_doAjaxCall(
                                        'POST',
                                        BASE_PATH + 'eliminar_invitacion_mis_pacientes.do',
                                        "id=" + id,
                                        function (data) {
                                            $("#lista-pacientes").spin(false);
                                            x_alert(data.msg);
                                            if (data.result) {
                                                x_loadModule('pacientes', 'mis_pacientes_listado', 'do_reset=1', 'lista-pacientes');
                                                x_loadModule('pacientes', 'listado_mis_pacientes_busqueda', 'do_reset=1&query_str=' + $("#buscar_paciente_input").val(), 'lista-pacientes-busqueda');
                                                x_loadModule('pacientes', 'listado_all_pacientes_busqueda', 'do_reset=1&query_str=' + $("#buscar_paciente_input").val(), 'lista-pacientes-full');
                                            }
                                        }
                                );
                            },
                            cancel: function () {

                            },
                            confirmButton: x_translate("Si"),
                            cancelButton: x_translate("No")
                        });
                    }
                });
                //perfil de salud
                $("#lista-pacientes-busqueda .change_miembro").click(function () {

                    window.sessionStorage.setItem("mostrar_inputs", "1");
                    var id = $(this).data("id");
                    if (parseInt(id) > 0) {
                        x_doAjaxCall(
                                'POST',
                                BASE_PATH + 'panel-medico/change_member.do',
                                "id=" + id,
                                function (data) {
                                    if (data.result) {
                                        window.location.href = BASE_PATH + "panel-medico/mis-pacientes/" + data.idpaciente + "-" + data.nombre + "-" + data.apellido + "/?otros_profesionales=1";
                                    } else {
                                        x_alert(data.msg);
                                    }
                                }
                        );
                    }
                });
            });
        </script>
    {/literal}
{else}
    <script>
        $("#cantidad_resultados_input").val(parseInt($("#cantidad_resultados_input").val()) + 1).change();
    </script>
{/if}
<script>
    $(document).ready(function () {
        $("body").spin(false);
    });
</script>
