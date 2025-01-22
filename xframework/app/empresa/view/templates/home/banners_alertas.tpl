{if $account.user.tipo_usuario|in_array:['1','3'] } 
    {if $info_beneficiarios.beneficiarios_inscriptos != $info_beneficiarios.beneficiarios_verificados}
        <div class="okm-row">
            <div class="alert-wrapper">
                <div class="col-md-8 col-sm-12" >
                    <div class="grand-alert beneficiarios">
                        <div class="ag-bell">
                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 47.5 56.44">
                                <g>
                                    <g>
                                        <path d="M23.75,56.44a7.81,7.81,0,0,0,7.82-7.77H15.91a7.83,7.83,0,0,0,7.84,7.77Z" class="svg-bell svg-bell_clapper"></path>
                                        <path d="M41.9,38.72V23.52a17.83,17.83,0,0,0-14-17.43V4.15a4.19,4.19,0,0,0-8.38,0V6.09a17.84,17.84,0,0,0-14,17.43v15.2L0,44.26V47H47.5V44.26Z" class="svg-bell svg-bell_whole"></path>
                                    </g>
                                </g>
                            </svg>
                        </div>
                        <label>
                            {"Le recomendamos verificar a todos los beneficiarios."|x_translate}
                        </label>
                        <a href="{$url}entreprises/beneficiaires.html" class="btn-xs btn-white">{"validar"|x_translate}</a>

                    </div>
                </div>
            </div>
        </div>
    {/if}
{/if}
{if $cupon}
    {if $account.user.tipo_usuario|in_array:['1'] } 
        <div class="okm-row" id="banner-cupones-container" style="display:none;">
            <div class="alert-wrapper">
                <div class=" col-md-8 col-sm-12" >
                    <div class="grand-alert cupones">
                        <div class="">
                            <i class="fa fa-tag" style="transform:rotate(90deg)"></i>
                        </div>
                        <label>
                            {"Usted se beneficia de un descuento de"|x_translate}&nbsp;{$cupon.porcentaje_descuento}%
                        </label>
                        <button id="close-banner-cupon" class="close-banner"><i class="fa fa-times"></i></button>
                    </div>
                </div>
            </div>
        </div>
    {/if}
{/if}


<!-- este banner es para avisar que tiene pendiene la transferencia del cambio de plan,
 que indica que no la envio o que todavia no fue aprobada por el admin -->
{if $empresa.contratacion_manual == '1' && $plansusempresa.pack_pago_pendiente =='1'}
    <div class="okm-row" style="margin-top: 10px; margin-bottom: 10px;">
        <div class="alert-wrapper">
            <div class="col-md-8 col-sm-12" >
                <a href="{$url}entreprises/factures.html" class="a-trans-pend">
                    <div class="grand-alert beneficiarios">
                        <div class="ag-bell">
                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 47.5 56.44">
                                <g>
                                    <g>
                                        <path d="M23.75,56.44a7.81,7.81,0,0,0,7.82-7.77H15.91a7.83,7.83,0,0,0,7.84,7.77Z" class="svg-bell svg-bell_clapper"></path>
                                        <path d="M41.9,38.72V23.52a17.83,17.83,0,0,0-14-17.43V4.15a4.19,4.19,0,0,0-8.38,0V6.09a17.84,17.84,0,0,0-14,17.43v15.2L0,44.26V47H47.5V44.26Z" class="svg-bell svg-bell_whole"></path>
                                    </g>
                                </g>
                            </svg>
                        </div>
                        <div style="width: 100%; font-size: 22px; line-height: 36px; margin: 0 20px; font-weight: normal;">

                            {"Su transferencia por cambio de plan se encuentra pendiente."|x_translate}

                        </div>
                    </div>
                </a>
            </div>
        </div>
    </div>
{/if}

<!-- este banner es para indicar que tiene pendiene una transferencia 
o confirmacion de pago desde dpadmin de un cuestionario -->
{if $account.user.tipo_usuario|in_array:['1','5'] } 
    {if $pagoRecom.pago_pendiente == '2'}
        <div class="okm-row">
            <div class="alert-wrapper">
                <div class="col-md-8 col-sm-12" >
                    <a href="{$url}entreprises/factures.html" class="a-trans-pend">
                        <div class="grand-alert beneficiarios">
                            <div class="ag-bell">
                                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 47.5 56.44">
                                    <g>
                                        <g>
                                            <path d="M23.75,56.44a7.81,7.81,0,0,0,7.82-7.77H15.91a7.83,7.83,0,0,0,7.84,7.77Z" class="svg-bell svg-bell_clapper"></path>
                                            <path d="M41.9,38.72V23.52a17.83,17.83,0,0,0-14-17.43V4.15a4.19,4.19,0,0,0-8.38,0V6.09a17.84,17.84,0,0,0-14,17.43v15.2L0,44.26V47H47.5V44.26Z" class="svg-bell svg-bell_whole"></path>
                                        </g>
                                    </g>
                                </svg>
                            </div>
                            <div style="width: 100%; font-size: 22px; line-height: 36px; margin: 0 20px; font-weight: normal;">
                                {"Su transferencia por el cuestionario se encuentra pendiente."|x_translate}
                            </div>
                        </div>
                    </a>  
                </div>
            </div>
        </div>
    {/if}
{/if}

<!-- alerta por falta de pago de recompra pack por transferencia -->
{if $account.user.tipo_usuario|in_array:['1','5'] } 
    {if $tranPackPend.cantidad > '0'}
        <div class="okm-row">
            <div class="alert-wrapper">
                <div class="col-md-8 col-sm-12" >
                    <a href="{$url}entreprises/factures.html" class="a-trans-pend">
                        <div class="grand-alert beneficiarios">
                            <div class="ag-bell">
                                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 47.5 56.44">
                                    <g>
                                        <g>
                                            <path d="M23.75,56.44a7.81,7.81,0,0,0,7.82-7.77H15.91a7.83,7.83,0,0,0,7.84,7.77Z" class="svg-bell svg-bell_clapper"></path>
                                            <path d="M41.9,38.72V23.52a17.83,17.83,0,0,0-14-17.43V4.15a4.19,4.19,0,0,0-8.38,0V6.09a17.84,17.84,0,0,0-14,17.43v15.2L0,44.26V47H47.5V44.26Z" class="svg-bell svg-bell_whole"></path>
                                        </g>
                                    </g>
                                </svg>
                            </div>
                            <div style="width: 100%; font-size: 22px; line-height: 36px; margin: 0 20px; font-weight: normal;">

                                {"Su transferencia por recompra de Packs esta pendiente."|x_translate}

                            </div>
                        </div>
                    </a>
                </div>
            </div>
        </div>
    {/if}
{/if}

{literal}
    <script>
        $(function () {
            if (localStorage.getItem('banner-cupones-container-hide') !== '1') {
                $("#banner-cupones-container").slideDown();
            }
            $("#close-banner-cupon").click(function (e) {
                console.log("close banner");
                e.preventDefault();
                e.stopPropagation();
                $("#banner-cupones-container").slideUp();
                localStorage.setItem('banner-cupones-container-hide', '1');
            });

            $(".grand-alert.cupones").click(function (e) {
                console.log("open modal");
                e.preventDefault();
                e.stopPropagation();
                $("#modal-plan-contratado").modal("show");
            });
        });
    </script>
{/literal}