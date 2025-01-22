<div class="modal-header">
    <div class="modal-title"><h5>{"Pacientes relacionados"|x_translate}</h5></div>
    <span class="close-btn" data-dismiss="modal" aria-label="Close"><i class="fui-cross"></i></span>
</div>
<div class="modal-body">
    <div class="form-content">
        <ul>    
            {foreach from=$listado_pacientes_relacionados item=paciente}
                <li id="li_paciente_relaciona_{$paciente.idpaciente}">
                    {if $paciente.imagenes.usuario != ""}
                        <img class="img-circle imagen-paciente" src="{$paciente.imagenes.usuario}" title="{$paciente.nombre} {$paciente.apellido}">
                    {else}
                        {if $paciente.animal != 1}
                            <img class="img-circle imagen-paciente" src="{$IMGS}extranet/noimage-paciente.jpg" title="{$paciente.nombre} {$paciente.apellido}">
                        {else}
                            <img class="img-circle imagen-paciente" src="{$IMGS}extranet/noimage-animal.jpg" title="{$paciente.nombre} {$paciente.apellido}">
                        {/if}
                    {/if}
                    <h3 class="nombre-paciente">{$paciente.nombre} {$paciente.apellido}</h3>
                    <p>DN {$paciente.fechaNacimiento_format}</p>
                    {if $paciente.idmedicoMedicosMisPacientes > 0 || $paciente.idmedico_paciente_invitacion > 0}
                        <a href="javascript:;" data-id="{$paciente.idpaciente}" class="dp-user"></a>
                    {else}
                        <a href="javascript:;" data-id="{$paciente.idpaciente}" class="dp-add-user a_agregar_usuario"></a>
                    {/if}
                </li>
            {foreachelse}
                <li>
                    {"No hay pacientes relacionados"|x_translate}
                </li>
            {/foreach}
        </ul>
    </div>
</div>

{literal}
    <script>
        $(".a_agregar_usuario").click(function () {
            var id = $(this).data("id");
            if (parseInt(id) > 0) {
                $("body").spin("large")
                x_doAjaxCall(
                        'POST',
                        BASE_PATH + 'invitar-paciente.do',
                        "paciente_idpaciente=" + id,
                        function (data) {
                            $("body").spin(false)
                            if (data.result) {
                                $("#li_paciente_relaciona_" + id).find("a").attr("class", "dp-user");
                                x_loadModule('pacientes', 'listado_mis_pacientes_busqueda', 'query_str=' + $("#buscar_paciente_input").val(), 'lista-pacientes-busqueda');
                                x_loadModule('pacientes', 'listado_all_pacientes_busqueda', 'query_str=' + $("#buscar_paciente_input").val(), 'lista-pacientes-full');
                                x_loadModule('pacientes', 'mis_pacientes_listado', 'do_reset=1', 'lista-pacientes');
                            } else {
                                x_alert(data.msg);
                            }
                        }
                );
            }
        });

    </script>
{/literal}
