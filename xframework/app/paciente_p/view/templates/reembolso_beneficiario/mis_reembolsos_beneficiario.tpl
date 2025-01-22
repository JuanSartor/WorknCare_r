<section class="mis-reembolsos">
    <div class="okm-container">
        {if $estadosRegistrados[0].cantidad!='' && $estadosRegistrados[0].estado==0 }
            <div class="titulos-reembolsos-estados">
                <h7>{"Siendo reembolsado"|x_translate}</h7>
            </div>
            {foreach from=$reembolsos item=item}
                {if $item.estado=='0'}
                    <div class="reembolsos">
                        <img src="{$IMGS}icons/en-tramite.svg"/> 
                        <h8>{"Demande envoyée le "}{$item.fecha_en_curso|date_format:"%d/%m/%y"}</h7>
                    </div>
                {/if}
            {/foreach}
        {/if}
        {if ($estadosRegistrados[1].cantidad!='' && $estadosRegistrados[1].estado==1)
            || ($estadosRegistrados[0].cantidad!='' && $estadosRegistrados[0].estado==1)}
        <div class="titulos-reembolsos-estados">
            <h7>{"Reembolso realizado"|x_translate}</h7>
        </div>
        {foreach from=$reembolsos item=item}
            {if $item.estado=='1'}
                <div class="reembolsos">
                    <img src="{$IMGS}icons/realizado.svg"/> 
                    <h8>{"Demande envoyée le "}{$item.fecha_en_curso|date_format:"%d/%m/%y"}</h8>
                    <a href="javascript:;" onclick="reembolsoRealizado({$item.idReembolso})" id="btn-reembolso-realizado" data-id="{$item.idReembolso}" class="btn-default btn-siguiente btn-default-iban btn-consultar-soporte-realizado" >{"Escribir a soporte"|x_translate}</a>

                </div>
            {/if}
        {/foreach}
        {/if}
            {if ($estadosRegistrados[2].cantidad!='' && $estadosRegistrados[2].estado==2)
            || ($estadosRegistrados[1].cantidad!='' && $estadosRegistrados[1].estado==2)
            || ($estadosRegistrados[0].cantidad!='' && $estadosRegistrados[0].estado==2)}
            <div class="titulos-reembolsos-estados">
                <h7>{"Reembolsos rechazado"|x_translate}</h7>
            </div>
            {foreach from=$reembolsos item=item}
                {if $item.estado=='2'}
                    <div class="reembolsos">
                        <img src="{$IMGS}icons/rechazado.svg"/> 
                        <h8>{"Servicio no incluido "|x_translate}{$item.fecha_en_curso|date_format:"%d/%m/%y"}</h8>
                        <input type=text name="idReembolso" id="idReembolso" hidden/>
                        <a href="javascript:;" onclick="reembolsoRechazado({$item.idReembolso})" id="btn-reembolso-rechazado"  data-id="{$item.idReembolso}" class="btn-default btn-siguiente btn-default-iban btn-consultar-soporte-rechazado btn-reembolso-rechazado" >{"Escribir a soporte"|x_translate}</a>

                    </div>
                {/if}
            {/foreach}
            {/if}

            </div>
        </section>

        <!-- Modal para enviar el comentario a soporte -->

        <div class=" modal fade bs-example-modal-sm modal_enviar_comentario_soporte" id="modal_enviar_comentario_soporte" hidden tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel">
            <div class="modal-dialog modal-lg" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    </div>
                    <div class="modal-body">
                        <span class="ce-pc-modal-alert">{"Soporte"|x_translate}</span>
                        <input type=text name="idReembolso" id="idReembolso" hidden/>
                        <input type=text name="banderaEstado" id="banderaEstado" hidden/>
                        <div class="container-textarea">
                            <textarea autofocus required id="textarea" name="textarea" rows="10" cols="50"></textarea>
                        </div>
                        <div class="container-btn-modal">
                            <div class="container-btn-cerrar">
                                <a href="javascript:;" class="btn-default btn-cerrar" data-dismiss="modal" >{"Cerrar"|x_translate}</a>
                            </div>
                            <div class="">
                                <a href="javascript:;" class="btn-default btn-enviar"  id="btnEnviarComentario">{"Enviar"|x_translate}</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>