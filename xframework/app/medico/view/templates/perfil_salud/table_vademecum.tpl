<div class="table-responsive table-modal">
    <table class="table table-striped">
        <thead>
            <tr>
                <td>{"Generico"|x_translate}</td>
                <td>{"Laboratorio"|x_translate}</td>
                <td>{"Presentación"|x_translate}</td>
                <td>{"Nombre comercial"|x_translate}</td>
                <td>{"Forma farmaceutica"|x_translate}</td>
            </tr>
        </thead>
        <tbody>
            {if $list_vademecum}
            {foreach from=$list_vademecum.rows item=vademecum}
            <tr>
                <td><a style="cursor: pointer" class="select_vademecum" data-nombre_medicamento="{$vademecum.nombre_comercial}" data-id="{$vademecum.idmedicamento}">{$vademecum.generico}</a></td>
                <td>{$vademecum.laboratorio}</td>
                <td>{$vademecum.presentacion}</td>
                <td><a style="cursor: pointer" class="select_vademecum" data-nombre_medicamento="{$vademecum.nombre_comercial}" data-id="{$vademecum.idmedicamento}">{$vademecum.nombre_comercial}</a></td>
                <td>{$vademecum.forma_farmaceutica}</td>
            </tr>
            {foreachelse}
            <tr>
                <td colspan="5">{"No hay medicamentos para esa búsqueda"|x_translate}</td>
            </tr>
            {/foreach}
            {/if}

        </tbody>
    </table>
</div>	

{if $list_vademecum.rows && $list_vademecum.rows|@count > 0}
<div class="grid-pagination pagination-modal">
    {x_paginate_loadmodule_v2 id="$idpaginate_vademecum" modulo="perfil_salud"
    submodulo="table_vademecum" 
    container_id="div_table_vademecum"
    params="str=$str"}
</div>
{/if}

{literal}
<script>
    $(".select_vademecum").click(function() {
        var id = $(this).data("id");
        var nombre_medicamento=$(this).data("nombre_medicamento");
        if(nombre_medicamento==""){
            return false;
        }
        $("#medicamento_idmedicamento").val(id);
        $("#nombre_medicamento").val(nombre_medicamento);
        $("#nombre_medicamento_hidden").val(nombre_medicamento);
        $("#vademecum").modal('toggle');
    });
</script>
{/literal}