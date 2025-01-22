<style>
    @media (min-width:600px){
        .pbr-img-back{
            min-height: 370px;
        }
    }
</style>
<div id="busqueda_profesional">

    <section class="pbr-background">

        <form name="f_busqueda_profesionales" id="f_busqueda_profesionales" action="{$url}panel-medico/busqueda-profesional/resultado/" method="POST" role="form">

            <div class="container pbr-container pbr-img-back pbr-container">
                <div class="pbr-holder">
                    <div class="pbr-form-holder">
                        <div class="okm-row">
                            <div class="pbr-buscador-title">
                                <h1>{"Buscador de profesionales"|x_translate}
                                    <a href="#" class="rsp-buscador-faq pbr-instrucciones-trigger">
                                        <i class="icon-doctorplus-info"></i>
                                    </a>
                                </h1>
                            </div>
                            <div class="pbr-buscador-faq">
                                <a href="#" class="pbr-instrucciones-trigger">{"¿Cómo funciona?"|x_translate}</a>
                            </div>
                        </div>

                        <div class="okm-row">

                            <div class="pbr-form-col-left opacity-col">
                                <div class="pbr-form-item pbr-select">
                                    <select name="especialidad_ti" id="especialidad_ti" class="form-control select select-primary select-block">
                                        <option value="">{"Especialidad"|x_translate}</option>
                                        {html_options options=$combo_especialidades }
                                    </select>
                                </div>
                            </div>

                        </div>
                        <div class="okm-row">
                            <div class="pbr-form-col-left opacity-col">
                                <div class="pbr-form-item okm-input-icon">
                                    <input type=text name="medico_ti" id="medico_ti" placeholder='{"Busca por nombre"|x_translate}'/>
                                    <i class="icon-doctorplus-search"></i>
                                </div>
                            </div>
                            <div class="pbr-form-col-right opacity-col pbr-advanced-search-row">
                                <div class="pbr-form-item">
                                    <input type="submit" id="btn_buscar_1" value='{"Buscar"|x_translate}'>
                                    {* <a id="pbr-btn-advanced-search" href="#">{"Búsqueda avanzada"|x_translate}</a>*}
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            {*
            <div id="pbr-advanced-search" class="container pbr-container pbr-advanced-search">
            <div class="pbr-advanced-search-holder">
            <div class="okm-row">
            <div class="pbr-form-col-left">
            <label class="pbr-label-small">{"Servicios que ofrece"|x_translate}</label>
            <div class="pbr-form-item-small pbr-select">
            <select name="servicio_ofrece_ti" class="form-control select select-primary select-block">
            <option value="">{"Todos"|x_translate}</option>
            {html_options options=$servicios_medicos }
            </select>
            </div>
            <div class="pbr-form-item pbr-select">

            </div>
            </div>
            <div class="pbr-form-col-right">

            </div>
            </div>
            <div class="okm-row">
            <div class="pbr-form-col-left">
            <label class="pbr-label-small">{"Ubicación"|x_translate}</label>
            <div class="pbr-form-item-small pbr-select">
            <select name="pais_ti" id="pais_ti" class="form-control select select-primary select-block">
            <option value="">{"País"|x_translate}</option>
            {html_options options=$combo_pais selected=$record.pais_idpais}
            </select>
            </div>
            </div>
            <div class="pbr-form-col-right">
            <input type="hidden" name="localidad_ti" id="localidad_ti"/>
            <div class="pbr-form-item okm-input-icon">
            <input type="text"  id="as_localidad" name="as_localidad" value="{$record.localidad}" placeholder='{"Buscar Ciudad"|x_translate}'>
            <i class="icon-doctorplus-search"></i>
            </div>
            </div>
            </div>




            <div class="pbr-horizontal-divider"></div>
            <div class="okm-row pbr-row-whith-vertical-divider">
            <div class="pbr-form-col-left pbr-vertical-divider">

            <div class="ce-nc-valoracion pbr-horarios">
            <label>{"Horario de atención"|x_translate}</label>
            <ul>
            <li>
            <label class="checkbox">
            <input type="checkbox" data-toggle="checkbox" name="maniana_ti" value="1">
            {"de Mañana"|x_translate}
            </label>
            </li>
            <li>
            <label class="checkbox">
            <input type="checkbox" data-toggle="checkbox" name="tarde_ti" value="1">
            {"de Tarde"|x_translate}
            </label>
            </li>
            <li>
            <label class="checkbox">
            <input type="checkbox" data-toggle="checkbox" name="sabado_ti" value="1">
            {"Sábados"|x_translate}
            </label>
            </li>
            </ul>
            </div>

            </div>
            <div class="pbr-form-col-right">

            <div class="ce-nc-valoracion pbr-valoracion">
            <label>{"Valoración"|x_translate}</label>
            <ul>
            <li>
            <label class="checkbox">
            <input type="checkbox" data-toggle="checkbox" name="valoracion_5_ti" value="1">
            <i class="icon-doctorplus-star"></i>
            <i class="icon-doctorplus-star"></i>
            <i class="icon-doctorplus-star"></i>
            <i class="icon-doctorplus-star"></i>
            <i class="icon-doctorplus-star"></i>
            </label>
            </li>
            <li>
            <label class="checkbox">
            <input type="checkbox" data-toggle="checkbox" name="valoracion_4_ti" value="1">
            <i class="icon-doctorplus-star"></i>
            <i class="icon-doctorplus-star"></i>
            <i class="icon-doctorplus-star"></i>
            <i class="icon-doctorplus-star"></i>
            </label>
            </li>
            <li>
            <label class="checkbox">
            <input type="checkbox" data-toggle="checkbox" name="valoracion_3_ti" value="1">
            <i class="icon-doctorplus-star"></i>
            <i class="icon-doctorplus-star"></i>
            <i class="icon-doctorplus-star"></i>
            </label>
            </li>
            <li>
            <label class="checkbox">
            <input type="checkbox" data-toggle="checkbox" name="valoracion_2_ti" value="1">
            <i class="icon-doctorplus-star"></i>
            <i class="icon-doctorplus-star"></i>
            </label>
            </li>
            <li>
            <label class="checkbox">
            <input type="checkbox" data-toggle="checkbox" name="valoracion_1_ti" value="1">
            <i class="icon-doctorplus-star"></i>
            </label>
            </li>
            </ul>
            </div>

            </div>
            </div>
            <div class="pbr-horizontal-divider"></div>
            <div class="okm-row">
            <div class="pbr-advanced-search-actions">
            <button id="pbr-cancel-advanced-search" class="btn-light-sqare pbr-btn-cancelar">{"Cancelar"|x_translate}</button>
            <button  id="btn_buscar_2"  class="btn-alert-square pbr-btn-aceptar">{"Buscar"|x_translate}</button>
            </div>
            </div>
            </div>
            </div>	
            *}
        </form>
    </section>


    <section class="banner-gestion-cobros">
        <div class="okm-container">
            <div class="okm-row">
                <div class="banner-gestion-cobros-img-holder">
                    <div class="banner-gestion-cobros-card">
                        <figure>
                            <i class="icon-doctorplus-chat"></i>
                        </figure>
                        <div class="banner-gestion-cobros-content">
                            <div class="banner-gestion-cobros-shadow">
                                <div class="banner-gestion-cobros-inner">
                                    <h3>{"¡Aumente su capacidad productiva!"|x_translate}</h3>
                                    <p>{"Controle y capitalice las consultas de sus pacientes fuera de su consultorio a través del servicio de Consulta Express."|x_translate}</p>
                                </div>
                            </div>

                            <div class="banner-gestion-cobros-footer">
                                <p>{"Ud. Atienda la consulta."|x_translate} <br>
                                    {"DoctorPlus se encarga de gestionar su cobro."|x_translate}</p>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </section>


    {x_load_js}

</div>