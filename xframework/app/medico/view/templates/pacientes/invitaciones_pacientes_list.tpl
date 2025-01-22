{foreach from=$listado_invitaciones item=invitacion} 
<div class="okm-row pul-pi-data-box">
    <div class="col-data">
        
        <span>{$invitacion.apellido}</span>
        <br>
        <small class="solicitud-enviada">{"Solicitud enviada el"|x_translate} {$invitacion.ultimoenvio|date_format:"%d/%m/%Y %H:%M"}</small>
        <br>
        <a href="javascript:;" class="btn-cancelar-invitacion" data-id="{$invitacion.idmedico_paciente_invitacion}" style="color:#cf3244"><small><i class="icon-doctorplus-cruz"></i>&nbsp;{"Cancelar"|x_translate}</small></a>
    </div>
    <div class="col-info">
        <small>{if $invitacion.medico_cabecera==1}{"Médico de cabecera"|x_translate}{/if}</small>
     
    </div>
    <div class="col-action">
        <a href="javascript:;" data-id="{$invitacion.idmedico_paciente_invitacion}" class="reenviar_invitacion btn-min-width">{"reenviar"|x_translate}</a>
    </div>
</div>
{/foreach}
{literal}
<script>
    $(function () {
        $("#div_invitaciones_pacientes").spin(false);
        
        //boton reenviar invitacion
        $(".reenviar_invitacion").click(function () {
            var id=parseInt($(this).data("id"));
            if(id>0){
                
                
                //confirmar la accion
                jConfirm({
                    title: x_translate("Reenviar invitación"),
                    text: x_translate("Confirma que desea reenviar la invitación al paciente?"),
                    confirm: function () {
                        
                        $("body").spin("large");
                        x_doAjaxCall(
                        'POST',
                        BASE_PATH + "reenviar-invitacion-paciente.do",
                        "id="+id,
                        function (data) {
                            x_alert(data.msg);
                            $("body").spin(false);
                            if (data.result) {
                            
                                $("#div_invitaciones_pacientes").spin("large");
                                x_loadModule('pacientes', 'invitaciones_pacientes_list', '', 'div_invitaciones_pacientes');

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
        
        //boton eliminar 
          $(".btn-cancelar-invitacion").click(function () {
            var id=parseInt($(this).data("id"));
            if(id>0){
                
                
                //confirmar la accion
                jConfirm({
                    title: x_translate("Cancelar invitación"),
                    text: x_translate("Confirma que desea cancelar la invitación al paciente?"),
                    confirm: function () {
                        
                        $("body").spin("large");
                        x_doAjaxCall(
                        'POST',
                        BASE_PATH + "cancelar-invitacion-paciente.do",
                        "id="+id,
                        function (data) {
                            x_alert(data.msg);
                            $("body").spin(false);
                            if (data.result) {
                            
                                $("#div_invitaciones_pacientes").spin("large");
                                x_loadModule('pacientes', 'invitaciones_pacientes_list', '', 'div_invitaciones_pacientes');
                                
                                
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
    });
</script>
{/literal}