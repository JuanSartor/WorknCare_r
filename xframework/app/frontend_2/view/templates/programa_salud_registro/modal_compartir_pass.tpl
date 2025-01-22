<div class="modal modal-compartir-pass" tabindex="-1" role="dialog" data-keyboard="false" data-backdrop="static" aria-hidden="false"  id="modal-compartir-pass">
    <div class="modal-dialog container" role="document">
        <div class="modal-content  ">

            <div class="modal-header text-center">
                <a href="javascript:;" class="btn btn-default btn-copy-contenido" id="btn-copy-contenido">{"Copia la invitación"|x_translate}</a>
            </div>
            <div class="modal-body">
                <button type="button" class="dp-dismiss custom close" data-dismiss="modal" aria-label="Close"></button>
                <div class="form-group okm-row" id="content_to_copy">


                    <div class="text-center">
                        <div class="pass-logo">
                            <img src="{$IMGS}logo_workncare_color.png">
                        </div>
                        <h5 class="modal-title text-center" > {"Invitación"|x_translate}</h5>
                    </div>
                    <div class="text-center">
                        <p>{$contratante.nombre} {$contratante.apellido} {"te invita a registrarte gratis en la plataforma WorknCare."|x_translate}</p>
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