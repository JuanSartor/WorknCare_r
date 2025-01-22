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
    .pos-ico-img{
        position: absolute;
        left: 400px
    }
</style>
<section class="okm-container">
    <div class="col-xs-12 programas-incluidos">
        <input  id="id_familia_cuestionarios" hidden value='{$familia_cuestionario.id_familia_cuestionarios}'>

        <h2 class="title">
            <button onclick="location.href = '{$url}entreprises/capsule.html'"  class="btn btn-transparen go-back-button btn-volver"><i class="fa fa-chevron-left"></i></button>
            {"Contenedores de la familia"|x_translate} :{if $TRADUCCION_DEFAULT=="fr"}{$familia_cuestionario.nombre} {else}{$familia_cuestionario.nombre_en} {/if}
        </h2>

        {foreach from=$listado_cuestionarios item=cuestionario}

            <div class="programa-item">

                <a class="btn btn-white programa-header" role="button" data-toggle="collapse" href="#cuestionario-{$cuestionario.idcontenedorcapsula}" aria-expanded="false" aria-controls="cuestionario-{$cuestionario.idcontenedorcapsula}">
                    {if $TRADUCCION_DEFAULT=="fr"} {$cuestionario.titulo}{else} {$cuestionario.titulo_en} {/if}
                    <i class="fa fa-chevron-down pull-right"></i>
                </a>
            </div>
            <div class="collapse" id="cuestionario-{$cuestionario.idcontenedorcapsula}">
                <ul class="programas-categorias">
                    {foreach from=$cuestionario.listado_capsulas item=capsula}

                        <li style="list-style: none;">
                            <label class="checkbox">
                                <input type="checkbox"  name="cuestionario" value="{$capsula.idcapsula}-{$capsula.tipo_capsula}"  data-toggle="checkbox" class="custom-checkbox">
                                {$capsula.titulo}
                                {if $capsula.tipo_capsula=='1' }
                                    <img title="file" style="width: 18px;" class="tam-img-file pos-ico-img"  src="{$IMGS}icons/Icon-awesome-file-upload-red.png" />   
                                {else if $capsula.tipo_capsula=='2' }
                                    <img title="link" style="width: 20px;" class="tam-img-link pos-ico-img"  src="{$IMGS}icons/Icon-awesome-link-yellow.png" />  
                                {else if $capsula.tipo_capsula=='3' }
                                    <img title="video" style="width: 20px; top: 5px;" class="tam-img-video pos-ico-img" src="{$IMGS}icons/Icon-awesome-video-blue.png" />  
                                {else}
                                    <img title="ondemand" style="width: 20px;" class="tam-img-ondemand-video pos-ico-img"  src="{$IMGS}icons/Icon-material-ondemand-video-green.png" /> 
                                {/if}

                            </label>

                        </li>
                    {/foreach}
                </ul>
            </div>
        {/foreach}
    </div>
    <div class="okm-row text-center" style="display: flex;">
        <div class="okm-row text-center" {if $familia_cuestionario.id_familia_cuestionarios == '1' } style="text-align: right;" {/if}>
            <div class="col-xs-12">
                <a href="javascript:;" class="btn btn-xs btn-default  btn-guardar" >{"Personalizar"|x_translate}</a>
            </div>
        </div>

        {if $familia_cuestionario.id_familia_cuestionarios == '1' }
            <div class="okm-row text-center" {if $familia_cuestionario.id_familia_cuestionarios == '1' } style="text-align: left;" {/if}>
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
                var porciones = id.split('-');
                if (cantseleccionado == '1') {
                    if (id != null) {

                        window.location.href = BASE_PATH + "entreprises/ajouter/" + porciones[0] + ".html?banderaCapsula=" + porciones[1];
                    } else {
                        x_alert(x_translate("Debe seleccionar un cuestionario"));
                    }
                } else {
                    x_alert(x_translate("Solo debe seleccionar un cuestionario para personalizar"));
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