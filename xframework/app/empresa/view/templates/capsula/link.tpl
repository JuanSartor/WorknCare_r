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
    <form id="form_cargar_file"  name="form_cargar_file" action="{$url}cargar_link.do" method="POST" onsubmit="return false;">
        <input  id="titulo" name="titulo" hidden >
        <div class="col-xs-12 cont-link">
            <label  class="mapc-label label-personalizar label-link">{"Link"|x_translate}</label>
            <input id="input_link" name="input_link" class="input-personalizar input-title " type="text"  value="{$linkCapsula.link}" placeholder="{$linkCapsula.link}"/>
        </div>
        <div class="col-xs-12 contenedor-btn-siguiente-iban cont-btn-agregar">
            <a href="javascript:;"  class="btn-default btn-siguiente btn-default-iban" id="btn-carga-archivos" >{"Siguiente"|x_translate}</a>
        </div>

    </form>
</section>


{x_load_js}
<script>


    $(function () {

        $("#btn-carga-archivos").click(function () {
            if ($("#cant_capsulas_lista").val() < 1) {
                titulo = $("#input_titulo").val();
                link = $("#input_link").val();
                if (link != '') {
                    if (titulo != '') {
                        $("#titulo").val($("#input_titulo").val());
                        x_sendForm($('#form_cargar_file'), true, function (data) {

                            window.location.href = BASE_PATH + "entreprises/capsuleresready/" + data.hash + ".html";
                        });
                    } else {
                        x_alert(x_translate("Debe completar un titulo"));
                        $("#input_titulo").css('border', 'solid 2px red');
                    }
                } else {
                    x_alert(x_translate("Debe completar un titulo"));
                    $("#input_link").css('border', 'solid 2px red');
                }
            } else {
                x_alert(x_translate('Solo puede tener una capsula para ser compartida'));
            }

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
