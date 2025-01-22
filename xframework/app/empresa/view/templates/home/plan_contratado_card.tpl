<div class="modal modal-plan-contratado" tabindex="-1" role="dialog" id="modal-plan-contratado" data-keyboard="false" data-backdrop="static">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <button type="button" class="dp-dismiss custom close" data-dismiss="modal" aria-label="Close"></button>
            <div class="modal-body" id="modal-plan-contratado-body">
                <div class="pass-sante-registro-planes">
                    <div class="creacion-cuenta">
                        <div class="header-container text-center" style="margin-top: 0px;">
                            <div class="logo-container">
                                <img style="width: 150px;" src="{$IMGS}logo_workncare_color.png"/>
                                <!-- <span class="label-logo">par DoctorPlus</span> -->
                            </div>
                        </div>
                        <div class="planes-wrapper"> 
                            <p class="text-center">{"Comienzo"|x_translate}: {if $plan_contratado.fecha_adhesion_format!='' }{$plan_contratado.fecha_adhesion_format}{else} {$plan_contratado.fecha_alta_format}  {/if} 
                                {if $plan_contratado.fecha_vencimiento_format !='' && $plan_contratado.fecha_vencimiento!='1971-01-01'} - {$plan_contratado.fecha_vencimiento_format} {/if}</p>
                            <div class="okm-row listado-planes" style="margin-top: 0px;">

                                <div class="item-plan"  data-id="{$plan_detalle.idprograma_salud_plan}">
                                    <div class="plan-title">
                                        {$plan_detalle.nombre}
                                    </div>
                                    {if $plan_detalle.idprograma_salud_plan !=21 && $plan_detalle.idprograma_salud_plan !=22 && $plan_detalle.idprograma_salud_plan !=23}
                                        <div class="plan-precio">
                                            {if $cupon}
                                                <span class="precio-tachado">
                                                    <hr>
                                                    <small>&euro;{$plan_detalle.precio}</small>
                                                </span>
                                                {math equation="precio - (precio*desc/100)" precio=$plan_detalle.precio desc=$cupon.porcentaje_descuento assign=precio_descuento} 
                                                &euro;{$precio_descuento}
                                                <input type="hidden" id="costo_plan" value="{$precio_descuento}" />
                                            {else}
                                                &euro; {$plan_detalle.precio}
                                                <input type="hidden" id="costo_plan" value="{$plan_detalle.precio}" />
                                            {/if}

                                            <div class="label">
                                                {if $plan_detalle.pack==1}
                                                    {"paquete válido por 1 año"|x_translate}
                                                {else}
                                                    {"precio por beneficiario / por mes"|x_translate}
                                                {/if}
                                            </div>
                                        </div>
                                    {/if}
                                    {if $cupon}
                                        <div class="cupon-descuentos">
                                            <h3><i class="fa fa-tag"></i>&nbsp;{"Cupón de descuento"|x_translate}</h3>
                                            <p>{$cupon.codigo_cupon} <em><small>({$cupon.descuento})</small></em></p>
                                        </div>
                                    {/if}
                                    {if $plan_detalle.idprograma_salud_plan!=4}
                                        <div class="consultas-incluidas">
                                            {if $plan_detalle.idprograma_salud_plan ==21 || $plan_detalle.idprograma_salud_plan ==22}
                                                <h3>{"Formule Découverte"|x_translate}</h3>
                                            {else}
                                                <h3> {math equation="x+y" x=$plan_detalle.cant_videoconsulta y=$plan_detalle.cant_consultaexpress}  {"consultas incluidas"|x_translate}</h3>
                                            {/if}
                                            {if $plan_detalle.idprograma_salud_plan ==21 || $plan_detalle.idprograma_salud_plan ==22}
                                                <p style="text-align: left; margin-left: 60px;">
                                                    <i style="position: absolute; top: 180px; left: 45px;" class="fa fa-check"></i>{"Votre 1er DUERP gratuit"|x_translate}
                                                </p>
                                                <p style="text-align: left; margin-left: 60px;">
                                                    <i style="position: absolute; top: 206px; left: 45px;" class="fa fa-check"></i>{"6 utilisations pour :"|x_translate}
                                                </p>      
                                                <p style="text-align: left; margin-left: 60px;">
                                                    - {"Questionnaires"|x_translate}
                                                </p>
                                                <p style="text-align: left; margin-left: 60px;">
                                                    - {"Capsules Information"|x_translate}
                                                </p>
                                            {else}
                                                <p>
                                                    <i class="fa fa-check"></i> {$plan_detalle.cant_consultaexpress} {"consultas por chat"|x_translate}
                                                </p>
                                                <p>
                                                    <i class="fa fa-check"></i> {$plan_detalle.cant_videoconsulta} {"consultas por video"|x_translate}
                                                </p>
                                                <p>
                                                    <i class="fa fa-plus"></i> {"Encuestas RPS QVT"|x_translate}
                                                </p>
                                            {/if}
                                            </ul>
                                        </div>
                                    {else}
                                        <div class="consultas-incluidas">
                                            <h3>   {"Consultas Ilimitadas"|x_translate}</h3>
                                            <p>
                                                <i class="fa fa-check"></i>  {"Ilimitadas por chat"|x_translate}
                                            </p>
                                            <p>
                                                <i class="fa fa-check"></i>  {"Ilimitadas por video"|x_translate}
                                            </p>
                                            <p>
                                                <i class="fa fa-plus"></i> {"Encuestas RPS QVT"|x_translate}
                                            </p>
                                            </ul>
                                        </div>
                                    {/if}
                                    <hr>
                                    <div  class="descripcion-content">
                                        {if $plan_detalle.idprograma_salud_plan==1}
                                            {if $plan_detalle.primer_texto_card!=''}
                                                <p>{if $TRADUCCION_DEFAULT=="fr"}  {$plan_detalle.primer_texto_card} {else}  {$plan_detalle.primer_texto_card_en} {/if}</p>
                                            {else}
                                                <p>{"1. Para comenzar"|x_translate}</p>
                                            {/if}
                                            {if $plan_detalle.segundo_texto_card!=''}
                                                <p>{if $TRADUCCION_DEFAULT=="fr"}  {$plan_detalle.segundo_texto_card} {else} {$plan_detalle.segundo_texto_card_en} {/if}</p>
                                            {else}
                                                <p>{"1. Libre de impuestos para el empleado"|x_translate}</p>
                                            {/if}
                                            {if $plan_detalle.tercer_texto_card!=''}
                                                <p>{if $TRADUCCION_DEFAULT=="fr"}  {$plan_detalle.tercer_texto_card} {else} {$plan_detalle.tercer_texto_card_en} {/if}</p>
                                            {else}
                                                <p>{"1. Deducible para la empresa"|x_translate}</p>
                                            {/if}
                                        {else if $plan_detalle.idprograma_salud_plan==2}
                                            {if $plan_detalle.primer_texto_card!=''}
                                                <p>{if $TRADUCCION_DEFAULT=="fr"}  {$plan_detalle.primer_texto_card} {else}  {$plan_detalle.primer_texto_card_en} {/if}</p>
                                            {else}
                                                <p>{"2. Con seguimiento"|x_translate}</p>
                                            {/if}
                                            {if $plan_detalle.segundo_texto_card!=''}
                                                <p>{if $TRADUCCION_DEFAULT=="fr"}  {$plan_detalle.segundo_texto_card} {else} {$plan_detalle.segundo_texto_card_en} {/if}</p>
                                            {else}
                                                <p>{"2. Libre de impuestos para el empleado"|x_translate}</p>
                                            {/if}
                                            {if $plan_detalle.tercer_texto_card!=''}
                                                <p>{if $TRADUCCION_DEFAULT=="fr"}  {$plan_detalle.tercer_texto_card} {else} {$plan_detalle.tercer_texto_card_en} {/if}</p>
                                            {else}
                                                <p>{"2. Deducible para la empresa"|x_translate}</p>
                                            {/if}
                                        {else if $plan_detalle.idprograma_salud_plan==3}
                                            {if $plan_detalle.primer_texto_card!=''}
                                                <p>{if $TRADUCCION_DEFAULT=="fr"}  {$plan_detalle.primer_texto_card} {else}  {$plan_detalle.primer_texto_card_en} {/if}</p>
                                            {else}
                                                <p>{"3. Mini programa!"|x_translate}</p>
                                            {/if}
                                            {if $plan_detalle.segundo_texto_card!=''}
                                                <p>{if $TRADUCCION_DEFAULT=="fr"}  {$plan_detalle.segundo_texto_card} {else} {$plan_detalle.segundo_texto_card_en} {/if}</p>
                                            {else}
                                                <p>{"3. Sin exención de impuestos (i)"|x_translate}</p>
                                            {/if}
                                            {if $plan_detalle.tercer_texto_card!=''}
                                                <p>{if $TRADUCCION_DEFAULT=="fr"}  {$plan_detalle.tercer_texto_card} {else} {$plan_detalle.tercer_texto_card_en} {/if}</p>
                                            {else}
                                                <p>{"3. Deducible para la empresa"|x_translate}</p>
                                            {/if}
                                        {else if $plan_detalle.idprograma_salud_plan==4}
                                            {if $plan_detalle.primer_texto_card!=''}
                                                <p>{if $TRADUCCION_DEFAULT=="fr"}  {$plan_detalle.primer_texto_card} {else}  {$plan_detalle.primer_texto_card_en} {/if}</p>
                                            {else}
                                                <p>{"4. Programa ilimitado!"|x_translate}</p>
                                            {/if}
                                            {if $plan_detalle.segundo_texto_card!=''}
                                                <p>{if $TRADUCCION_DEFAULT=="fr"}  {$plan_detalle.segundo_texto_card} {else} {$plan_detalle.segundo_texto_card_en} {/if}</p>
                                            {else}
                                                <p>{"4. Sin exención de impuestos (i)"|x_translate}</p>
                                            {/if}
                                            {if $plan_detalle.tercer_texto_card!=''}
                                                <p>{if $TRADUCCION_DEFAULT=="fr"}  {$plan_detalle.tercer_texto_card} {else} {$plan_detalle.tercer_texto_card_en} {/if}</p>
                                            {else}
                                                <p>{"4. Deducible para la empresa"|x_translate}</p>
                                            {/if}
                                        {else if $plan_detalle.idprograma_salud_plan==5}
                                            {if $plan_detalle.primer_texto_card!=''}
                                                <p>{if $TRADUCCION_DEFAULT=="fr"}  {$plan_detalle.primer_texto_card} {else}  {$plan_detalle.primer_texto_card_en} {/if}</p>
                                            {else}
                                                <p>{"5. Descubrimiento"|x_translate}</p>
                                            {/if}
                                            {if $plan_detalle.segundo_texto_card!=''}
                                                <p>{if $TRADUCCION_DEFAULT=="fr"}  {$plan_detalle.segundo_texto_card} {else} {$plan_detalle.segundo_texto_card_en} {/if}</p>
                                            {else}
                                                <p>{"5. Libre de impuestos para el empleado"|x_translate}</p>
                                            {/if}
                                            {if $plan_detalle.tercer_texto_card!=''}
                                                <p>{if $TRADUCCION_DEFAULT=="fr"}  {$plan_detalle.tercer_texto_card} {else} {$plan_detalle.tercer_texto_card_en} {/if}</p>
                                            {else}
                                                <p>{"5. Personalizable por el CSE"|x_translate}</p>
                                            {/if}
                                        {else if $plan_detalle.idprograma_salud_plan==6}
                                            {if $plan_detalle.primer_texto_card!=''}
                                                <p>{if $TRADUCCION_DEFAULT=="fr"}  {$plan_detalle.primer_texto_card} {else}  {$plan_detalle.primer_texto_card_en} {/if}</p>
                                            {else}
                                                <p>{"6. Con seguimiento"|x_translate}</p>
                                            {/if}
                                            {if $plan_detalle.segundo_texto_card!=''}
                                                <p>{if $TRADUCCION_DEFAULT=="fr"}  {$plan_detalle.segundo_texto_card} {else} {$plan_detalle.segundo_texto_card_en} {/if}</p>
                                            {else}
                                                <p>{"6. Libre de impuestos para el empleado"|x_translate}</p>
                                            {/if}
                                            {if $plan_detalle.tercer_texto_card!=''}
                                                <p>{if $TRADUCCION_DEFAULT=="fr"}  {$plan_detalle.tercer_texto_card} {else} {$plan_detalle.tercer_texto_card_en} {/if}</p>
                                            {else}
                                                <p>{"6. Personalizable por el CSE"|x_translate}</p>
                                            {/if}
                                        {else if $plan_detalle.idprograma_salud_plan==7}
                                            {if $plan_detalle.primer_texto_card!=''}
                                                <p>{if $TRADUCCION_DEFAULT=="fr"}  {$plan_detalle.primer_texto_card} {else}  {$plan_detalle.primer_texto_card_en} {/if}</p>
                                            {else}
                                                <p>{"7. Mini programa"|x_translate}</p>
                                            {/if}
                                            {if $plan_detalle.segundo_texto_card!=''}
                                                <p>{if $TRADUCCION_DEFAULT=="fr"}  {$plan_detalle.segundo_texto_card} {else} {$plan_detalle.segundo_texto_card_en} {/if}</p>
                                            {else}
                                                <p>{"7. Libre de impuestos para el empleado"|x_translate}</p>
                                            {/if}
                                            {if $plan_detalle.tercer_texto_card!=''}
                                                <p>{if $TRADUCCION_DEFAULT=="fr"}  {$plan_detalle.tercer_texto_card} {else} {$plan_detalle.tercer_texto_card_en} {/if}</p>
                                            {else}
                                                <p>{"7. Personalizable por el CSE"|x_translate}</p>
                                            {/if}
                                        {else}
                                            {if $plan_detalle.primer_texto_card!=''}
                                                <p>{if $TRADUCCION_DEFAULT=="fr"}  {$plan_detalle.primer_texto_card} {else}  {$plan_detalle.primer_texto_card_en} {/if}</p>
                                            {else}
                                                <p>{"1. Para comenzar"|x_translate}</p> 
                                            {/if}
                                            {if $plan_detalle.segundo_texto_card!=''}
                                                <p>{if $TRADUCCION_DEFAULT=="fr"}  {$plan_detalle.segundo_texto_card} {else} {$plan_detalle.segundo_texto_card_en} {/if}</p>
                                            {else}
                                                <p>{"1. Libre de impuestos para el empleado"|x_translate}</p>
                                            {/if}
                                            {if $plan_detalle.tercer_texto_card!=''}
                                                <p>{if $TRADUCCION_DEFAULT=="fr"}  {$plan_detalle.tercer_texto_card} {else} {$plan_detalle.tercer_texto_card_en} {/if}</p>
                                            {else}
                                                <p>{"1. Deducible para la empresa"|x_translate}</p>
                                            {/if}
                                        {/if}
                                    </div>

                                </div>

                            </div>
                        </div>        
                        {*si es una suscripcion y no pack permitimos hacer un upgrade*}
                        {*si es un pack permitimos comprar mas paquetes*}
                        {if $plan_detalle.pack=="1" && $plan_detalle.idprograma_salud_plan!="21" && $plan_detalle.idprograma_salud_plan!="23"}
                            <div class="clearfix">&nbsp;</div>
                            <div class="okm-row" id="cant_packs_container">

                                <div class="mapc-registro-form-row">
                                    <label class="mapc-label">{"Cantidad de pack adquiridos"|x_translate}</label>
                                    <div class="mapc-input-line input-group" >
                                        <span class="input-group-addon button menos-cant" id="menos-cant" ><i class="fa fa-minus"></i></span>
                                        <input type="number" class="pul-np-dis" name="cant_packs" id="cant_packs" style="text-align: center;" value="1"/>
                                        <span class="input-group-addon button mas-cant" id="mas-cant"><i class="fa fa-plus"></i></span>
                                    </div>
                                </div>
                            </div>
                            <div class="okm-row" >
                                <div class="mapc-registro-form-row">
                                    <label class="mapc-label">{"Precio total de pack adquiridos"|x_translate}:&nbsp;
                                        <span class="precio-total-pack">

                                        </span>
                                    </label>

                                </div>
                                <div class="text-center button-container">
                                    <a href="javascript:;" class="btn btn-comprar-pack btn-default">{"Comprar más paquetes"|x_translate}</a>
                                </div>
                            </div>
                        </div>
                    {else}
                        {*si la suscripcion está activa permitimos el cambio*}
                        {if $usuario_empresa.cancelar_suscripcion!="2"
                        || ($usuario_empresa.cancelar_suscripcion =="2" &&($usuario_empresa.plan_idplan=="21" || $usuario_empresa.plan_idplan=="22"))}
                        <div class="text-center button-container">
                            <a href="{$url}entreprises/abonnement.html" class="btn btn-cambiar-plan btn-default">{"Cambiar plan"|x_translate}</a>
                        </div>
                    {/if}
                    {/if}
                    </div>      
                </div>
            </div>
        </div>    
    </div>
