<div class="modal modal-info-beneficiarios cantidad-empleados" tabindex="-1" role="dialog" data-keyboard="false" data-backdrop="static" aria-hidden="false"  id="modal-info-beneficiarios">
    <div class="modal-dialog container" role="document">
        <div class="modal-content  ">

            <div class="modal-body">
                <button type="button" class="dp-dismiss custom close" data-dismiss="modal" aria-label="Close"></button>
                <div class="okm-row">
                    <div class="vc-interrumpidas-header">	
                        <i class="icon-doctorplus-alert-round"></i>
                    </div>
                    <h3 class="text-center">{"Ayúdenos a conocer su empresa o establecimiento"|x_translate}</h3>
                    <p></p>


                    <form  id="cant_empleados_form" action="{$url}empresa.php?action=1&modulo=home&submodulo=cantidad_empleados_form" method="post" onsubmit="return false;">
                        <div class="col-xs-12">
                            <div class="form-group">
                                <label for="blood-type">{"¿Cuántos empleados tiene?"|x_translate}</label>
                                <div class="input-group">
                                    <input class="form-control pull-right" type="number" name="cant_empleados" id="cant_empleados" placeholder="Ex: 25" value="{$empresa.cant_empleados}"> 
                                </div>
                            </div>
                        </div>
                        <div class="col-xs-12">
                            <div class="form-group">
                                <label for="blood-type">{"¿Cuál es su presupueto mensual para beneficiarios?"|x_translate}</label>
                                <div class="input-group">
                                    <input class="form-control pull-right" type="number" name="presupuesto_maximo" id="presupuesto_maximo" placeholder="Ex: &euro;160" value="{$empresa.presupuesto_maximo}"> 
                                </div>
                            </div>
                        </div>
                        <div class="okm-row">
                            <div class="col-xs-12 text-center">
                                <button id="btnRegistrarPreferencias" class="btn btn-default" type="button">{"guardar"|x_translate}</button>
                            </div>
                        </div>
                        <div class="clearfix">&nbsp;</div>
                    </form>
                </div>
            </div>

        </div>
    </div>
</div>
{if ($usuario_empresa.cant_empleados=="" || $usuario_empresa.presupuesto_maximo=="") && $empresa.plan_idplan!=21 && $empresa.plan_idplan!=22}
    {literal}
        <script>
            $(function () {
                $("#modal-info-beneficiarios").modal("show");
            });
        </script>
    {/literal}
{/if}

{literal}
    <script>

        $(function () {
            //metodo que guarda la cantidad de empelados
            $("#btnRegistrarPreferencias").click(function () {
                $("body").spin("large");
                x_sendForm(
                        $('#cant_empleados_form'),
                        true,
                        function (data) {
                            $("body").spin(false);
                            x_alert(data.msg);
                            if (data.result) {
                                $("#modal-info-beneficiarios").modal("hide");
                                x_loadModule('home', 'home_cards', '', 'div_home_cards_container');
                                $("#div_listado_beneficiarios").hide();
                                $("#cards-home").fadeIn();
                            }

                        });

            });
        });

    </script>
{/literal}