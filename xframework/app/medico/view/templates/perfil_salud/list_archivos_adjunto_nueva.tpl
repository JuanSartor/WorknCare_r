{if $listado_adjuntos && $listado_adjuntos|@count > 0}
<header>
    <h3><span class="fui-folder"></span>{"Archivos"|x_translate}</h3>
</header>	
<div class="table-responsive table-nueva-consulta" id="table_archivos">
    <table class="table table-striped">
        <tbody>
            
            {foreach from=$listado_adjuntos item=adjunto}
            {foreach from=$adjunto.list_archivos item=archivo_adjunto}
            <tr id="tr_imagen_{$archivo_adjunto.idperfilSaludAdjuntoArchivo}">
                
                <td>
                    <a  href="{$archivo_adjunto.path}" title="{$archivo_adjunto.nombre_archivo}" target="_blank">
                        <img src="{$url}xframework/app/themes/dp02/imgs/ico_pdf.png"> 
                    </a>
                </td>
                <td>
                    <a  href="{$archivo_adjunto.path}" title="{$archivo_adjunto.nombre_archivo}" target="_blank"><span>{if $archivo_adjunto.nombre_archivo != ""}{$archivo_adjunto.nombre_archivo}{else} - {/if}</span>    </a>
                </td>
               
                <td>
                    <label for="archive-{$archivo_adjunto.idperfilSaludAdjuntoArchivo}" class="checkbox check_delete"><input class="input_check_list" data-nombrearchivo="{$archivo_adjunto.nombre_archivo}" data-locationarchivo="{$archivo_adjunto.path}" type="checkbox" value="{$archivo_adjunto.idperfilSaludAdjuntoArchivo}" id="archive-{$archivo_adjunto.idperfilSaludAdjuntoArchivo}"></label>
                </td>
            </tr>
            {/foreach}
            {/foreach}
                
        </tbody>
    </table>
</div>
    
<div class="col-md-12 text-right">
    <a href="javascript:;" class="btn btn-md btn-red modal-btn" id="eliminar-adjuntos" role="button"><span class="fui-trash"></span>{"Eliminar"|x_translate}</a>
</div>
<br>
  
<div class="clearfix"></div>
{literal}
<script>
    $(document).ready(function () {
        
        $("#agregar-adjunto .btn-save").show();
        
        renderUI2("table_archivos");
        
        //eliminar adjuntos
        $("#eliminar-adjuntos").click(function () {
            var ids = "";
            
            
            $.each($("#div_archivos_adjunto .check_delete").find("[type=checkbox]:checked"),
            function (index, value) {
                ids += "," + $(this).val();
                //console.log($(this).val());
            });
            
            if (ids.length > 0) {
                ids = ids.substring(1);
            } else {
                
                x_alert(x_translate("No hay adjuntos seleccionadas"));
                return false;
            }
            
            
            jConfirm({
                title: x_translate("Eliminar"),
                text: x_translate('Desea eliminar los archivos seleccionados?'),
                confirm: function () {
                    $("#div_archivos_adjunto").spin("large");
                    
                    x_doAjaxCall(
                            'POST',
                    BASE_PATH + 'drop_multiple_adjuntos.do',
                    'ids=' + ids,
                    function (data) {
                        x_alert(data.msg);
                        $("#div_archivos_adjunto").spin(false);
                        if (data.result) {
                            //Actualizo el listado
                            
                            x_loadModule('perfil_salud', 'list_archivos_adjunto_nueva', 'id=' + $("#idpaciente").val() + "&idperfilSaludConsulta=" + $("#idperfilSaludConsulta").val(), 'div_archivos_adjunto', BASE_PATH + "medico");
                            
                        }
                        
                    }
                            );
                },
                cancel: function () {
                    
                },
                confirmButton: x_translate("Si"),
                cancelButton: x_translate("No")
            });
        });
        
  
    });
    
    
</script>
{/literal}
{/if}