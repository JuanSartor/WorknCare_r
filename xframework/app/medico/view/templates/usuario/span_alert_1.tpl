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
            <h1>ssss</h1>
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
                            
                                {if $medico_especialidad.0.idespecialidad == 60 || $medico_especialidad.0.idespecialidad == 61}
                                    {if $info_medico.medico.numero_adeli==""}
                                    <p class="span_alert">-</p>
                                    {/if}
                                {else}
                                    {if $info_medico.medico.numero_am=="" || $info_medico.medico.sector_idsector=="" || $info_medico.medico.facturacion_teleconsulta==""}
                                    <p class="span_alert">+</p>
                                    {/if}
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
                            {if $info_medico.consultorio_virtual.idconsultorio=="" || $info_medico.medico.preferencia.valorPinesVideoConsultaTurno==""}
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
                            <i class="icon-doctorplus-pc-add"></i>
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