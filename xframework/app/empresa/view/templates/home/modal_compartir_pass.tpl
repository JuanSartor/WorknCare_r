<div class="modal modal-compartir-pass" tabindex="-1" role="dialog" data-keyboard="false" data-backdrop="static" aria-hidden="false"  id="modal-compartir-pass">
    <div class="modal-dialog container" role="document">
        <div class="modal-content  ">

            <div class="modal-header text-center">
                <a href="javascript:;" class="btn-default btn-copy-contenido" id="btn-copy-contenido">{"Copia la invitación"|x_translate}</a>
            </div>

            <div class="modal-body">
                <button type="button" class="dp-dismiss custom close" data-dismiss="modal" aria-label="Close"></button>
                <div class="form-group okm-row" id="content_to_copy">


                    <div class="text-center">
                        {if $record.image!=''}
                            <div class="row" style="display: flex; justify-content: center;">
                                <div class="pass-logo">
                                    <img style="width:110px; margin-right: 20px;" src="{$IMGS}logo_workncare_color.png">
                                </div>
                                <div class="pass-logo-socio">
                                    <img  class="icono-empresa-socia" src="{$record.image.usuario}?t={$smarty.now}">

                                </div>
                            </div>
                        {else}
                            <div class="pass-logo">
                                <img style="width: 200px;" src="{$IMGS}logo_workncare_color.png">
                            </div>    
                        {/if}
                        <h5 class="modal-title text-center" > {"Invitación"|x_translate}</h5>

                    </div>
                    <div class="text-center">
                        <p>{$contratante.nombre} {$contratante.apellido} {"te invita a registrarte en WorknCare."|x_translate}</p>
                        <p>{"Comienzo"|x_translate}: {$plan_contratado.fecha_adhesion_format}</p>
                    </div>

                    <div class="text-center">
                        <p><strong>{"Haga clic en este enlace"|x_translate}:</strong></p>
                        <div class="link-wrapper text-center">
                            <a href="{$url}beneficiaireworkncare/{$smarty.request.id}.html" class="text-center" target="_blank">{$url}beneficiaireworkncare/{$smarty.request.id}.html</a>
                        </div>
                    </div>
                    <div class="text-center">
                        <p> <strong>{"o Escanee este código QR con su teléfono móvil"|x_translate}:</strong> </p>
                        <img class="qr-code" src="{$url}frontend_2.php?action=1&modulo=programa_salud_registro&submodulo=generar_qr&id={$smarty.request.id}" />
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>