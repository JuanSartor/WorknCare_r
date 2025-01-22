{if $account.medico.planProfesional==1}

    <div id="pacientesSinCargo" class="pacientes-sin-cargo">
        <div class="pacientes-sin-cargo-disclaimer">
            <div class="close-box">
                <a href="#" id="pacientesSinCargoClose"><i class="icon-doctorplus-cruz"></i></a>
            </div>
            <h3>{"Recuerde que por tener Cuenta Profesional ud. puede bonificar sus servicios de Consultas Express de hasta cincuenta pacientes."|x_translate}</h3>

            <div class="pacientes-sin-cargo-disclaimer-text" id="codigoEtica">
                <h4>{"Para comunicarse de manera más eficaz con sus pacientes"|x_translate}</h4>
                <p>{"Una solución de mensajería no intrusiva, segura y práctica para administrar más fácilmente las solicitudes de sus pacientes."|x_translate}</p>
                <p>{"Puede decidir eximir a algunos de sus pacientes de las tarifas cuando les da una opinión simple o les informa fuera de una consulta en la oficina"|x_translate}</p>
                <p>{"Puede optar por eximir hasta 50 pacientes. Para elegir estos pacientes exentos, marque la casilla 'CE Exento' en su lista de pacientes."|x_translate}</p>
            </div>
        </div>
        <div class="pacientes-sin-cargo-disclaimer-footer">
            <div class="okm-row">
                <div class="colx2">
                    <a href="javascript:;" id="codigoEticaShow">{"¿Qué dice el Código de Ética Médica al respecto?"|x_translate}</a>
                    <a href="javascript:;" id="codigoEticaHide">{"Ocultar"|x_translate}</a>
                </div>
                <div class="colx2">
                    <label class="checkbox pacientes-sin-cargo-disclaimer-check">
                        <input type="checkbox" value="" id="btnNoMostrarCodigoEtica" data-toggle="checkbox">
                        {"No ver más este mensaje"|x_translate}
                    </label>
                </div>
            </div>
        </div>
    </div>
    {if $listado_mis_pacientes_sincargo.rows && $listado_mis_pacientes_sincargo.rows|@count > 0}
        <div class="pacientes-sin-cargo-num">
            {"Pacientes con servicio bonificado"|x_translate} {$listado_mis_pacientes_sincargo.records} {"de 50"|x_translate}
        </div>
    {/if}
    {foreach from=$listado_mis_pacientes_sincargo.rows item=paciente}
        <div class="container-paciente" data-idpaciente="{$paciente.idpaciente}">
            <article class="customer-box {if $paciente.sexo=="0"}female{else}male{/if} w">			
                <div class="data">
                    {if $paciente.imagenes.usuario != ""}
                        <img class="img-circle imagen-paciente" src="{$paciente.imagenes.usuario}" title="{$paciente.nombre} {$paciente.apellido}">
                    {else}
                        {if $paciente.animal != 1}
                            <img class="img-circle imagen-paciente" src="{$IMGS}extranet/noimage-paciente.jpg" title="{$paciente.nombre} {$paciente.apellido}">
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
                                <i class="fa fa-phone"></i>
                                {$paciente.numeroCelular}
                            </p>
                        {/if}      
                        <a href="javascript:;" class="btnEnviarMensaje" data-idpaciente="{$paciente.idpaciente}">
                            <p class="tel"><i class="fa fa-envelope"></i> 
                                {"Enviar mensaje"|x_translate}
                            </p>
                        </a>
                        {if $paciente.beneficia_ald==1} <strong>{"ALD exonérante"|x_translate}</strong>{/if}

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
                                <a  href="javascript:;" role="button" >
                                    <i class="icon-doctorplus-usr-group"></i>
                                    {"No posee pacientes relacionados"|x_translate}
                                </a>
                            </li>
                        {else}
                            {if $paciente.pacientes_relacionados && $paciente.pacientes_relacionados|@count > 0}
                                <li>
                                    {if $paciente.pacientes_relacionados|@count == 1}
                                        <a data-toggle="modal" href="{$url}medico.php?fromajax=1&modulo=pacientes&submodulo=pacientes_relacionados&idpaciente={$paciente.idpaciente}" data-target="#pacientes-relacionados" role="button" >
                                            <i class="icon-doctorplus-usr-group"></i>
                                            {$paciente.pacientes_relacionados.0.nombre} {$paciente.pacientes_relacionados.0.apellido} {"es un paciente relacionado"|x_translate}
                                        </a>
                                    {else}
                                        <a data-toggle="modal" href="{$url}medico.php?fromajax=1&modulo=pacientes&submodulo=pacientes_relacionados&idpaciente={$paciente.idpaciente}" data-target="#pacientes-relacionados" role="button" >
                                            <i class="icon-doctorplus-usr-group"></i>
                                            {math assign="cant_relacionados" equation="( x - y )" x=$paciente.pacientes_relacionados|@count y=1}
                                        {$paciente.pacientes_relacionados.0.nombre} {$paciente.pacientes_relacionados.0.apellido} et {$cant_relacionados} {if $cant_relacionados==1}{"paciente relacionado"|x_translate} {else}{"pacientes relacionados"|x_translate}{/if}
                                    </a>
                                {/if}
                                <div class="tooltip top fade in">
                                    <div class="tooltip-arrow"></div>
                                    <div class="tooltip-inner">
                                        {"Pacientes relacionados:"|x_translate} 
                                        {foreach from=$paciente.pacientes_relacionados item=relacionado}
                                            <a data-toggle="modal" href="{$url}medico.php?fromajax=1&modulo=pacientes&submodulo=pacientes_relacionados&idpaciente={$paciente.idpaciente}" data-target="#pacientes-relacionados" role="button">{$relacionado.nombre} {$relacionado.apellido}</a>
                                        {/foreach}
                                    </div>							
                                </div>						
                            </li>
                        {/if}
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
                                <a data-toggle="modal" href="{$url}medico.php?fromajax=1&modulo=pacientes&submodulo=profesionales_frecuentes&idpaciente={$paciente.idpaciente}" data-target="#profesionales-frecuentes" role="button" >
                                    <i class="icon-doctorplus-user-add-like"></i>
                                    {$paciente.medicos_relacionados.0.nombre} {$paciente.medicos_relacionados.0.apellido} {"es un profesional frecuente"|x_translate}
                                </a>
                            {else}
                                <a data-toggle="modal" href="{$url}medico.php?fromajax=1&modulo=pacientes&submodulo=profesionales_frecuentes&idpaciente={$paciente.idpaciente}" data-target="#profesionales-frecuentes" role="button" >
                                    <i class="icon-doctorplus-user-add-like"></i>
                                    {$paciente.medicos_relacionados.0.nombre} {$paciente.medicos_relacionados.0.apellido} {"y"|x_translate} {math equation="( x - y )" x=$paciente.medicos_relacionados|@count y=1} {"profesionales frecuentes"|x_translate}
                                </a>
                            {/if}

                            <div class="tooltip top fade in">
                                <div class="tooltip-arrow"></div>
                                <div class="tooltip-inner">
                                    <strong>{"Profesionales frecuentes:"|x_translate}  </strong>
                                    {foreach from=$paciente.medicos_relacionados item=relacionado}
                                        <a data-toggle="modal" href="{$url}medico.php?fromajax=1&modulo=pacientes&submodulo=profesionales_frecuentes&idpaciente={$paciente.idpaciente}" data-target="#profesionales-frecuentes">
                                            - {$relacionado.nombre} {$relacionado.apellido} ({$relacionado.mis_especialidades.0.especialidad})</a> 
                                        {/foreach}
                                </div>							
                            </div>							
                        </li>
                    {/if}
                    <li>
                        {* <a href="javascript:;" data-id="{$paciente.idpaciente}" class="btn btn-inverse btnEliminarMisPacientes"> {"Eliminar de mis pacientes"|x_translate}</a>*}
                        <label class="checkbox medico-paciente-list-check">
                            <input type="checkbox" value="" class="btnSinCargo" data-id="{$paciente.idpaciente}" checked data-toggle="checkbox">
                            {"Consulta Express sin cargo"|x_translate}
                        </label>
                    </li>
                </ul>						
            </div>
        </article>
    </div>
{foreachelse}
    <div class="sin-registros icon-btns">
        <i class="dp-user-like dp-icon"></i>
        <h6>{"¡La sección está vacía!"|x_translate}</h6>
        <p>{"Ud no tiene Pacientes sin cargo."|x_translate}</p>
    </div>	
{/foreach}
{if $listado_mis_pacientes_sincargo.rows && $listado_mis_pacientes_sincargo.rows|@count > 0}
    {x_paginate_loadmodule_v2  id="$idpaginate" modulo="pacientes" submodulo="mis_pacientes_sincargo" container_id="lista-pacientes-sincargo"}
{/if}



