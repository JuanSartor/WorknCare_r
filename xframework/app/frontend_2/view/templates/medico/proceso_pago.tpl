<h2>{"Pago"|x_translate}</h2>


{if $medico}

<div class="ok-row mapc-pago-row">
    <div class="mapc-pago-col-table">

        <ul class="mapc-pago-table-header">
            <li>{"Detalle"|x_translate}</li>
            <li>{"Medio de pago"|x_translate}</li>
            <li>{"Precio"|x_translate}</li>
            <li>{"Subtotal"|x_translate}</li>
        </ul>
        <ul class="mapc-pago-table-row">
            <li><span class="inner-txt">{"Abono Cuenta Profesional"|x_translate}</span></li>
            <li>
                <div class="mapc-registro-form-row mapc-select mapc-pago-select">

                    <select name="metodo_pago" id="metodo_pago" class="form-control select select-primary select-block">
                        <option value="">{"Medio de pago"|x_translate}</option>
                        {html_options options=$combo_metodo_pago }
                    </select>
                </div>

            </li>
            <li><span class="inner-txt">&euro;{$MONTO_CUOTA}{"$/mes"|x_translate}</span></li>
            <li>
                <div class="mapc-table-subtotal"><span class="inner-txt">&euro;{$MONTO_CUOTA}</span></div>
            </li>
        </ul>
        
        <div class="okm-row">
             <a href="javascript:;" class="mapc-codigo-promocion">{"Tengo un código promocional"|x_translate}</a>
            <div class="mapc-table-subtotal-footer"><span>&euro;{$MONTO_CUOTA}</span></div>
        </div>

        <div class="okm-row">
           
            <div class="mapc-codigo-promocion-box">
                <form name="mapc-codigo-promocional">
                    <input type="text" name="codigo-promocional" placeholder='{"Ingrese su Código Promocional"|x_translate}'/>
                    <input type="submit" value="APLICAR"/>
                </form>
            </div>

        </div>
        
        
    </div>

    <div class="mapc-pago-col-resultado">
        <div class="mapc-pago-col-resultado-box">
            <h4>{"Total a pagar"|x_translate}</h4>
            <div class="mapc-pago-precio-final">&euro;{$MONTO_CUOTA}<span>00</span></div>
            <div class="mapc-pago-precio-final-disclaimer">
                {"PESOS ARGENTINOS"|x_translate}
                <span>{"IVA incluído"|x_translate}</span>
            </div>
            
            <div  class="mapc-pago-precio-final-action">
                
                    <a  href="javascript:;"  class="btn-default" id="btnContinuarMP" style="display:none">{"continuar"|x_translate} <span></span></a>
               
              
                    <a  href="javascript:;" class="btn-default"  id="btnContinuar" style="display:none">{"continuar"|x_translate} <span></span></a>
                
            </div>
        </div>
    </div>

    <div class="payment-options">
        <div class="row relative" id="div_metodo_pago">

            
        </div>
    </div>
</div>

{literal}
<script>
    $(document).ready(function() {
        
        renderUI2("section_registracion_abono");

        $("#metodo_pago").change(function() {
            if ($(this).val() == "2") {
                $("#btnContinuar").hide();
                $("#btnContinuarMP").show();

            } else {
                $("#btnContinuarMP").hide();
                $("#btnContinuar").hide();

                $("#div_metodo_pago").empty();
            }
        });
        
        $('.mapc-codigo-promocion').on('click', function(e){
			e.preventDefault();
			$('.mapc-codigo-promocion-box').slideToggle();
		});

        $("#btnContinuarMP").click(function() {

            x_doAjaxCall(
                    'POST',
                    BASE_PATH + "crear_suscripcion_frontend.do",
                    "idmedico=" + $("#idmedico_abono").val(),
                    function(data) {

                        if (data.result) {
                            $("#div_metodo_pago").spin("large");
                          
                            x_loadModule('medico', 'pago_tarjeta', 'idmedico=' + $("#idmedico_abono").val(), 'div_metodo_pago');
                        } else {
                            x_alert(data.msg);
                        }
                    });
        });
    });
</script>
{/literal}
{/if}