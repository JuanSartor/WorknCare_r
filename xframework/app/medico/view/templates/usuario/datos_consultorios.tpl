{literal}
    <style>
        #info-consultorios .dc-panels .span_alert{    
            z-index: 10;
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
            left: -15px;
            top: 35px;
            line-height: 22px;
        }

        @media (min-width: 600px){
            .dc-tarifas-label-col {
                width: 70%;
            }
            .dc-tarifas-val-col{
                width: 30%;
            }
        }

        .dc-accordion .panel-default{
            background-color: #fff;
        }

        .dc-accordion .panel-heading a:not(.collapsed){
            background-color: #f2f2f2;
        }
        .mul-mis-servicios-wraper{
            background-color: #ffffff;

        }
        .dc-accordion .dc-panel-4{
            margin-bottom: 0px !important;
        }
        .dc-tarifas-val-col input[type=number] {
            display: inline-block;
            width: 100%;
            max-width: 140px;
            float: right;
        }
    </style>
{/literal}
<input type="hidden" id="PRECIO_MINIMO_CE" value="{$PRECIO_MINIMO_CE}"/>
<input type="hidden" id="PRECIO_MINIMO_VC" value="{$PRECIO_MINIMO_VC}"/>
<input type="hidden" id="PRECIO_MINIMO_VC_TURNO" value="{$PRECIO_MINIMO_VC_TURNO}"/>
<input type="hidden" id="PRECIO_MAXIMO_VC" value="{$PRECIO_MAXIMO_VC}"/>
<input type="hidden" id="PRECIO_MAXIMO_CE" value="{$PRECIO_MAXIMO_CE}"/>
<input type="hidden" id="PRECIO_MAXIMO_VC_TURNO" value="{$PRECIO_MAXIMO_VC_TURNO}"/>

<div id="div_menu_usuario"></div>

<script>
    x_loadModule('usuario', 'menu_usuario', 'sm={$submodulo}', 'div_menu_usuario');
