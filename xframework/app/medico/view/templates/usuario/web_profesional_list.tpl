
{if $listado_web_profesional}
    <section class="okm-container">

        <div class="okm-row" >


            {foreach from=$listado_web_profesional item=web}
                <div class="web-profesional-item-container">
                    <button  data-id="{$web.idmedico_web_profesional}" class="btn-transparent btn_eliminar_web_profesional" title='{"eliminar"|x_translate}'>
                        <i class="fa fa-trash-o"></i> 
                    </button>
                    <a href="{$web.url_web}" target="_blank">
                        <figure class="tipo_web">
                            {if $web.tipo_web=="web"}
                                <i class="fa fa-link"></i>
                            {else if $web.tipo_web=="linkedin"}
                                <i class="fa fa-linkedin"></i>
                            {else if $web.tipo_web=="youtube"}
                                <i class="fa fa-youtube"></i>
                            {else if $web.tipo_web=="facebook"}
                                <i class="fa fa-facebook"></i>
                            {else if $web.tipo_web=="instagram"}
                                <i class="fa fa-instagram"></i>
                            {else}
                                <i class="fa fa-link"></i>
                            {/if}
                        </figure>
                        <span class="url_web">
                            {$web.url_web|replace:'https://':''}
                        </span>
                    </a>
                </div>

            {/foreach}

        </div>

    </section>
{/if}

{literal}
    <script>
        $(function () {
            //Eliminar web_profesional
            $(".btn_eliminar_web_profesional").click(function () {
                $("body").spin("large");
                x_doAjaxCall(
                        'POST',
                        BASE_PATH + "medico.php?action=1&modulo=usuario&submodulo=eliminar_web_profesional",
                        "id=" + $(this).data("id"),
                        function (data) {
                            if (data.result) {
                                //recargamos el modulo del listado
                                x_loadModule('usuario', 'web_profesional_list', '', 'web_profesional_list_container').then(function () {
                                    $("body").spin(false);
                                    x_alert(data.msg);
                                });
                            } else {

                                $("body").spin(false);
                                x_alert(data.msg);
                            }
                        }
                );
            });

        });
    </script>
{/literal}
