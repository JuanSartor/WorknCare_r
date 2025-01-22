<style>
    .cont-link{
        position: relative;
        top: 64px;
    }
    .cont-btn-agregar{
        position: relative;
        top: 80px;
    }
    .label-link{
        position: relative;
        right: 200px;
    }
</style>
<section class="cargar-factura"id="section-factura">
    <form id="form_cargar_link"  name="form_cargar_link" action="{$url}cargar_linkx.do" method="POST" onsubmit="return false;" style="height: 150px;">
        <input type="hidden" name="contenedorcapsula_idcontenedorcapsula_link" id="contenedorcapsula_idcontenedorcapsula_link"  />
        <input  id="titulo_link" name="titulo_link" hidden >
        <input type="hidden" name="tipo_capsula" id="tipo_capsula" value="2" />
        <div class="col-xs-12 cont-link">
            <label>Link</label>

            <input style="width: 400px;" id="input_link" name="input_link" class="input-personalizar input-title " type="text"  value="{$cuestionario.titulo}" placeholder="{$cuestionario.titulo}"/>
        </div>
        <div class="col-xs-12 contenedor-btn-siguiente-iban cont-btn-agregar">
            <a href="javascript:;"  class="button btn-default btn-siguiente btn-default-iban" id="btn-carga-archivos-link" >{"Siguiente"|x_translate}</a>
        </div>

    </form>
</section>


{x_load_js}
<script>


    $(function () {

        $("#btn-carga-archivos-link").click(function () {

            $("#contenedorcapsula_idcontenedorcapsula_link").val($("#idcontenedorcapsula").val());
            $("#titulo_link").val($("#tituloGeneral").val());

            x_sendForm($('#form_cargar_link'), true, function (data) {
                x_goTo('capsulas', 'capsula_list', '', 'Main', this);
            });



        });



        $("#input_titulo").keypress(function () {
            if ($("#input_titulo").val().length >= 0) {
                $("#input_titulo").css('border', '1px solid #ccc');

            } else {
                $("#input_titulo").css('border', 'solid 2px red');
            }
        });
        $("#input_link").keypress(function () {
            if ($("#input_link").val().length >= 0) {
                $("#input_link").css('border', '1px solid #ccc');

            } else {
                $("#input_link").css('border', 'solid 2px red');
            }
        });


    });


</script> 
