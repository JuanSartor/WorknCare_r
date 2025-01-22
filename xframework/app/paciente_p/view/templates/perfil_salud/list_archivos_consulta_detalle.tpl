<header>
    <h3><span class="fui-folder"></span> {"Estudios"|x_translate}</h3>
</header>	
<div class="table-responsive table-nueva-consulta" id="table_archivos">
    <table class="table table-striped">
        <tbody>
            {if $listado_imagenes && $listado_imagenes|@count > 0}
            {foreach from=$listado_imagenes item=key}
            <tr id="tr_imagen_{$key.idperfilSaludEstudios}">
                <td>
                    <a data-toggle="modal" href="{$url}paciente_p.php?fromajax=1&modulo=perfil_salud&submodulo=perfil_estudios_slider_imagenes&id={$key.idperfilSaludEstudios}" data-target="#ver-archivo">
                        <img alt="{$key.titulo}" src="{$key.list_imagenes.0.path_images}" />
                    </a>


                </td>
                <td><span>{if $key.titulo != ""}{$key.titulo}{else} - {/if}</span></td>
                <td><span>{if $key.fecha != ""}{$key.fecha|date_format:"%d/%m/%Y"}{else} - {/if}</span></td>

            </tr>
            {/foreach}
            {/if}
        </tbody>
    </table>
</div>





{literal}
<script>
    $(document).ready(function () {

        renderUI2("table_archivos");
        $('#ver-archivo, #modal_compartir_estudio').on('hidden.bs.modal', function () {
            $(this)
                    .removeData('bs.modal')
                    .find(".modal-content").html('');
        });


    });


</script>
{/literal}