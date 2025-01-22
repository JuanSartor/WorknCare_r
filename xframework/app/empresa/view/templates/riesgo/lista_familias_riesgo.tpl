<style>
    .checkbox .icon-unchecked:before {
        content: "\e60b";
    }
    .checkbox .icon-checked:before {
        content: "\e60c";
    }
    .btn-sig-etapa{
        background: white;
        color: #3DB4C0;
        border: 2px solid;
    }
</style>
<section class="okm-container">
    <div class="col-xs-12 programas-incluidos">
        <input  id="id_familia_cuestionarios" hidden value='{$familia_cuestionario.id_familia_cuestionarios}'>

        <h2 class="title">
            <button onclick="location.href = '{$url}entreprises/risque.html'"  class="btn btn-transparen go-back-button btn-volver"><i class="fa fa-chevron-left"></i></button>
            {"Familias de los Modelos"|x_translate} :
            {if $banderaModelo=='0'}
                {"Mis Modelos"|x_translate}
            {else}
                {"Modelos DUERP"|x_translate}
            {/if}

        </h2>

        {foreach from=$listado item=modelo}


            <div class="programa-item">
                <label class="checkbox">
                    <input type="checkbox"  name="cuestionario" value="{$modelo.idmodelos_riesgos}"  data-toggle="checkbox" class="custom-checkbox">
                </label>
                <a class="btn btn-white programa-header" role="button" data-toggle="collapse" href="#cuestionario-{$modelo.idmodelos_riesgos}" aria-expanded="false" aria-controls="cuestionario-{$modelo.idmodelos_riesgos}">
                    {if $modelo.empresa_idempresa =='0'}
                        {if $TRADUCCION_DEFAULT=="fr"}  {$modelo.nombre}
                        {else}
                            {$modelo.nombre_en}
                        {/if}
                    {else}
                        {$modelo.nombre}
                    {/if}

                    <i class="fa fa-chevron-down pull-right"></i>
                </a>
            </div>
            <div class="collapse" id="cuestionario-{$modelo.idmodelos_riesgos}">
                <ul class="programas-categorias">
                    {foreach from=$modelo.listado_familias item=familia}
                        <li>
                            {if $modelo.empresa_idempresa =='0'}
                                {if $TRADUCCION_DEFAULT=="fr"}
                                    {$familia.titulo}
                                {else}
                                    {$familia.titulo_en}
                                {/if}
                            {else}
                                {$familia.titulo}
                            {/if}
                        </li>
                    {/foreach}
                </ul>
            </div>


        {/foreach}
    </div>
    <div class="okm-row text-center" style="display: flex;">
        <div class="okm-row text-center" {if $familia_cuestionario.idmodelos_riesgos == '1' } style="text-align: right;" {/if}>
            <div class="col-xs-12">
                <a href="javascript:;" class="btn btn-xs btn-default  btn-guardar" >{"Personalizar"|x_translate}</a>
            </div>
        </div>

        {if $familia_cuestionario.idmodelos_riesgos == '1' }
            <div class="okm-row text-center" {if $familia_cuestionario.idmodelos_riesgos == '1' } style="text-align: left;" {/if}>
                <div class="col-xs-12">
                    <a href="javascript:;" id="btnEliminar" class="btn btn-xs btn-default btn-sig-etapa" >{"Eliminar"|x_translate}</a>
                </div>
            </div>
        {/if}
    </div>

    <div class="clearfix">&nbsp;</div>
</section>

{literal}
    <script>
        $(function () {

            // voy al cuestionario seleccionado para poder personalizarlo
            $(".btn-guardar").click(function () {

                var cantseleccionado = 0;
                $("input:checkbox:checked").each(function () {
                    cantseleccionado = 1 + cantseleccionado;
                    // console.log($(this).val());
                });

                var id = $('input:checkbox[name=cuestionario]:checked').val();

                if (cantseleccionado == '1') {
                    if (id != null) {
                        window.location.href = BASE_PATH + "entreprises/risquelist/personnaliser/" + id + ".html";
                    } else {
                        x_alert(x_translate("Debe seleccionar una familia de riesgo"));
                    }
                } else {
                    x_alert(x_translate("Solo debe seleccionar una familia de riesgo para personalizar"));
                }
            });



            // eliminar que permite eliminar el cuestionario 
            // y sus preguntas correspondiente solo a la empresa
            $("#btnEliminar").click(function () {
                id_familia_cuestionarios = $("#id_familia_cuestionarios").val();
                var idsaEliminar = '';
                $("input:checkbox:checked").each(function () {
                    idsaEliminar = $(this).val() + '-' + idsaEliminar;
                    // console.log($(this).val());
                });
                // console.log(idsaEliminar);
                x_doAjaxCall(
                        'POST',
                        BASE_PATH + "empresa.php?action=1&modulo=gestion&submodulo=eliminar_cuestionarios_propios",
                        'idsaEliminar=' + idsaEliminar,
                        function (data) {
                            if (data.result) {

                                x_alert(x_translate(data.msg), function () {

                                    window.location.href = BASE_PATH + "entreprises/questionnairelist/" + id_familia_cuestionarios + ".html";

                                });
                            } else {
                                x_alert(data.msg);
                            }
                        }
                );

            });

        });
    </script>
{/literal}