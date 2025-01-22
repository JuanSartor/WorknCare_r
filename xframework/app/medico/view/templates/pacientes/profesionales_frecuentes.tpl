<div class="modal-header">
    <div class="modal-title"><h5>{"Profesionales frecuentes"|x_translate}</h5></div>
    <span class="close-btn" data-dismiss="modal" aria-label="Close"><i class="fui-cross"></i></span>
</div>
<div class="modal-body">
    <div class="form-content medico-pacientes-modal">
        <ul>
            {foreach from=$listado_profesionales_frecuentes item=medico}
                <li>
                    {if $medico.imagenes.usuario != ""}
                        <a href="{$url}panel-medico/profesionales/{$medico.idmedico}-{$medico.nombre|str2seo}-{$medico.apellido|str2seo}.html">
                            <img class="img-circle" src="{$medico.imagenes.usuario}" title="{$medico.nombre} {$medico.apellido}">
                        </a>
                    {else}
                        <a href="{$url}panel-medico/profesionales/{$medico.idmedico}-{$medico.nombre|str2seo}-{$medico.apellido|str2seo}.html">
                            <img class="img-circle" src="{$IMGS}extranet/noimage-paciente.jpg" title="{$medico.nombre} {$medico.apellido}">
                        </a>
                    {/if}
                    <a href="{$url}panel-medico/profesionales/{$medico.idmedico}-{$medico.nombre|str2seo}-{$medico.apellido|str2seo}.html">
                        <h3>{$medico.titulo_profesional.titulo_profesional} {$medico.nombre} {$medico.apellido}</h3>
                    </a>
                    <p><strong>{$medico.mis_especialidades.0.especialidad}</strong> 

                    </p>
                    {if $medico.idmedico!=$idmedicosession}
                        <a href="javascript:;" class="dp-email " data-id="{$medico.idmedico}"></a>
                        <div class="enviar-mje">
                            <textarea name="mensaje" id="text_mensaje_{$medico.idmedico}" class="form-control flat" placeholder='{"Mensaje"|x_translate}'></textarea>
                            <p id="p_text_area_{$medico.idmedico}" style="display: none"></p>
                        </div>
                    {/if}
                </li>
            {foreachelse}
                <li>
                    {"No hay profesionales frecuentes"|x_translate}
                </li>
            {/foreach}
        </ul>
    </div>
</div>

{literal}
    <script>
        $('#profesionales-frecuentes .dp-email').on('click', function () {
            var id = $(this).data("id");

            if ($(this).hasClass('show-textarea')) {

                var $this = $(this);
                if (parseInt(id) > 0 && $("#text_mensaje_" + id).val() != "") {
                    $("body").spin("large");
                    x_doAjaxCall(
                            'POST',
                            BASE_PATH + 'enviar_mensaje_from_mis_pacientes.do',
                            "mensaje=" + $("#text_mensaje_" + id).val() + "&idmedico=" + id,
                            function (data) {
                                $("#text_mensaje_" + id).val("");
                                $("body").spin(false);

                                x_alert(data.msg);
                                $("#text_mensaje_" + id).hide();
                                $("#p_text_area_" + id).show();
                                setTimeout(
                                        function ()
                                        {
                                            $this.removeClass('show-textarea');
                                            $this.next('.enviar-mje').slideUp();
                                            $this.parent('li').removeClass('show-textarea-box');
                                        }, 3000);
                            }
                    );
                }

            } else {
                $("#text_mensaje_" + id).show();
                $("#p_text_area_" + id).hide();
                $('.enviar-mje').slideUp();
                $("#profesionales-frecuentes .dp-email").removeClass('show-textarea');
                $(this).addClass('show-textarea');
                $(this).next('.enviar-mje').slideDown();
                $(this).parent('li').addClass('show-textarea-box');
                $(this).addClass("btn_send_mensaje");
            }
        });



    </script>
{/literal}