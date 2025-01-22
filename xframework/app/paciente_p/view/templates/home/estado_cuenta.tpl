<div >
    <section class="okm-container ce-nc-consulta-precios">
        <div class="row">
            <h2>{"Estado de cuenta"|x_translate}</h2>
        </div>
        <div class="okm-row">
            <div class="col-xs-12">
                <div class="row">
                    {if $paciente_empresa && $empresa.cancelar_suscripcion!="2"}
                        <div class="col-md-3 col-sm-6">
                            <div class="ce-nc-consulta-precios-holder paciente-empresa">
                                <figure class="saldo">
                                    <i class="icon-doctorplus-chat"></i>
                                </figure>
                                <h4>{"CONSULTAS POR CHAT DISPONIBLES"|x_translate}</h4>
                                <span>
                                    {math equation='cant_ce_plan - cant_ce_realizadas' cant_ce_plan=$plan_contratado.cant_consultaexpress cant_ce_realizadas=$paciente_empresa.cant_consultaexpress assign='cant_ce_disponibles'}
                                    {$cant_ce_disponibles}
                                </span>
                            </div>
                        </div>
                        <div class="col-md-3 col-sm-6">
                            <div class="ce-nc-consulta-precios-holder paciente-empresa">
                                <figure class="saldo">
                                    <i class="icon-doctorplus-video-cam"></i>
                                </figure>
                                <h4>{"CONSULTAS POR VIDEO DISPONIBLES"|x_translate}</h4>
                                <span>
                                    {math equation='cant_vc_plan - cant_vc_realizadas' cant_vc_plan=$plan_contratado.cant_videoconsulta cant_vc_realizadas=$paciente_empresa.cant_videoconsulta assign='cant_vc_disponibles'}
                                    {$cant_vc_disponibles}
                                </span>
                            </div>
                        </div>
                    {/if}
                    {*mostramos solo el saldo a los que quedaron con saldo pendiente*}
                    {if $cuenta_usuario.saldo>0}
                        <div class="{if $paciente_empresa}col-md-3 col-sm-6{else}col-xs-6{/if}">
                            <div class="ce-nc-consulta-precios-holder {if $paciente_empresa}paciente-empresa{/if}">
                                <figure class="saldo">
                                    <i class="icon-doctorplus-dollar"></i>
                                </figure>
                                <h4>{"SALDO DISPONIBLE"|x_translate}</h4>
                                <span>
                                    <small>&euro;</small> 
                                    {if $cuenta_usuario}
                                        {$cuenta_usuario.saldo}
                                    {else}
                                        0
                                    {/if}

                                </span>
                                <p class="red">*{"Su saldo disponible será reembolsado en su tarjeta próximamente"|x_translate}</p>
                            </div>
                        </div>
                    {/if}
                    {*No utilizamos mas la carga de credtito Abr 2021*}
                    {*   
                    <div class="{if $paciente_empresa}col-md-3 col-sm-6{else}col-xs-6{/if}">
                    <div class="ce-nc-consulta-precios-holder {if $paciente_empresa}paciente-empresa{/if}">
                    <a href="{$url}panel-paciente/credito-proceso-compra/">
                    <figure>
                    <i class="icon-doctorplus-dollar-add"></i>
                    </figure>
                    <h4>{"CARGAR CREDITO"|x_translate}</h4>
                    <span class="fecha-carga">
                    {if $ultima_carga}
                    {"Ultima carga:"|x_translate} {$ultima_carga.fecha|date_format:"%d/%m/%Y"}
                    {else}
                    {"No se registran cargas de crédito"|x_translate}
                    {/if}
                    </span>
                    </a>
                    </div>
                    </div>
                    *}
                </div>
            </div>
        </div>
        <div class="row" > 
            <div class="col-xs-12">
                {*
                <div class="ce-nc-consulta-precios-tabla-titulo">
                <h4>{"Más información"|x_translate}
                
                </h4>
                </div>
                *}
                <div id="div_listado_movimiento_cuenta"></div>
            </div>
        </div>
    </section>

    {if $smarty.request.mod == "1"}
        <script>
            $(document).ready(function () {

                $('.ce-nc-consulta-precios').hide();
            });


        </script>
    {/if}
    {literal}
        <script>
            $(document).ready(function () {
                $("body").spin();
                x_loadModule('home', 'estado_cuenta_listado_movimientos', 'do_reset=1&hide_table=1', 'div_listado_movimiento_cuenta', BASE_PATH + "paciente_p").then(function () {
                    $("body").spin(false);
                });
            });

        </script>
    {/literal}

</div>