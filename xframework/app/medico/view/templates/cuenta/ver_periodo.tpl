<style>
    .ce-ca-top .section-name>i {
        font-size: 32px;
    }
    @media (max-width: 480px){
        .section-header .section-name {
            font-size: 24px;
        }
    }

</style>
<input type="hidden" id="idperiodoPago" value="{$idperiodoPago}"/>
<input type="hidden" id="idPeriodoActual" value="{$idPeriodoActual}"/>

<nav class="section-header ce-ca-top profile">
    <div class="container">
        <div class="okm-row">
            <div class="user-select pull-left user-select-sonsulta-express-rsp">
                <h1 class="section-name">
                    <i class="icon-doctorplus-dollar-sheet"></i>{"Mi Cuenta"|x_translate}
                </h1>
            </div>
            <div class="top-nav-icons-select-combo">
                <div class="okm-row">
                    <div class="top-nav-right-icon-box">
                        <a href="javascript:;"  id="p_periodos" style="display:none;" ><i class="icon-doctorplus-dollar-sheet"></i> {"Períodos"|x_translate}</a>
                        <a href="javascript:;" id="p_pagos" ><i class="icon-doctorplus-dollar-db"></i> {"Pagos"|x_translate}</a>
                    </div>

                    <div class="consulta-express-pull-right">
                        <div class="dropdown dropdown-express medico-dropdown-express">

                            <select id="select_periodo"class="form-control select select-primary select-block mbl ce-nc-p2-res-list-select" style="width:100%">
                                {if $combo_periodo_pago}
                                    {html_options options=$combo_periodo_pago selected=$id_periodo}
                                {else}
                                    <option value="">{"No hay períodos"|x_translate}</option>
                                {/if}
                            </select>

                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</nav>


<div id="cont_periodo"></div>



<hr />

{x_load_js}