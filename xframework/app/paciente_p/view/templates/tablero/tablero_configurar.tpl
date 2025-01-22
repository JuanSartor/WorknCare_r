<div class="modal-header">
    <div class="modal-title"><h5>{"Configurar Tablero"|x_translate}</h5></div>
    <span class="close-btn" data-dismiss="modal" aria-label="Close"><i class="fui-cross"></i></span>
</div>
<form  id="tablero_form" action="{$url}save_tablero_form.do" method="post" onsubmit="return false;">
    <input type="hidden" name="paciente_idpaciente" value="{$paciente.idpaciente}" />
    <div class="form-content ">
        <div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">
            {foreach from=$tablero_list item=tablero}
            {if $tablero.nombreConfiguracion=="Cuidado Dental" || $tablero.nombreConfiguracion=="Cuidado Auditivo"}
            {* estos apartados aun no se encuentran desarrollados*}
            {else}
            {if $tablero.sub_tablero}
            <div class="panel panel-default">
                <div class="tablero_sub_tablero panel-heading" role="tab" >
                    <label for="tab-{$tablero.idtablero}" class="checkbox" >
                        <input type="checkbox" name="tablero[]" data-id="{$tablero.idtablero}" {if $tablero.isSelect}checked{/if} value="{$tablero.idtablero}" id="tab-{$tablero.idtablero}">{$tablero.nombreConfiguracion}
                    </label>
                    <span class="dp-arrow-down collapsed" role="button" data-toggle="collapse" data-parent="#accordion" href="#collapseOne" aria-expanded="false" aria-controls="collapseOne"></span>

                </div>
                <div id="collapseOne" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingOne">
                    <div class="panel-body" id="div_sub_tabla_{$tablero.idtablero}">
                        {foreach from=$tablero.sub_tablero item=sub_tablero}
                        <label for="tab-{$sub_tablero.idtablero}" class="checkbox"><input name="tablero[]" type="checkbox" {if $sub_tablero.isSelect}checked{/if} value="{$sub_tablero.idtablero}" id="tab-{$sub_tablero.idtablero}">{$sub_tablero.nombreConfiguracion}</label>
                        {/foreach}
                    </div>
                </div>
            </div>
            {else}
            {if $tablero.submodulo != "ginecologia" || ($paciente.sexo == 0 && $tablero.submodulo == "ginecologia")}
            <div class="panel-heading">
                <label for="tab-{$tablero.idtablero}" class="checkbox"><input name="tablero[]" type="checkbox" {if $tablero.isSelect}checked{/if} value="{$tablero.idtablero}" id="tab-{$tablero.idtablero}">{$tablero.nombreConfiguracion}
                </label>
            </div>
            {/if}
            {/if}
            {/if}
            {/foreach}
        </div>
    </div>

    <div class="modal-btns">
        <button onclick ="submitFormTablero();">{"guardar"|x_translate}</button>
    </div>
</form>
{literal}
<script>
    function submitFormTablero() {

        x_sendForm($('#tablero_form'), true, function(data) {
            
            if (data.result) {
                $("#configurar-tablero").modal('toggle');
                x_alert(data.msg, recargar);
            }else{
                x_alert(data.msg);
            }
        });
    }


    $(document).ready(function() {

        renderUI2("configurar-tablero");

        $(".tablero_sub_tablero input[type=checkbox]").change(function() {
            var id = $(this).data("id");
            if ($(this).is(":checked")) {
                $("#div_sub_tabla_" + id + " input[type=checkbox]").radiocheck('check');
            } else {
                $("#div_sub_tabla_" + id + " input[type=checkbox]").radiocheck('uncheck');
            }
            
            
        });


    });

</script>
{/literal}