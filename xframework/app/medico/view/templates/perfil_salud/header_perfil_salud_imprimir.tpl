<header class="vista-impresion-header">
    <img src="{$IMGS}doctorplus_logo_mobile.png">
</header>
<section class="container divider-print">
    <div class="row vista-impresion-divider">
        <div class="col-sm-2 vista-impresion-holder col-2-print">
            <img class="vista-impresion-avatar" src="{$paciente.image.perfil}" alt="{$paciente.nombre} {$paciente.apellido}"/>
        </div>
        <div class="col-sm-4 vista-impresion-holder col-4-print">
            <span class="vista-impresion-user-name">{$paciente.nombre} {$paciente.apellido}</span>
            <span class="vista-impresion-user-fn"><label>DN</label> {$paciente.fechaNacimiento_format}</span>
        </div>

        <div class="col-sm-4 vista-impresion-holder col-4-print">
            {if $paciente.animal!=1}
                {if $paciente.pais_idpais==1}
                    <span class="vista-impresion-user-name">{"Tarjeta Vitale"|x_translate}</span>
                    <span class="vista-impresion-user-pshb">
                        <label><i class="icon-doctorplus-ficha-tecnica"></i></label>Nº {$paciente.tarjeta_vitale}
                    </span>
                {/if}
                {if $paciente.pais_idpais==2}
                    <span class="vista-impresion-user-name">{"Tarjeta CNS"|x_translate}</span>
                    <span class="vista-impresion-user-pshb">
                        <label><i class="icon-doctorplus-ficha-tecnica"></i></label>Nº {$paciente.tarjeta_cns}
                    </span>
                {/if}
                {if $paciente.pais_idpais==3}
                    <span class="vista-impresion-user-name">{"Tarjeta eID"|x_translate}</span>
                    <span class="vista-impresion-user-pshb">
                        <label><i class="icon-doctorplus-ficha-tecnica"></i></label>Nº {$paciente.tarjeta_eID}
                    </span>
                {/if}
                {if $paciente.pais_idpais==4}
                    <span class="vista-impresion-user-name">{"Pasaporte"|x_translate}</span>
                    <span class="vista-impresion-user-pshb">
                        <label><i class="icon-doctorplus-ficha-tecnica"></i></label>Nº {$paciente.tarjeta_pasaporte}
                    </span>
                {/if}
            {/if}
        </div>

        <div class="col-sm-2 vista-impresion-holder col-2-print">


        </div>
    </div>

</section>

{literal}
    <script>
        $(function () {
            /**Limpiamos todos los botones y comportamiento JS de la vista de impresion para que sea estatica
             * 
             */
            $(".dp-edit").remove();
            $(".vista-impresion a").click(function (e) {
                e.preventDefault();
            });
            $(".vista-impresion button:submit").remove();
            $(".vista-impresion :checkbox").click(function (e) {
                e.preventDefault();
            });
            $(".vista-impresion :radio").click(function (e) {
                e.preventDefault();
            });

            $(".vista-impresion input[type=number]").prop("disabled", true);
            $(".vista-impresion input[type=text]").prop("disabled", true);
            $(".vista-impresion select").prop("disabled", true);
            $(".vista-impresion button").off();
            //$(".vista-impresion a").off();
            //remover comportamiento tagsinput
            $(".vista-impresion input[data-role=tagsinput]").on('beforeItemRemove', function (event) {
                event.cancel = true;
            });
            $(".vista-impresion span[data-role=remove]").remove();

            $("#div_add_cirugia").remove();
            $("#div_add_protesis").remove();

            $("a[data-toggle=modal]").attr("href", "javascript:;");


            setTimeout(function () {
                window.print();
            }, 1500);

        });
    </script>
{/literal}