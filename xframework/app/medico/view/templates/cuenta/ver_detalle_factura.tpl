<div class="modal-header green">
    <div class="modal-title pull-left">
        <h1>{"Resumen de consultas express"|x_translate}</h1>
    </div>
    <div class="modal-action pull-right">
        <button class="close" data-dismiss="modal"></button>
        <button class="print"></button>
    </div>
    <div class="clearfix"></div>
</div>
<div class="modal-body">
    <div class="row">
        <div class="col-md-6 table-wrapper">
            <table class="resume table table-striped table-responsive">
                {foreach key=key item=paciente from=$listado_paciente name=foo}
                {if $smarty.foreach.foo.iteration % 2 == 1}
                <tr>
                    <td class="user-img">
                        {if $paciente.paciente.image != ""}
                        <img class="img-circle img-responsive" src="{$paciente.paciente.image.list}" alt="{$paciente.paciente.nombre_paciente}">
                        {else}
                        <img class="img-circle img-responsive" src="{$IMGS}extranet/noimage-paciente.jpg" alt="{$paciente.paciente.nombre_paciente}">
                        {/if}
                    </td>
                    <td class="user-info">{$paciente.paciente.nombre} {$paciente.paciente.apellido}<br><small>DN {$paciente.paciente.fechaNacimiento|date_format:"%d/%m/%Y"}</small></td>
                    <td class="date">{$paciente.paciente.fecha|date_format:"%d/%m/%Y"}{*5 feb*}</td>
                </tr>
                {/if}
                {/foreach}
            </table>
        </div>
        <div class="col-md-6 table-wrapper">
            <table class="resume table table-striped table-responsive">
                {foreach key=key item=paciente from=$listado_paciente name=foo}
                {if $smarty.foreach.foo.iteration % 2 == 0}
                <tr>
                    
                    <td class="user-img">
                        {if $paciente.paciente.image != ""}
                        <img class="img-circle img-responsive" src="{$paciente.paciente.image.list}" alt="{$paciente.paciente.nombre}">
                        {else}
                        <img class="img-circle img-responsive" src="{$IMGS}extranet/noimage-paciente.jpg" alt="{$paciente.nombre_paciente}">
                        {/if}
                    </td>
                    
                    <td class="user-info">{$paciente.paciente.nombre} {$paciente.paciente.apellido}<br><small>DN {$paciente.paciente.fechaNacimiento|date_format:"%d/%m/%Y"}</small></td>
                    <td class="date">{$paciente.paciente.fecha|date_format:"%d/%m/%Y"}</td>
                </tr>
                {/if}
                {/foreach}
            </table>
        </div>
    </div>
    <nav>
        {*
        <ul class="pagination">
            <li><a href="#">1</a></li>
            <li><a href="#">2</a></li>
            <li><a href="#">3</a></li>
        </ul>
        *}
    </nav>
</div>


{literal}
<script language="javascript">
    $(document).ready(function(e) {

        renderUI2("consult-details");

        $("#cerrarModal").click(function() {
            $('#winModalLg').modal('hide');
        });
    });
</script>
{/literal}