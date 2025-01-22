<div class="row cs-nc-p2-row-divider">

    <div class="col-sm-2">
        <label>{"Rango de tarifa"|x_translate}</label>
    </div>
    <div class="col-sm-10">
        <div class="cs-nc-p2-range-holder">
            <div class="cs-nc-p2-bg-bars">
                <ul>
                    {foreach from=$rango_precios.precios item=precio}
                        {math assign="h" equation='0+50*i/j' i=$precio j=$rango_precios.cantidad_max} 
                        {math assign="w" equation='100/j' j=$rango_precios.intervalos} 
                        <li style="height: {$h}px; width:{$w}%; "></li>
                        {/foreach}

                </ul>
            </div>
            <div class="cs-nc-p2-range">
                <div id="slider-range" class="cs-ui-range"></div>

                <div class="cs-ui-range-values">

                    <input type="text" id="amount-min" class="cs-ui-range-value min" readonly>
                    {math assign="position" equation='ancho*((j/5)-1)' ancho=$w j=$rango_precios.tarifa_recomendada} 
                    {if $rango_precios.tarifa_recomendada}
                        <div class="cs-ui-range-values-promedio" style="left:50%; top:-17px;">
                            <div class="cs-ui-range-values-promedio-box">
                                <span>&euro; {$rango_precios.tarifa_recomendada} {"tarifa recomendada"|x_translate}</span>
                                {*<div class="cs-ui-range-values-promedio-arrow"></div>*}
                            </div>

                        </div>
                    {/if}
                    <input type="text" id="amount-max" class="cs-ui-range-value max" readonly>
                </div>
            </div>
        </div>
    </div>
</div>
<script>
    var PRECIO_MINIMO_CE = {$PRECIO_MINIMO_CE};
    var PRECIO_MAXIMO_CE = {$PRECIO_MAXIMO_CE};
</script>
{literal}
    <script>




        $(function () {
            $("#slider-range").slider({
                range: true,
                min: PRECIO_MINIMO_CE,
                max: PRECIO_MAXIMO_CE,
                step: 5,
                values: [PRECIO_MINIMO_CE, PRECIO_MAXIMO_CE],
                slide: function (event, ui) {
                    $("#amount-min").val("€ " + ui.values[0]);
                    $("#amount-max").val("€ " + ui.values[1]);
                    $("#rango_minimo").val(ui.values[0]);
                    $("#rango_maximo").val(ui.values[1]);
                }
            });
            $("#amount-min").val("€ " + $("#slider-range").slider("values", 0));
            $("#amount-max").val("€ " + $("#slider-range").slider("values", 1));
            $("#rango_minimo").val($("#slider-range").slider("values", 0));
            $("#rango_maximo").val($("#slider-range").slider("values", 1));


        });



    </script>

{/literal}