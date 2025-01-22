
{if $listado_vacaciones}
    <section class="okm-container">
        <div class="table-detail">
            <div class="col-xs-12" style="margin:40px 0;" >

                <div class="table table-responsive tabla-facturas">
                    <table class="table">

                        <tr>  
                            <th width="10%">&nbsp;</th>
                            <th width="45%">{"Fecha de inicio"|x_translate}</th>
                            <th width="45%">{"Fecha de fin"|x_translate}</th>
                        </tr>
                        {foreach from=$listado_vacaciones item=vacacion}

                            <td align="center">
                                <button  data-id="{$vacacion.idmedico_vacaciones}" class=" btn btn-xs btn-alert btn-eliminar-vacaciones">
                                    <i class="fa fa-trash-o"></i> 
                                    {"eliminar"|x_translate}
                                </button>
                            </td>

                            <td>{$vacacion.desde|date_format:"%d/%m/%Y"}</td>
                            <td>{$vacacion.hasta|date_format:"%d/%m/%Y"}</td>                             

                            </tr>
                        {/foreach}

                    </table>
                </div>

            </div>
        </div>

        <div class="clearfix">
            &nbsp;
        </div>
    </section>
{/if}

{literal}
    <script>
        $(function () {
            //Eliminar vacaciones
            $(".btn-eliminar-vacaciones").click(function () {
                $("body").spin("large");
                x_doAjaxCall(
                        'POST',
                        BASE_PATH + "medico.php?action=1&modulo=agenda&submodulo=eliminar_vacaciones",
                        "id=" + $(this).data("id"),
                        function (data) {

                            x_alert(data.msg);
                            if (data.result) {
                                //recargamos el modulo del listado

                                x_loadModule('agenda', 'vacaciones_list', '', 'vacaciones_list_container').then(function () {
                                    $("body").spin(false);
                                });

                            } else {
                                $("body").spin(false);
                            }
                        }
                );
            });

        });
    </script>
{/literal}