</script>	
<div id="info-consultorios" class="mul-form-type">

    <div class="dc-panels-box">
        <div class="dc-panels okm-container">
            <ul>
                <li><a href="javascript:;" class="consultorios-trg active" data-src="#consultorios">{if $consultorio_virtual.idconsultorio=="" || $medico.direccion_iddireccion=="" }<p class="span_alert">!</p>{/if} <i class="icon-doctorplus-map-plus-rounded"></i> {"Consultorios"|x_translate}<span></span></a></li>
                <li><a href="javascript:;" class="consultorios-trg" data-src="#tarifas"> {if $preferencia.valorPinesVideoConsultaTurno=="" || $preferencia.valorPinesVideoConsulta=="" || $preferencia.valorPinesConsultaExpress==""}<p class="span_alert">!</p>{/if}<i class="icon-doctorplus-dollar-circular"></i> {"Tarifas y servicios"|x_translate}<span></span></a></li>
                <li><a href="javascript:;" class="consultorios-trg" data-toggle="tooltip" {if $especialidad_medico.tipo==1} title="Plus d’information" {else} title="Section réservée aux médecins"  {/if} data-src="#cobertura"><i class="icon-doctorplus-pharmaceutics"></i> {"Coberturas Médicas"|x_translate}<span></span></a></li>
            </ul>
        </div>
    </div>
    <!-- Consultorios-->
    {*Consultorios*}
    <section class="form edit info-profesional-form dc-form-white consultorios-src" id="consultorios">

        <div class="container" id="div_datos_consultorios" >

            <div class="panel-group dc-accordion" id="accordion" role="tablist" aria-multiselectable="true">
                {*Direccion*}
                <div class="panel panel-default dc-panel-1">
                    <div class="panel-heading" role="tab" id="headingOne">
                        <a role="button" data-toggle="collapse"  {if $asignarhorario=='1'} class="collapsed" aria-expanded="false" {else} class="collapse" aria-expanded="true" {/if} data-parent="#accordion" href="#collapseOne" aria-controls="collapseOne">

                            <h2 class="text-center">
                                1. {"Agregue la dirección de su consultorio u hospital"|x_translate}
                                {if $direccion.iddireccion==""}<i class="fa fa-exclamation-circle red alert-req-field"></i>{/if}
                            </h2>
                        </a>
                    </div>
                    <div id="collapseOne" {if $asignarhorario=='1'} class="panel-collapse collapse" {else} class="panel-collapse collapse in" {/if} role="tabpanel" aria-labelledby="headingOne">
                        <!--Datos de direccion-->

                        {include file="usuario/direccion_consultorio.tpl"}
                    </div>
                </div>
                {*Consultorios*}
                <div class="panel panel-default dc-panel-2">
                    <div class="panel-heading" role="tab" id="headingTwo">
                        <a  {if $asignarhorario=='1'} class="collapse" aria-expanded="true" {else} class="collapsed" aria-expanded="false" {/if} role="button" data-toggle="collapse" data-parent="#accordion" href="#collapseTwo" aria-controls="collapseTwo">
                            <h2 class="text-center">
                                2. {"Definir consultorios"|x_translate}
                                {if $medico.agenda_consultorio==""}<i class="fa fa-exclamation-circle red alert-req-field"></i>{/if}
                            </h2>
                        </a>
                    </div>

                    <div id="collapseTwo" {if $asignarhorario=='1'} class="panel-collapse collapse in"  {else} class="panel-collapse collapse" {/if} role="tabpanel" aria-labelledby="headingTwo">
                        {if $medico.agenda_consultorio!="1"}
                            <div class="text-center okm-container" id="div_consulta_agenda_consultorio">
                                <div class="row input-row" style="padding-left:20px; padding-right:20px; ">
                                    <h2>{"¿Quiere usar una agenda asociada a su consultorio?"|x_translate}</h2>
                                </div>
                                <div class="row input-row ">

                                    <div class="check-holder si_no_consultorios" >
                                        <div class="col-md-offset-4 col-md-2 col-xs-6">
                                            <label for="agenda_consultorio_si" class="radio"><input  type="radio" name="agenda_consultorio" {if  $medico.agenda_consultorio=="1"}checked{/if} value="1" id="agenda_consultorio_si" > {"Si"|x_translate}</label>
                                        </div>
                                        <div class="col-md-2 col-xs-6">
                                            <label for="agenda_consultorio_no" class="radio"><input type="radio" name="agenda_consultorio" {if  $medico.agenda_consultorio=="0"}checked{/if} value="0" id="agenda_consultorio_no"  > {"No"|x_translate}</label>
                                        </div>
                                    </div>
                                </div>   
                                <div class="clearfix">&nbsp;</div>
                                <div class="okm-row">
                                    <div class="mapc-registro-form-row center">

                                        <a href="javascript:;" class="btn-default btn-siguiente-agenda-consultorio" data-step="1" >{"siguiente"|x_translate}</a>
                                    </div>
                                </div>
                                <div class="dc-disclaimer">
                                    <strong>{"No es obligatorio usar una agenda para realizar consultas a distancia."|x_translate}</strong>
                                    <p>{"Si decide no usar agenda, sus pacientes podran enviarle mensages o solicitudes de Video Consulta y usted podra gestionarlas mediante su sala de espera virtual."|x_translate}</p>
                                </div>
                            </div>
                        {/if}
                        <!--Iconos de consultorio-->

                        <div id="div_items_consultorios" class="okm-container"   {if $medico.agenda_consultorio!="1"}style="display:none"{/if}>
                            {include file="usuario/datos_consultorios_items.tpl"}
                        </div>
                        <div id="div_consultorio">

                        </div>
                    </div>
                </div>
            </div>
            {*banner consultorios*}
            <div class="dc-consultorio-banner">
                <div class="container">
                    <div class="row">
                        <div class="col-md-8 col-md-offset-2">
                            <div class="dc-consultorio-banner-holder">
                                <div class="dc-consultorio-banner-img">
                                    <img src="{$IMGS}medico/consultorios/consultorios.svg" alt='{"Consultorios"|x_translate}'/>
                                </div>
                                <div class="text">
                                    <span>{"Ud. podrá crear y configurar la agenda de:"|x_translate}</span>
                                    <ol type="1">
                                        <li><strong>{"Consultorio virtual"|x_translate}:</strong> {"para poder recibir solicitudes de Video Consulta. Puede agregar horarios que se dedicarán exclusivamente a la Video Consulta"|x_translate}</li>

                                        <li><strong>{"Consultorio presencial"|x_translate}:</strong> {"para hacer citas en la oficina a través de su agenda. ¡Debe agregar las horas de su consultorio para que sus pacientes puedan hacer una cita!"|x_translate}</li>
                                    </ol>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
    <!-- FIN Consultorios-->
    <!-- Tarifas y Servicios-->
    {*Tarifas y Servicios*}
    <section class="form edit info-profesional-form dc-form-white consultorios-src" id="tarifas">
        {*<div class="dc-tarifas-banner">
        <h4>{"¡Aumente su capacidad productiva!"|x_translate}</h4>
        <p>
        {"Controle y capitalice las consultas de sus pacientes <br> fuera de su consultorio a través del servicio de Consulta Express y Video Consulta."|x_translate}
        </p>
        <div class="okm-row cd-tarfifas-figure-box">
        <figure>
        <i class="icon-doctorplus-chat"></i>
        </figure>
        <figure>
        <i class="icon-doctorplus-video-call"></i>
        </figure>
        </div>
        <div class="dc-tarifas-disclaimer">
        <span>{"Usted atienda la consulta, DoctorPlus se encarga de gestionar su cobro."|x_translate}</span>
        </div>
        </div>*}
        <div class="panel-group dc-accordion" id="accordion-2" role="tablist" aria-multiselectable="true">
            <div class="panel panel-default dc-panel-4">
                <div class="panel-heading" role="tab" id="headingOne-a2">
                    <a role="button" data-toggle="collapse" data-parent="#accordion-2" href="#collapseOne-a2" aria-expanded="true" aria-controls="collapseOne">
                        <h2 class="text-center">
                            3. {"Definir tarifas"|x_translate}
                            {if $preferencia.valorPinesVideoConsultaTurno=="" || $preferencia.valorPinesVideoConsulta=="" || $preferencia.valorPinesConsultaExpress==""}
                                <i class="fa fa-exclamation-circle red alert-req-field"></i>
                            {/if}
                        </h2>
                    </a>
                </div>

                <div id="collapseOne-a2" class="panel-collapse collapse in" role="tabpanel" aria-labelledby="headingOne-a2">

                    <div class="container">

                        <form id="frm_aranceles" role="form" action="{$url}registrar_aranceles.do" method="post" onsubmit="return false">
                            <input type="hidden" name="idpreferencia" value="{$preferencia.idpreferencia}">

                            <div class="row">
                                <div class="col-md-8 col-md-offset-2">

                                    <div class="okm-row">
                                        <div class="dc-tarifas-label-col">
                                            <i class="icon-doctorplus-chat"></i>
                                            <span>{"Consulta Express"|x_translate}</span>
                                        </div>
                                        <div class="dc-tarifas-val-col">
                                            <span>&euro;</span>
                                            <input type="number" id="valorPinesConsultaExpress" name="valorPinesConsultaExpress" value="{$preferencia.valorPinesConsultaExpress}" placeholder='{"agregar"|x_translate}'>
                                        </div>
                                        <small class="dc-input-disclaimer tarifas">*{"Importe mínimo"|x_translate} &euro; {$PRECIO_MINIMO_CE}</small>
                                    </div>

                                    <div class="okm-row">
                                        <div class="dc-tarifas-label-col">
                                            <i class="icon-doctorplus-video-call"></i>
                                            <span>{"Video Consulta con turno"|x_translate}</span>
                                        </div>
                                        <div class="dc-tarifas-val-col">
                                            <span>&euro;</span>
                                            {if  $medico.pais_idpais==1 && $especialidad_medico.tipo==1 && $medico.sector_idsector==1}
                                                <input type="number" id="valorPinesVideoConsultaTurno" name="valorPinesVideoConsultaTurno"   placeholder="{$especialidad_medico.max_vc_turno}" value="{$especialidad_medico.max_vc_turno}">
                                            {else}
                                                <input type="number" id="valorPinesVideoConsultaTurno" name="valorPinesVideoConsultaTurno"   placeholder='{"agregar"|x_translate}' value="{$preferencia.valorPinesVideoConsultaTurno}"  >                                         
                                            {/if}
                                        </div>
                                        {if  $medico.pais_idpais==1 && $especialidad_medico.tipo==1 && $medico.sector_idsector==1}
                                            <small class="dc-input-disclaimer tarifas">*{"Importe mínimo"|x_translate} &euro; {$especialidad_medico.max_vc_turno} </small>
                                        {else}
                                            <small class="dc-input-disclaimer tarifas">*{"Importe mínimo"|x_translate} &euro; {$PRECIO_MINIMO_VC_TURNO} </small>
                                        {/if}
                                    </div>

                                    {if  !($medico.pais_idpais==1 && $medico.sector_idsector==1)}

                                        <div class="okm-row">
                                            <div class="dc-tarifas-label-col">
                                                <i class="icon-doctorplus-video-call"></i>
                                                <span>{"Video Consulta sin turno"|x_translate}</span>
                                            </div>
                                            <div class="dc-tarifas-val-col">
                                                <span>&euro;</span>
                                                <input type="number" id="valorPinesVideoConsulta" name="valorPinesVideoConsulta" value="{$preferencia.valorPinesVideoConsulta}" placeholder='{"agregar"|x_translate}'>
                                            </div>
                                            <small class="dc-input-disclaimer tarifas">*{"Importe mínimo"|x_translate} &euro; {$PRECIO_MINIMO_VC} </small>
                                        </div>
                                    {/if}
                                    {* <div class="okm-row">
                                    <div class="dc-tarifas-label-col">
                                    <i class="icon-doctorplus-estetoscopio"></i>
                                    <span>{"Consulta presencial"|x_translate}
                                    <small>{"Dato no obligatorio"|x_translate}</small></span>
                                    </div>
                                    <div class="dc-tarifas-val-col">
                                    <span>&euro;</span>
                                    <input type="number" id="valorConsultaPresencial" name="valorConsultaPresencial" value="{$preferencia.valorConsultaPresencial}">
                                    </div>
                                    </div>*}



                                </div>

                            </div>
                        </form>
                        <div class="row">
                            <div class="dc-horarios-add-action-box">
                                <a href="javascript:;" id="guardarAranceles" class="btn-oil-large">{"guardar aranceles"|x_translate} <i class="icon-doctorplus-check-thin"></i></a>
                            </div>
                            <div class="col-md-8 col-md-offset-2">
                                <div class="dc-disclaimer tarifas">
                                    <p>{"RECUERDE QUE SI NO DEFINE VALORES DE TARIFA NO APARECERÁ EN LOS BUSCADORES DEL SERVICIO."|x_translate}</p>
                                    <p>{"Por reglas de competencia leal se establece un importe mínimo de tarifa de"|x_translate}</p>
                                    <p>{"En caso de ser necesario, el sistema puede redondear los valores ingresados"|x_translate}  </p>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>

            </div>
            {if $especialidad_medico.tipo==1 && $medico.pais_idpais==1} <div class="panel panel-default dc-panel-4">
                    <div class="panel-heading" role="tab" id="headingTwo-a2">
                        <a class="collapsed" role="button" data-toggle="collapse" data-parent="#accordion-2" href="#collapseTwo-a2" aria-expanded="false" aria-controls="collapseTwo">

                            <h2>4. {"Teleconsulta con reintegro"|x_translate}</h2>

                        </a>
                    </div>
                    <div id="collapseTwo-a2" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingTwo">

                        <div class="mul-mis-servicios-wraper tarifas mul-vencimientos-box" style="display:block !important;">
                            <section class="okm-container mul-mis-servicios  mul-vencimientos">


                                <div class="okm-row">
                                    <div class="mul-precio-box">
                                        <div class="mul-precio-top-box">
                                    {if $medico.planProfesional==0}{"Ud. posee una Cuenta Gratuita"|x_translate}{else}{"Ud. posee una Cuenta Profesional"|x_translate}{/if}
                                </div>
                                <div class="mul-account-type-disclaimer">
                                    <p>{"Quiere beneficiar a sus pacientes del reintegro por la seguridad social de sus videoconsultas programadas?"|x_translate}</p>

                                    <p class="mul-higlight">{"Es fácil! Opte por una cuenta profesional con abono"|x_translate}</p>
                                </div>
                                <div class="account-type pro">
                                    <div>
                                        <span>{"Cuenta Profesional"|x_translate}</span>
                                        <span class="price">&euro;{$MONTO_CUOTA}<span> {"finales/MES"|x_translate}</span></span>
                                    </div>
                                </div>
                            </div>
                            <p class="mul-cuenta-precio-disclaimer">{"Inicialmente la contratación mínima es de 6 (seis) meses."|x_translate}</p>

                        </div>
                        <div class="okm-row">
                            <div class="mul-precio-action-box">
                                <a href="{$url}panel-medico/abono-proceso-compra/" class="btn-default">{"Cambiar de plan"|x_translate} <span class="bst-arrow-right"></span></a>
                            </div>
                        </div>

                    </section>							
                </div>
            </div>
        </div>
    {/if}     
    <div class="panel panel-default dc-panel-4">
        <div class="panel-heading" role="tab" id="headingTwo-a3">
            <a class="collapsed" role="button" data-toggle="collapse" data-parent="#accordion-3" href="#collapseTwo-a3" aria-expanded="false" aria-controls="collapseTwo">

                <h2>{if $especialidad_medico.tipo==1 && $medico.pais_idpais==1}5.{else}4.{/if} {"Mis servicios"|x_translate}</h2>

            </a>
        </div>
        <div id="collapseTwo-a3" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingTwo-a3">

            <div class="mul-mis-servicios-wraper tarifas">
                <section class="okm-container mul-mis-servicios">

                    <h3>{"¿A quién desea ofrecer sus servicios?"|x_translate}</h3>


                    <div class="mul-card-row">
                        <div class="mul-mis-servicios-card-col">
                            <div class="mul-mis-servicios-card">
                                <h4>{"Consulta Express"|x_translate}</h4>
                                <figure>
                                    <i class="icon-doctorplus-chat"></i>
                                </figure>
                                <form id="pacientesConsultaExpress" name="mul-consulta-express-card">
                                    <label class="radio radio-profesional-alert">
                                        {"Sólo a mis pacientes"|x_translate}
                                        <input type="radio"  {if $medico.planProfesional == 0}disabled data-tooltip_profesional="1"{/if} {if $preferencia.pacientesConsultaExpress=="2"}checked{/if} name="pacientesConsultaExpress" value="2"/>
                                    </label>
                                    <label class="radio">
                                        {"Todos los pacientes registrados"|x_translate}
                                        <input type="radio" {if $preferencia.pacientesConsultaExpress=="1"}checked{/if} name="pacientesConsultaExpress" value="1"/>
                                    </label>
                                </form>
                            </div>
                        </div>

                        <div class="mul-mis-servicios-card-col">
                            <div class="mul-mis-servicios-card">
                                <h4>{"Video Consulta"|x_translate}</h4>
                                <figure>
                                    <i class="icon-doctorplus-video-call"></i>
                                </figure>
                                <form id="pacientesVideoConsulta" name="mul-video-express-card">
                                    <label class="radio radio-profesional-alert">
                                        {"Sólo a mis pacientes"|x_translate}
                                        <input type="radio"  {if $medico.planProfesional == 0}disabled data-tooltip_profesional="1"{/if} {if $preferencia.pacientesVideoConsulta=="2"}checked{/if} name="pacientesVideoConsulta" value="2"/>
                                    </label>
                                    <label class="radio">
                                        {"Todos los pacientes registrados"|x_translate}
                                        <input type="radio" {if $preferencia.pacientesVideoConsulta=="1"}checked{/if} name="pacientesVideoConsulta" value="1"/>
                                    </label>
                                </form>
                            </div>
                        </div>
                    </div>

                    <div class="okm-row">
                        <p class="mul-mis-servicios-disclaimer">{"Ofrecer sus servicios a todos los pacientes registrados en DoctorPlus le dará la posibilidad de que lo contacten y recomienden pacientes nuevos"|x_translate}</p>
                    </div>

                </section>							
            </div>
        </div>
    </div>

    <div class="panel panel-default dc-panel-4">
        <div class="panel-heading" role="tab" id="headingTwo-a4">
            <a class="collapsed" role="button" data-toggle="collapse" data-parent="#accordion-4" href="#collapseTwo-a4" aria-expanded="false" aria-controls="collapseTwo">

                <h2>{if $especialidad_medico.tipo==1 && $medico.pais_idpais==1}6.{else}5.{/if} {"Empresas socias"|x_translate}</h2>

            </a>
        </div>
        <div id="collapseTwo-a4" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingTwo-a4">


            <!-- Prestadores -->


            <div class="row text-center">

                <label>
                    {"No hay empresas socias por el momento"|x_translate}
                </label>

            </div>

        </div>
    </div>