<script>
    var idmedico ={$idmedico};
    {literal}
        $(document).ready(function () {



            $(':checkbox').radiocheck();

            if (localStorage.getItem("NoMostrarCodigoEtica" + idmedico)) {
                $("#pacientesSinCargo").hide();
            }
            if ($('#pacientesSinCargo').length > 0) {
                $('#codigoEticaShow').on('click', function (e) {
                    e.preventDefault();
                    $('#codigoEtica').slideDown();
                    $(this).hide();
                    $('#codigoEticaHide').show();
                });

                $('#codigoEticaHide').on('click', function (e) {
                    e.preventDefault();
                    $('#codigoEtica').slideUp();
                    $(this).hide();
                    $('#codigoEticaShow').show();
                });

                $('#pacientesSinCargoClose').on('click', function (e) {
                    e.preventDefault();
                    $('#pacientesSinCargo').slideUp();
                });

                $('#btnNoMostrarCodigoEtica').on('click', function (e) {
                    e.preventDefault();
                    localStorage.setItem("NoMostrarCodigoEtica" + idmedico, 1);
                    $('#pacientesSinCargo').slideUp();
                });


            }

            $("#lista-pacientes-sincargo .btnEliminarMisPacientes").click(function () {
                var id = $(this).data("id");
                if (parseInt(id) > 0) {
                    jConfirm({
                        title: x_translate("Eliminar Paciente "),
                        text: x_translate('Eliminar el paciente de su lista?'),
                        confirm: function () {
                            $("#lista-pacientes-sincargo").spin("large");
                            x_doAjaxCall(
                                    'POST',
                                    BASE_PATH + 'eliminar_paciente_mis_pacientes.do',
                                    "id=" + id,
                                    function (data) {
                                        $("#lista-pacientes-sincargo").spin(false);
                                        x_alert(data.msg);
                                        if (data.result) {
                                            x_loadModule('pacientes', 'mis_pacientes_listado', 'do_reset=1', 'lista-pacientes-sincargo');
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

            $("#lista-pacientes-sincargo .btnEliminarInvitacion").click(function () {
                var id = $(this).data("id");

                if (parseInt(id) > 0) {

                    jConfirm({
                        title: x_translate("Eliminar Paciente"),
                        text: x_translate('Eliminar el paciente de su lista?'),
                        confirm: function () {
                            $("#lista-pacientes-sincargo").spin("large");
                            x_doAjaxCall(
                                    'POST',
                                    BASE_PATH + 'eliminar_invitacion_mis_pacientes.do',
                                    "id=" + id,
                                    function (data) {
                                        $("#lista-pacientes-sincargo").spin(false);
                                        x_alert(data.msg);
                                        if (data.result) {
                                            x_loadModule('pacientes', 'mis_pacientes_listado', 'do_reset=1', 'lista-pacientes-sincargo');
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

            //accion al checkear la opcion de paciente sin cargo
            $("#lista-pacientes-sincargo .btnSinCargo").click(function () {
                var id = $(this).data("id");
                if (parseInt(id) > 0) {
                    if ($(this).is(":checked")) {
                        var sin_cargo = 1;
                    } else {
                        var sin_cargo = 0;
                    }

                    $("#lista-pacientes-sincargo").spin("large");
                    x_doAjaxCall(
                            'POST',
                            BASE_PATH + 'actualizar_paciente.do',
                            "id=" + id + "&sin_cargo=" + sin_cargo,
                            function (data) {
                                $("#lista-pacientes-sincargo").spin(false);
                                x_alert(data.msg);
                                if (data.result) {
                                    x_loadModule('pacientes', 'mis_pacientes_sincargo', 'do_reset=1', 'lista-pacientes-sincargo');
                                }
                            }
                    );


                }
            });
            $("#lista-pacientes-sincargo .change_miembro").click(function () {

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




            /*Enviar mensaje a paciente*/
            $('#lista-pacientes-sincargo .btnEnviarMensaje').on('click', function () {
                var targetId = "#lista-pacientes-sincargo .enviar_mensaje[data-idpaciente=" + $(this).data('idpaciente') + "]";
                $(targetId).modal("show");
            });

        });
    {/literal}
</script>
{/if}