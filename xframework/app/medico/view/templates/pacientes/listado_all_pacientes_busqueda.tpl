{if $listado_mis_pacientes.rows && $listado_mis_pacientes.rows|@count > 0}

    <h2 class="{*dp-pacientes*}">{"Pacientes en DoctorPlus"|x_translate}-</h2>

    {foreach from=$listado_mis_pacientes.rows item=paciente}
        <div class="container-paciente" data-idpaciente="{$paciente.idpaciente}">
            <article id="paciente_article_{$paciente.idpaciente}" {if $paciente.sexo == 1}class="customer-box male w" {else}class="customer-box female w"{/if}>
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
                        <br>
                        <p>DN {$paciente.fechaNacimiento|date_format:"%Y-%m-%d"}</p>

                    </div>

                </div>
                <div class="customer-options okm-user-options">
                    <ul>

                        <li class="long-list">
                            {if !$paciente.pacientes_relacionados}

                                <a  href="javascript:;"  role="button" class="dp-pacientes-rel">
                                    {"No posee pacientes relacionados"|x_translate}</a>

                            {/if}
                            {if $paciente.pacientes_relacionados && $paciente.pacientes_relacionados|@count > 0}
                                {if $paciente.pacientes_relacionados|@count == 1}
                                    <a data-toggle="modal" href="{$url}medico.php?fromajax=1&modulo=pacientes&submodulo=pacientes_relacionados&idpaciente={$paciente.idpaciente}" data-target="#pacientes-relacionados" role="button" class="dp-pacientes-rel">
                                        {$paciente.pacientes_relacionados.0.nombre} {$paciente.pacientes_relacionados.0.apellido} {"es un paciente relacionado"|x_translate}
                                    </a>
                                {else}
                                    <a data-toggle="modal" href="{$url}medico.php?fromajax=1&modulo=pacientes&submodulo=pacientes_relacionados&idpaciente={$paciente.idpaciente}" data-target="#pacientes-relacionados" role="button" class="dp-pacientes-rel">
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
                            {else}
                                &nbsp;
                            {/if}
                        </li>

                        <li><a href="javascript:;" data-id="{$paciente.idpaciente}" class="btn btn-inverse a_agregar_paciente_dp">{"Agregar a mis pacientes"|x_translate}</a></li>
                    </ul>						
                </div>
            </article>
        </div>
    {/foreach}


    {literal}
        <script>
            $(document).ready(function () {

                $(".a_agregar_paciente_dp").click(function () {
                    var id = $(this).data("id");
                    if (parseInt(id) > 0) {
                        $("body").spin("large")
                        x_doAjaxCall(
                                'POST',
                                BASE_PATH + 'invitar-paciente.do',
                                "paciente_idpaciente=" + id,
                                function (data) {
                                    $("body").spin(false)
                                    x_alert(data.msg);
                                    if (data.result) {
                                        x_loadModule('pacientes', 'listado_mis_pacientes_busqueda', 'do_reset=1&query_str=' + $("#buscar_paciente_input").val(), 'lista-pacientes-busqueda');
                                        x_loadModule('pacientes', 'listado_all_pacientes_busqueda', 'do_reset=1&query_str=' + $("#buscar_paciente_input").val(), 'lista-pacientes-full');
                                        x_loadModule('pacientes', 'mis_pacientes_listado', 'do_reset=1', 'lista-pacientes');
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