</section>
<!--FIN  Tarifas y Servicios-->
{*cobertura recetas*}
<!-- cobertura recetas -->
<section class="form edit info-profesional-form dc-form-white consultorios-src" id="cobertura">
    {if $medico.pais_idpais==1}
        {if $especialidad_medico.tipo==1}
            <div class="container">
                <h6 class="text-center">
                    {"Al escribir su conclusión médica, puede agregar una receta en formato PDF."|x_translate}
                </h6>
                <h6 class="text-center">
                    {"DoctorPlus generará un comprobante de receta electrónica y lo asociará con su receta."|x_translate}
                    {"Su paciente puede imprimirlo o enviarlo directamente por correo electrónico a su farmacéutico, quien se conectará a un espacio que le permitirá verificar que la receta es válida y que aún no se ha emitido."|x_translate}
                </h6>
                <h6 class="text-center" style="color: #cd3845;">
                    <strong>{"Atención"|x_translate}!</strong>
                </h6>
                <h6 class="text-center"  style="color: #cd3845;">
                    {"La receta agregada debe contener toda la información obligatoria y debe estar firmada antes de que se pueda dispensar en farmacias."|x_translate}
                </h6>

            </div>

        {else}
            <div class="container">
                <h6 class="text-center">{"Sección reservada para médicos."|x_translate}</h6>
            </div>
        {/if}
    {/if}
    {if $medico.pais_idpais==2}
        <div class="container">
            <h6 class="text-center">
                {"Al escribir su conclusión médica, puede decidir recetar medicamentos al paciente."|x_translate}
            </h6>
            <h6 class="text-center">
                {"En este caso, puede optar por notificar a su paciente, quien puede ir a su oficina a recoger su receta en la recepción presentando su tarjeta de identidad / CNS (o un tercero autorizado)."|x_translate}
            </h6>

        </div>
    {/if}

    {*oculto temporalmente hasta que se desarrolle*}
    {*
    <div class="container">
    <h2 class="text-center">{if $especialidad_medico.tipo==1 && $medico.pais_idpais==1}7.{else}6.{/if} {"Prepagas y Obras Sociales"|x_translate}</h2>

    <div class="row">
    <form name="coberturas" method="post">
    <div class="col-md-8 col-md-offset-2">
    <div class="okm-row">
    <div class="dc-cobertura-sugest-box">
    <div class="field-edit dp-edit tagsinput-primary mul-required-box mul-border" id="especialidad-input">
    <input type="hidden" name="idobraSocial" id="idobraSocial" value=""/>

    <input  id="as_obra_social" name="as_obra_social" type="text" class="especialidad-input"  placeholder='{"Medicina Prepaga / Obra Social"|x_translate}' data-title='{"Seleccione obra social"|x_translate}'>
    <span class="mul-input-icon">
    <i class="icon-doctorplus-search"></i>
    </span>

    </div>
    </div>
    <div class="dc-cobertura-sugest-action-box">
    <a href="javascript:;" id="btnAddObraSocial" class="btn-default-square">{"Agregar"|x_translate}</a>
    </div>
    </div>
    <div class="okm-row">
    <div class="tagsinput-primary okm-tags-no-margin">

    <input name="tagsinput" id="obrasocial_tagsinput" />

    </div>
    </div>

    </div>

    </form>

    </div>




    </div>
    *}
</section>
<!--FIN cobertura recetas -->
</div>

{x_load_js}
{*agregamos los tags input*}
<script>
    $(function (){ldelim}
            $("#obrasocial_tagsinput").tagsinput({ldelim}
                        itemValue: 'id',
                        itemText: 'text'
    {rdelim});
    {foreach from = $mis_obrasSociales item = tag}
            $("#obrasocial_tagsinput").tagsinput("add", {ldelim}"id"
                                : "{$tag.id}", "text": "{$tag.value}"{rdelim});
    {/foreach}


                                        $("#prestadores_tagsinput").tagsinput({ldelim}
                                                    itemValue: 'id',
                                                    itemText: 'text'
    {rdelim})
    {if $medico_isic != ""}
            $("#prestadores_tagsinput").tagsinput("add", {ldelim}"id"
                                : "{$medico_isic}", "text": "ISIC - International Student Identity Card"{rdelim});
    {/if}



    {rdelim});</script>
    {if $show_tarifas==1}
    <script>
        $(function () {
            $(".consultorios-trg[data-src='#tarifas']").trigger("click");
            $("#headingOne-a2 a").trigger("click");
        });
    </script>
{/if}