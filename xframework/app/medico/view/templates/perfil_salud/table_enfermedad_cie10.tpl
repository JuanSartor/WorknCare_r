<div class="table-responsive table-modal">
    <table class="table table-striped">
        <thead>
            <tr>
                <td>Código</td>
                <td>Enfermedad</td>
            </tr>
        </thead>
        <tbody>
            {if $list_enfermedad_cie10}
            {foreach from=$list_enfermedad_cie10.rows item=enfermedad}
            <tr>
                
                <td>{$enfermedad.codigo}</td>
                <td><a style="cursor: pointer" class="select_enfermedad_cie10" data-id="{$enfermedad.id}">{$enfermedad.enfermedad}</a></td>
            </tr>
            {foreachelse}
            <tr>
                <td colspan="2">{"No hay enfermedades para esa búsqueda"|x_translate}</td>
            </tr>
            {/foreach}
            {/if}

        </tbody>
    </table>
</div>	

{if $list_enfermedad_cie10.rows && $list_enfermedad_cie10.rows|@count > 0}
<div class="grid-pagination pagination-modal">
    {x_paginate_loadmodule_v2  id="$idpaginate_enfermedad_cie10" modulo="perfil_salud"
    submodulo="table_enfermedad_cie10" 
    container_id="div_table_enfermedades"
    params="str=$str"}
</div>
{/if}
{literal}
<script>
    $(".select_enfermedad_cie10").click(function() {
        var id = $(this).data("id");
        $("#importacion_cie10_idimportacion_cie10").val(id);
        $("#diagnostico").val($(this).html());
        $("#diagnostico_hidden").val($(this).html());
        $("#enfermedades_cie10").modal('toggle');
    });
</script>
{/literal}