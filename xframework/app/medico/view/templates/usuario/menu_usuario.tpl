{literal}
    <style>
        .span_alert{    
            z-index:10;
            position: relative;
            width: 28px;
            height: 28px;
            border-radius: 50%;
            background: #cd3845;
            border: 2px solid #4b535e;
            font-weight: 700;
            text-align: center;
            color: #fff;
            font-size: 16px;
            left: 24px;
            top: -95px;
            line-height: 22px;
        }
    </style>
{/literal}
<section class="dc-header">

    <div class="dc-header-box">
        <div class="okm-container">
            <h1>{"Perfil Profesional y Comercial"|x_translate}</h1>
        </div>
    </div>
    <div class="dc-main-menu-box">
        <div class="okm-container">
            <div class="okm-row dc-main-menu-row">
                <div class="dc-main-menu-col">
                    <a href="{$url}panel-medico/perfil-profesional/" class="{if $sm=='datos_info_profesional'} active{/if}">
                        <figure class="dc-main-menu-icon" id="info_profesional">
                            <i class="icon-doctorplus-ficha-tecnica"></i>
                            {if $info_medico.medico.pais_idpais=="1" }

                                <!--Requerimientos info profesional-->
                                {if $info_medico.medico.mis_especialidades.0.tipo_identificacion == "1" && $info_medico.medico.numero_adeli==""}
                                    <!-- Numero ADELI Requerido-->
                                    {assign "info_profesional_req" true}
                                    {assign "info_profesional_motivo" "adeli"}
                                {/if}

                                {if $info_medico.medico.mis_especialidades.0.tipo_identificacion == "0" && $info_medico.medico.numero_rpps==""}
                                    <!-- Numero RPPS Requerido-->
                                    {assign "info_profesional_req" true}
                                    {assign "info_profesional_motivo" "rpps"}
                                {/if}

                                {if $info_medico.medico.mis_especialidades.0.requiere_numero_am == "1" && $info_medico.medico.numero_am==""}
                                    <!-- Numero AM Requerido-->
                                    {assign "info_profesional_req" true}
                                    {assign "info_profesional_motivo" "am"}
                                {/if}


                                {if $info_medico.medico.mis_especialidades.0.requiere_sector == "1" && $info_medico.medico.sector_idsector==""}
                                    <!-- Sector Requerido-->
                                    {assign "info_profesional_req" true}
                                    {assign "info_profesional_motivo" "sector"}
                                {/if}

                                {if $info_medico.medico.mis_especialidades.0.requiere_modo_facturacion == "1" && $info_medico.medico.facturacion_teleconsulta==""}
                                    <!-- Modo facturacion Requerido-->
                                    {assign "info_profesional_req" true}
                                    {assign "info_profesional_motivo" "facturacion_teleconsulta"}
                                {/if}

                                {if $info_profesional_req}
                                    <p class="span_alert" data-motivo="{$info_profesional_motivo}">!</p>
                                {/if}

                            {/if}

                        </figure>

                        <span>{"Información"|x_translate}<br>
                            {"profesional"|x_translate}</span>
                        <figure class="dc-main-menu-number">
                            <span >{if $info_medico}{$info_medico.porcentaje_info_personal}{else}0{/if}%</span>
                        </figure>
                    </a>
                </div>
                <div class="dc-main-menu-col">
                    <a href="{$url}panel-medico/perfil-profesional/consultorios/" class="{if $sm=='datos_consultorios'} active{/if}">
                        <figure class="dc-main-menu-icon">
                            <i class="icon-doctorplus-map-plus-rounded"></i>
                            {if $info_medico.consultorio_virtual.idconsultorio=="" || $info_medico.medico.direccion_iddireccion=="" || $info_medico.medico.preferencia.valorPinesConsultaExpress=="" || $info_medico.medico.preferencia.valorPinesVideoConsultaTurno==""  || $info_medico.medico.preferencia.valorPinesVideoConsulta==""}
                                <p class="span_alert">!</p>
                            {/if}
                        </figure>

                        <span>{"Consultorios, tarifas y"|x_translate}<br>	
                            {"coberturas médicas"|x_translate}</span>
                        <figure class="dc-main-menu-number">
                            <span id="cant_consultorios">{if $info_medico}{$info_medico.cantidad_consultorios}{else}0{/if}</span>
                        </figure>
                    </a>
                </div>
                <div class="dc-main-menu-col">
                    <a href="{$url}panel-medico/perfil-profesional/datos-comerciales/" class="{if $sm=='datos_comerciales'} active{/if}">
                        <figure class="dc-main-menu-icon">
                            <i class="fa fa-bank"></i>
                        </figure>
                        <span>{"Datos comerciales"|x_translate}</span>
                        <figure class="dc-main-menu-number">
                            <span>{if $info_medico}{$info_medico.porcentaje_info_comercial}{else}0{/if}%</span>
                        </figure>
                    </a>
                </div>
            </div>
        </div>
    </div>

</section>