</div>
{if $plan_detalle.pack=="1"}
    <script>
        var STRIPE_APIKEY_PUBLIC = "{$STRIPE_APIKEY_PUBLIC}";
    </script>
    <script src="https://js.stripe.com/v3/"></script>
    {*verificamos si hay cargada una compra de mas paquetes con pago pendiente*}
    {if $compra_suscripcion_pendiente}
        <script>
        var idsuscripcion_pendiente = "{$compra_suscripcion_pendiente.idprograma_salud_suscripcion}";
            {literal}
                $(function () {
                    $("body").spin("large");
                    x_loadModule('home', 'checkout_pack_form', 'id=' + idsuscripcion_pendiente, 'modal-plan-contratado-body').then(function () {
                        $("#modal-plan-contratado").modal("show");
                        $("body").spin(false);

                    });
                });
            {/literal}
        </script>
    {else}
        {literal}
            <script>
                $(function () {
                    //listener modificar cantidad pack
                    $(".mas-cant,.menos-cant").click(function () {
                        let actual_val = parseInt($("#cant_packs").val());
                        if (isNaN(actual_val)) {
                            return false;
                        }

                        if ($(this).hasClass("mas-cant")) {
                            $("#cant_packs").val(++actual_val);
                        } else {
                            //minimo 1 pack, no seguimos restando
                            if (actual_val > 1) {
                                $("#cant_packs").val(--actual_val);
                            }
                        }
                        $("#cant_packs").trigger("change");


                    });
                    //detectamos el cambio de la cantidad y recalculamos el total
                    $("#cant_packs").change(function () {
                        if (isNaN(parseInt($("#costo_plan").val())) || isNaN(parseInt($("#cant_packs").val()))) {
                            return false;
                        }
                        $(".precio-total-pack").html("€" + (parseFloat($("#costo_plan").val()) * parseInt($("#cant_packs").val())).toFixed(1));
                    });

                    //seteamos el precio total de pack inicialmente con un trigger al input de cantidad
                    $("#cant_packs").trigger("change");

                    $(".btn-comprar-pack").click(function () {
                        jConfirm({
                            title: x_translate("Comprar más paquetes"),
                            text: x_translate('Está por adquirir nuevos paquetes del Pase de bienestar. ¿Desea continuar?'),
                            confirm: function () {
                                $("#modal-plan-contratado").spin("large");

                                x_doAjaxCall(
                                        'POST',
                                        BASE_PATH + 'empresa.php?action=1&modulo=home&submodulo=nueva_compra_suscripcion_pack',
                                        'cant_packs=' + $("#cant_packs").val(),
                                        function (data) {
                                            $("#modal-plan-contratado").spin(false);
                                            if (data.result && data.id) {
                                                $("#modal-plan-contratado").spin("large");
                                                x_loadModule('home', 'checkout_pack_form', 'id=' + data.id, 'modal-plan-contratado-body').then(function () {
                                                    $("#modal-plan-contratado").spin(false);

                                                });
                                            } else {
                                                x_alert(data.msg);
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
{/if}