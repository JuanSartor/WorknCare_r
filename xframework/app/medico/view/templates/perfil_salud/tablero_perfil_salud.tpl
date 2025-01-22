{if $paciente}

{if $smarty.request.print==1}
{include file="perfil_salud/header_perfil_salud_imprimir.tpl"}
{else}
{include file="perfil_salud/menu_perfil_salud.tpl"}

<section class="module-header container-fluid">
    <div class="row ">
        <div class="col-md-12">
            <div class="container">
                <ol class="breadcrumb">
                    <li><a href="{$url}panel-medico/">{"Inicio"|x_translate}</a></li>
                    <li><a href="{$url}panel-medico/mis-pacientes/">{"Mis Pacientes"|x_translate}</a></li>
                    <li><a  class="nombre_paciente" href="{$url}panel-medico/mis-pacientes/{$paciente.idpaciente}-{$paciente.nombre|str2seo}-{$paciente.apellido|str2seo}/">{$paciente.nombre} {$paciente.apellido}</a></li>
                    <li class="active">{"Tablero"|x_translate}</li>
                </ol>
            </div>
        </div>
    </div>
</section>
{/if}
<input type="hidden" id="idpaciente" value="{$paciente.idpaciente}" />
{if $paciente.edad_anio < 17}
<section class="profile patient-overview">
    <div class="container">


        <article class="col-md-4">
            <div class="age card card-white overview">
                <div class="card-header age">
                    <h1 class="card-title">{"Edad"|x_translate}</h1>
                    <div class="card-value value">
                        <h2>
                            <span>{$paciente.edad_anio} <strong>{"años"|x_translate}</strong></span>
                            <span>{$paciente.edad_mes} <strong>{"meses"|x_translate}</strong></span>
                            <span>{$paciente.edad_dia} <strong>{"días"|x_translate}</strong></span>
                        </h2>
                    </div>
                </div>
                <div class="bottom-data">
                    <button class="btn-search search" id="modal-400" data-modal="yes">{"Ver Tablas de IMC"|x_translate}</button>
                    <div class="modal-edit-data hidden" style="width:400px">
                        <div class="edit-data info patient w"  style="width:400px">
                            <button data-dismiss="modal" class="close dp-canceled"></button>
                            <h1>{"IMC para la edad"|x_translate}</h1>
                            <ul style="width:400px">
                                {if $paciente.sexo == 0}
                                <li>{"Niñas"|x_translate}</li>
                                <li><a href="{$IMGS}IMC_ninas_p_0_2.jpg" class="red gallery-imc">{"IMC para la edad: Nacimiento a 2 años"|x_translate}</a></li>
                                <li><a href="{$IMGS}IMC_ninas_p_2_5.jpg" class="red gallery-imc">{"IMC para la edad: de 2 a 5 años"|x_translate}</a></li>
                                <li><a href="{$IMGS}IMC_ninas_p_0_5.jpg" class="red gallery-imc">{"IMC para la edad: Nacimiento a 5 años"|x_translate}</a></li>
                                {else}
                                <li>{"Niños"|x_translate}</li>
                                <li><a href="{$IMGS}IMC_ninos_p_0_2.jpg" class="red gallery-imc">{"IMC para la edad: Nacimiento a 2 años"|x_translate}</a></li>
                                <li><a href="{$IMGS}IMC_ninos_p_2_5.jpg" class="red gallery-imc">{"IMC para la edad: de 2 a 5 años"|x_translate}</a></li>
                                <li><a href="{$IMGS}IMC_ninos_p_0_5.jpg" class="red gallery-imc">{"IMC para la edad: Nacimiento a 5 años"|x_translate}</a></li>
                                {/if}
                            </ul>
                        </div>
                        <p class="bg-primary text-center"><small>{"Fuente : Organización Mundial de la Salud"|x_translate}</small></p>
                    </div>

                    <button class="btn-search search" id="modal-400" data-modal="yes">{"Ver Table de Percentilos"|x_translate}</button>
                    <div class="modal-edit-data hidden">
                        <div class="edit-data info patient w">
                            <button data-dismiss="modal" class="close dp-canceled"></button>
                            <h1>{"Tablas de Percentiles"|x_translate}</h1>
                            <ul>
                                {if $paciente.sexo == 0}
                                <li>{"Niñas"|x_translate}</li>
                                <li><a href="{$IMGS}percentiles_ninas_p_0_6.jpg" class="red gallery-perc">{"Nacimiento a 6 meses"|x_translate}</a></li>
                                <li><a href="{$IMGS}percentiles_ninas_p_0_2.jpg" class="red gallery-perc">{"Nacimiento a 2 años"|x_translate}</a></li>
                                <li><a href="{$IMGS}percentiles_ninas_p_6_2.jpg" class="red gallery-perc">{"de  6 meses a 2 años"|x_translate}</a></li>
                                <li><a href="{$IMGS}percentiles_ninas_p_2_5.jpg" class="red gallery-perc">{"de 2 a 5 años"|x_translate}</a></li>
                                <li><a href="{$IMGS}percentiles_ninas_p_0_5.jpg" class="red gallery-perc">{"Nacimiento a 5 años"|x_translate}</a></li>
                                {else}
                                <li>{"Niños"|x_translate}</li>
                                <li><a href="{$IMGS}percentiles_ninos_p_0_6.jpg" class="red gallery-perc">{"Nacimiento a 6 meses"|x_translate}</a></li>
                                <li><a href="{$IMGS}percentiles_ninos_p_0_2.jpg" class="red gallery-perc">{"Nacimiento a 2 años"|x_translate}</a></li>
                                <li><a href="{$IMGS}percentiles_ninos_p_6_2.jpg" class="red gallery-perc">{"de  6 meses a 2 años"|x_translate}</a></li>
                                <li><a href="{$IMGS}percentiles_ninos_p_2_5.jpg" class="red gallery-perc">{"de 2 a 5 años"|x_translate}</a></li>
                                <li><a href="{$IMGS}percentiles_ninos_p_0_5.jpg" class="red gallery-perc">{"Nacimiento a 5 años"|x_translate}</a></li>
                                {/if}
                            </ul>
                        </div>
                        <p class="bg-primary text-center"><small>{"Fuente : Organización Mundial de la Salud"|x_translate}</small></p>
                    </div>	
                </div>
            </div>				
        </article>
        <article class="col-md-4 border-sep">
            <div class="weight card card-white overview">
                <div class="card-header">
                    <h1 class="card-title">{"Peso"|x_translate}</h1>
                    <div class="card-value value">
                        <h2>{if $masa_corporal.peso}{$masa_corporal.peso}{else}__{/if} <span>{"Kg"|x_translate}</span></h2>	
                        <p class="summary status-ok value">{if $masa_corporal.diferencia_peso}{$masa_corporal.diferencia_peso} {"kg"|x_translate}{else}&nbsp;{/if}</p>
                    </div>
                </div>
                <div class="bottom-data">

                    {if $masa_corporal.fecha_peso_dp != ""}
                    <p class="last-modified">{"Último registro"|x_translate} {$masa_corporal.fecha_peso_dp}</p>
                    {else}
                    <p class="last-modified label-sin-registros">{"Nunca ingreso registros"|x_translate}</p>
                    {/if}
                    <button class="edit dp-edit" id="modal-400" data-modal="yes">{"Actualizar"|x_translate}</button>
                    <div class="modal-edit-data hidden">
                        <div class="edit-data patient w">
                            <button data-dismiss="modal" class="close dp-canceled"></button>
                            <h1>{"Peso"|x_translate}</h1>
                            <form class="edit patient-data" id="masa_corporal_tablero_form" action="{$url}save_masa_corporal_form_m.do" method="post" onsubmit="return false;">
                                <input type="hidden" name="paciente_idpaciente" value="{$idpaciente}" />
                                <input type="hidden" name="altura" value="{$masa_corporal.altura}" />
                                <input type="hidden" name="from_peso" value="1" />
                                <input type="hidden" name="perfilSaludBiometricos_idperfilSaludBiometricos" value="{$perfil_salud_biometrico.idperfilSaludBiometricos}" />
                                <div class="form-group underline">
                                    <label for="weight">{"Peso"|x_translate}</label>
                                    <span class="pull-right" id="weight">
                                        <input name="peso" value="{$masa_corporal.peso}" type="number">
                                    </span>
                                </div>
                                <div class="form-group" style="margin-top:15px;">
                                    <label for="sms"><b>{"IMC"|x_translate}</b></label>
                                    <span class="pull-right" style="font-size:25px; line-height:25px;">{$masa_corporal.imc}</span>
                                </div>									
                                <input type="submit" onclick="submitTableroFormPediatricoMC('masa_corporal_tablero_form');" value="guardar">
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </article>
        <article class="col-md-4">
            <div class="height card card-white overview">
                <div class="card-header icon">
                    <h1 class="card-title">{"Altura"|x_translate}</h1>
                    <div class="card-value value">
                        <h2>{if $masa_corporal.altura}{$masa_corporal.altura}{else}__{/if}<span> {"cm"|x_translate}</span></h2>
                        <p class="summary status-ok value">{if $masa_corporal.diferencia_altura}{$masa_corporal.diferencia_altura} {"cm"|x_translate}{else}&nbsp;{/if}</p>
                    </div>
                    {if $paciente.sexo == 0}
                    <span class="sex female"></span>
                    {else}
                    <span class="sex male"></span>
                    {/if}
                </div>
                <div class="bottom-data">

                    {if $masa_corporal.fecha_altura_dp != ""}
                    <p class="last-modified">{"Último registro"|x_translate} {$masa_corporal.fecha_altura_dp}</p>
                    {else}
                    <p class="last-modified label-sin-registros">{"Nunca ingreso registros"|x_translate}</p>
                    {/if}
                    <button class="edit dp-edit" id="modal-400" data-modal="yes">{"Actualizar"|x_translate}</button>
                    <div class="modal-edit-data hidden">
                        <div class="edit-data patient w">
                            <button data-dismiss="modal" class="close dp-canceled"></button>
                            <h1>{"Altura"|x_translate}</h1>
                            <form class="edit patient-data" id="altura_tablero_form" action="{$url}save_masa_corporal_form_m.do" method="post" onsubmit="return false;">
                                <input type="hidden" name="paciente_idpaciente" value="{$idpaciente}" />
                                <input type="hidden" name="peso" value="{$masa_corporal.peso}" />
                                <input type="hidden" name="from_altura" value="1" />
                                <input type="hidden" name="perfilSaludBiometricos_idperfilSaludBiometricos" value="{$perfil_salud_biometrico.idperfilSaludBiometricos}" />
                                <div class="form-group underline">
                                    <label for="size">{"Altura"|x_translate}</label>
                                    <span class="pull-right" id="size">
                                        <input  id="altura" name="altura" value="{$masa_corporal.altura}" type="number">
                                    </span>
                                </div>
                                <div class="form-group" style="margin-top:15px;">
                                    <label for="sms"><b>{"IMC"|x_translate}</b></label>
                                    <span class="pull-right" style="font-size:25px; line-height:25px;">{$masa_corporal.imc}</span>
                                </div>									
                                <input type="submit" onclick="submitTableroFormPediatricoMC('altura_tablero_form');" value="guardar">
                            </form>
                        </div>
                    </div>
                </div>
        </article>
        <div class="clearfix"></div>
        <hr>
    </div>
</section>


<div class="container tablero-paciente">
    <div class="row">

        <article class="col-md-4">
            <a href="{$url}panel-medico/mis-pacientes/{$paciente.idpaciente}-{$paciente.nombre|str2seo}-{$paciente.apellido|str2seo}/registro-consultas-medicas.html" class="border-box border-box-solid dp-info"><span>{"Registro Consultas Médicas"|x_translate}</span></a>	
        </article>

        <article class="col-md-4">
            <div class="card grid-overview">
                <div class="card-header">
                    
                    <h1 class="card-title">{"Ultima consulta médica"|x_translate}</h1>
                    <div class="card-value value">
                        <h2><span>{$ultima_consulta.fecha_format}</span>
                            {if $ultima_consulta.consultaExpress_idconsultaExpress!=""} 
                            <figure class="green-circle circle-55 card-circle">
				<i class="icon-doctorplus-chat"></i>
                            </figure>
                            {/if}
                            {if $ultima_consulta.videoconsulta_idvideoconsulta!=""}
                            <figure class="green-circle circle-55 card-circle">
				<i class="icon-doctorplus-video-call"></i>
                            </figure>
                            {/if}
                        </h2>
                    </div>									
                </div>
                <div class="card-body">
                 
                    {if $ultima_consulta.idperfilSaludConsulta!=""}
                    <div class="row">
                        <div class="data col-md-6"><em>{"Diagnóstico"|x_translate}</em>{$ultima_consulta.diagnostico}</div>
                    </div>
                    {else}
                       <div class="row">
                        
                        <div class="data col-md-11"><em><p>{"No posee consultas médicas"|x_translate} </p></em></div>
                       
                    </div>
                    {/if}
                </div>
                <div class="bottom-data">
                    {if $ultima_consulta.idperfilSaludConsulta!=""}
                    <a href="{$url}panel-medico/mis-pacientes/{$paciente.idpaciente}-{$paciente.nombre|str2seo}-{$paciente.apellido|str2seo}/registros-consultas-medicas-detalle/{$ultima_consulta.idperfilSaludConsulta}" class="btn btn-md btn-inverse consultas-card-btn btnVerMas" data-idmedico="{$medico.idmedico}"  data-idespecialidad="{$medico.idespecialidad}" >{"ver más"|x_translate}</a>
                    {else}
                    <a href="{$url}panel-medico/mis-pacientes/{$paciente.idpaciente}-{$paciente.nombre|str2seo}-{$paciente.apellido|str2seo}/registro-consultas-medicas.html" class="btn btn-md btn-inverse consultas-card-btn btnVerMas" data-idmedico="{$medico.idmedico}"  data-idespecialidad="{$medico.idespecialidad}" >{"ver más"|x_translate}</a>

                    {/if}
                </div>							
            </div>
        </article>

        <article class="col-md-4">
            <a href="{$url}panel-medico/mis-pacientes/{$paciente.idpaciente}-{$paciente.nombre|str2seo}-{$paciente.apellido|str2seo}/consultanueva.html" class="modal-btn border-box dp-plus" data-target="agregar-prescripcion" role="button"><span>{"Nueva Consulta"|x_translate}</span></a>
        </article>


        <div class="clearfix"></div>


    </div>
</div>

<br>

{literal}
<script>
    $(document).ready(function () {

        $("button[data-modal='yes_datos']").on('click', function (event) {

            var button = event.target;
            var objClass = $(this).attr('class');
            if ($(this).parent('ul') && $(this).parents('ul').attr('id')) {
                var menuOrigin = $(this).parents('ul').attr('id');
            }

            if ($(button).data('modal') == 'yes_datos') {
                var object = $(button).next('[class^="modal-"]');
                var parse = object.html();

                if ($(button).attr('id')) {
                    var id = $(button).attr('id');
                }

                if (typeof id !== 'undefined') {
                    $('.modal-inside').find('.modal-dialog').attr('id', id);
                }
                $('.modal-inside').find('.modal-body').html(parse);
                $('.modal-inside .modal-body').find('.hidden').removeClass('hidden');
                $('.modal-inside').modal();

                if ($('.modal-inside').find('li a').hasClass('gallery-imc')) {
                    $('.gallery-imc').featherlightGallery({
                        gallery: {fadeIn: 300, fadeOut: 300}
                    });
                }
                if ($('.modal-inside').find('li a').hasClass('gallery-perc')) {
                    $('.gallery-perc').featherlightGallery({
                        gallery: {fadeIn: 300, fadeOut: 300}
                    });
                }
            }
        });


        $("button[data-modal='yes']").on('click', function (event) {

            var button = event.target;
            var objClass = $(this).attr('class');
            if ($(this).parent('ul') && $(this).parents('ul').attr('id')) {
                var menuOrigin = $(this).parents('ul').attr('id');
            }

            buttonTriggers(button, menuOrigin, objClass);
        });

    });

    function submitTableroFormPediatricoMC(id_form) {


        $("#" + id_form).validate({
            showErrors: function (errorMap, errorList) {

                // Clean up any tooltips for valid elements
                $.each(this.validElements(), function (index, element) {
                    var $element = $(element);

                    $element.data("title", "") // Clear the title - there is no error associated anymore
                            .removeClass("error")
                            .tooltip("destroy");
                });

                // Create new tooltips for invalid elements
                $.each(errorList, function (index, error) {
                    var $element = $(error.element);

                    $element.tooltip("destroy") // Destroy any pre-existing tooltip so we can repopulate with new tooltip content
                            .data("title", error.message)
                            .addClass("error")
                            .tooltip(); // Create a new tooltip based on the error messsage we just set in the title

                });
            },
            submitHandler: function (form) {
                x_sendForm($("#" + id_form), true, function (data) {
              
                    if (data.result) {
                             x_alert(data.msg,recargar);
                        $(".modal.fade.in:visible").modal('toggle')
                    }else{
                              x_alert(data.msg);
                    }
                }
                );
            }
        });
    }
</script>
{/literal}

{else}
<section class="profile patient-overview">
    <div class="container">

        <div class="row" id="notificaciones">
            <div class="col-sm-12" >

                <div class="module-subheader">
                    <div class="row">
                        <h2 class="dp-flag">{"Notificaciones"|x_translate}</h2>
                    </div>
                </div>
                <table class="table-responsive historico-consultas-table notificaciones-table">
                    <thead>
                        <tr>
                            <td class="col-1">{"Fecha"|x_translate}</td>
                            <td class="">{"Tipo"|x_translate}</td>
                            <td class="col-3">{"Diagnóstico"|x_translate}</td>
                            <td class="col-4">{"Desactivar todas"|x_translate}</td>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>05/11/2014</td>
                            <td>{"Vacuna"|x_translate}</td>
                            <td>{"Refuerzo antitetánica"|x_translate}</td>
                            <td><span class="dp-flag"></span></td>
                        </tr>
                        <tr>
                            <td>05/11/2014</td>
                            <td>{"Vacuna"|x_translate}</td>
                            <td>{"Refuerzo antitetánica"|x_translate}</td>
                            <td><span class="dp-flag deactivated"></span></td>
                        </tr>
                        <tr>
                            <td>05/11/2014</td>
                            <td>{"Vacuna"|x_translate}</td>
                            <td>{"Refuerzo antitetánica"|x_translate}</td>
                            <td><span class="dp-flag"></span></td>
                        </tr>
                        <tr>
                            <td>05/11/2014</td>
                            <td>{"Vacuna"|x_translate}</td>
                            <td>{"Refuerzo antitetánica"|x_translate}</td>
                            <td><span class="dp-flag"></span></td>
                        </tr>																								
                    </tbody>
                </table>
            </div>
        </div>	
        <!-- /notificaciones -->

        <article class="col-md-4 ">
            <div class="weight card card-white overview">
                <div class="card-header">
                    <h1 class="card-title">{"Peso"|x_translate}</h1>
                    <div class="card-value value">
                        <h2>{if $masa_corporal.peso}{$masa_corporal.peso}{else}__{/if} <span>{"Kg"|x_translate}</span></h2>	
                        <p class="summary status-ok value">{if $masa_corporal.diferencia_peso}{$masa_corporal.diferencia_peso} {"kg"|x_translate}{else}&nbsp;{/if}</p>
                    </div>
                    {if $paciente.sexo == 0}
                    <span class="sex female"></span>
                    {else}
                    <span class="sex male"></span>
                    {/if}
                </div>
                <div class="bottom-data">						
                    {if $masa_corporal.fecha_altura_dp != ""}
                        <p class="last-modified">{"Último registro"|x_translate} {$masa_corporal.fecha_altura_dp}</p>
                        {else}
                        <p class="last-modified label-sin-registros">{"Nunca ingreso registros"|x_translate}</p>
                        {/if}
                    <button class="edit dp-edit" data-modal="yes" id="modal-400">{"Actualizar"|x_translate}</button>
                    <div class="modal-edit-data hidden">
                        <div class="edit-data patient w">
                            <button data-dismiss="modal" class="close dp-canceled"></button>
                            <h1>{"Peso y altura"|x_translate}</h1>
                            <form class="edit patient-data" id="masa_corporal_tablero_form" action="{$url}save_masa_corporal_form_m.do" method="post" onsubmit="return false;">
                                <input type="hidden" name="paciente_idpaciente" value="{$idpaciente}" />
                                <input type="hidden" name="perfilSaludBiometricos_idperfilSaludBiometricos" value="{$perfil_salud_biometrico.idperfilSaludBiometricos}" />
                                <div class="form-group underline">
                                    <label for="weight">{"Peso"|x_translate}</label>
                                    <span class="pull-right">
                                        <input name="peso" value="{$masa_corporal.peso}" type="number">
                                    </span>
                                </div>
                                <div class="form-group underline">
                                    <label for="size">{"Altura"|x_translate}</label>
                                    <span class="pull-right">
                                        <input name="altura" value="{$masa_corporal.altura}" type="number">
                                    </span>
                                </div>
                                <div class="form-group" style="margin-top:15px;">
                                    <label for="sms"><b>{"IMC"|x_translate}</b></label>
                                    <span class="pull-right" style="font-size:25px; line-height:25px;">{$masa_corporal.imc}</span>
                                </div>
                                <input type="submit" onclick="submitTableroFormMC();" value="guardar">
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </article>
        <article class="col-md-4 border-sep">
            <div class="height card card-white overview">
                <div class="card-header icon">
                    <h1 class="card-title">{"Presión Arterial"|x_translate}</h1>
                    <div class="card-value value">
                        <h2>{if $presion_arterial.presion_campo1 != ""}{$presion_arterial.presion_campo1}/<small>{$presion_arterial.presion_campo2}</small>{else}--/<small>--</small>{/if}</h2>
                    </div>
                </div>
                <div class="bottom-data">

                    {if $presion_arterial}
                    <p class="last-modified">{"Último registro"|x_translate} {$presion_arterial.fecha_dp}</p>
                    {else}
                    <p class="last-modified label-sin-registros">{"Nunca ingreso registros"|x_translate}</p>
                    {/if}


                    <button class="edit dp-edit" id="modal-400" data-modal="yes">{"Actualizar"|x_translate}</button>
                    <div class="modal-edit-data hidden">
                        <div class="edit-data patient w">
                            <button data-dismiss="modal" class="close dp-canceled"></button>
                            <h1>{"Presión Arterial"|x_translate}</h1>
                            <form class="edit patient-data" id="presion_arterial_tablero_form" action="{$url}save_presion_arterial_form_m.do" method="post" onsubmit="return false;">
                                <input type="hidden" name="paciente_idpaciente" value="{$idpaciente}" />
                                <input type="hidden" name="perfilSaludBiometricos_idperfilSaludBiometricos" value="{$perfil_salud_biometrico.idperfilSaludBiometricos}" />
                                <div class="form-group underline">
                                    <label for="systole">{"Presión Arterial"|x_translate}</label>
                                    <input class="pull-right" id="presion_campo1" name="presion_campo1" value="{$presion_arterial.presion_campo1}" type="text">
                                    <input class="pull-right" id="presion_campo2" name="presion_campo2" value="{$presion_arterial.presion_campo2}" type="text">
                                </div>
                                <div class="form-group underline">
                                    <label for="systole">{"Sístole"|x_translate}</label>
                                    <input class="pull-right" name="sistole" value="{$presion_arterial.sistole}" type="number">
                                </div>
                                <div class="form-group underline">
                                    <label for="diastole">{"Diástole"|x_translate}</label>
                                    <input class="pull-right" name="diastole" value="{$presion_arterial.diastole}" type="number">
                                </div>
                                <div class="form-group underline">
                                    <label for="frequency">{"Frecuencia Cardíaca"|x_translate}</label>
                                    <input class="pull-right" name="frecuencia_cardiaca" value="{$presion_arterial.frecuencia_cardiaca}" type="number">
                                </div>
                                <input type="submit" onclick ="submitFormPresionArterialTablero()" value="guardar">
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </article>
        <article class="col-md-4">
            <div class="height card card-white overview">
                <div class="card-header icon">
                    <h1 class="card-title">{"Colesterol"|x_translate}</h1>
                    <div class="card-value value">
                        <h2>{if $colesterol.colesterol_total}{$colesterol.colesterol_total}{else}___{/if} <span>{"mg/dl"|x_translate}</span></h2>
                    </div>
                </div>
                <div class="bottom-data">

                    {if $colesterol}
                    <p class="last-modified">{"Último registro"|x_translate} {$colesterol.fecha_dp}</p>
                    {else}
                    <p class="last-modified label-sin-registros">{"Nunca ingreso registros"|x_translate}</p>
                    {/if}
                    <button class="edit dp-edit" id="modal-400" data-modal="yes">{"Actualizar"|x_translate}</button>
                    <div class="modal-edit-data hidden">
                        <div class="edit-data patient w">
                            <button data-dismiss="modal" class="close dp-canceled"></button>
                            <h1>{"Colesterol"|x_translate}</h1>
                            <form class="edit patient-data" id="colesterol_tablero_form" action="{$url}save_colesterol_form_m.do" method="post" onsubmit="return false;">
                                <input type="hidden" name="paciente_idpaciente" value="{$idpaciente}" />
                                <input type="hidden" name="perfilSaludBiometricos_idperfilSaludBiometricos" value="{$perfil_salud_biometrico.idperfilSaludBiometricos}" />

                                <div class="form-group underline">
                                    <label for="ch-total">{"Colesterol Total"|x_translate}</label>
                                    <input class="pull-right" value="{$colesterol.colesterol_total}" name="colesterol_total" type="number">
                                </div>
                                <div class="form-group underline">
                                    <label for="hdl">{"HDL"|x_translate}</label>
                                    <input class="pull-right" value="{$colesterol.HDL}" name="HDL"  type="number">
                                </div>
                                <div class="form-group underline">
                                    <label for="ldl">{"LDL"|x_translate}</label>
                                    <input class="pull-right" value="{$colesterol.LDL}" name="LDL"  type="number">
                                </div>
                                <div class="form-group underline">
                                    <label for="triglycerides">{"Triglicéridos"|x_translate}</label>
                                    <input class="pull-right" value="{$colesterol.trigriseliridos}" name="trigriseliridos" type="number">
                                </div>
                                <input type="submit" onclick ="submitColesterolTableroForm()" value="guardar">

                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </article>	
        <!-- /colesterol top -->
        <div class="clearfix"></div>
        <hr>
    </div>
</section>


<div class="container tablero-paciente">
    <div class="row">

        <article class="col-md-4">
            <a href="{$url}panel-medico/mis-pacientes/{$paciente.idpaciente}-{$paciente.nombre|str2seo}-{$paciente.apellido|str2seo}/registro-consultas-medicas.html" class="border-box border-box-solid dp-info"><span>{"Registro Consultas Médicas"|x_translate}</span></a>	
        </article>

        <article class="col-md-4">
            <div class="card grid-overview">
                <div class="card-header">
                    <h1 class="card-title">{"Ultima consulta médica"|x_translate}</h1>
                    <div class="card-value value">
                        <h2><span>{$ultima_consulta.fecha_format}</span> 
                             {if $ultima_consulta.consultaExpress_idconsultaExpress!=""} 
                            <figure class="green-circle circle-55 card-circle">
				<i class="icon-doctorplus-chat"></i>
                            </figure>
                            {/if}
                            {if $ultima_consulta.videoconsulta_idvideoconsulta!=""}
                            <figure class="green-circle circle-55 card-circle">
				<i class="icon-doctorplus-video-call"></i>
                            </figure>
                            {/if}
                        </h2>
                    </div>									
                </div>
                  {if $ultima_consulta.idperfilSaludConsulta!=""}
                    <div class="row">
                        <div class="data col-md-6"><em>{"Diagnóstico"|x_translate}</em>{$ultima_consulta.diagnostico}</div>
                    </div>
                    {else}
                       <div class="row">
                        
                        <div class="data col-md-11"><em><p>{"No posee consultas médicas"|x_translate} </p></em></div>
                       
                    </div>
                    {/if}
                <div class="bottom-data">
                    
                    {if $ultima_consulta.idperfilSaludConsulta!=""}
                    <a href="{$url}panel-medico/mis-pacientes/{$paciente.idpaciente}-{$paciente.nombre|str2seo}-{$paciente.apellido|str2seo}/registros-consultas-medicas-detalle/{$ultima_consulta.idperfilSaludConsulta}" class="btn btn-md btn-inverse consultas-card-btn btnVerMas" data-idmedico="{$medico.idmedico}"  data-idespecialidad="{$medico.idespecialidad}" >{"ver más"|x_translate}</a>
                    {else}
                    <a href="{$url}panel-medico/mis-pacientes/{$paciente.idpaciente}-{$paciente.nombre|str2seo}-{$paciente.apellido|str2seo}/registro-consultas-medicas.html" class="btn btn-md btn-inverse consultas-card-btn btnVerMas" data-idmedico="{$medico.idmedico}"  data-idespecialidad="{$medico.idespecialidad}" >{"ver más"|x_translate}</a>
                    {/if}

                </div>							
            </div>
        </article>

        <article class="col-md-4">
            <a href="{$url}panel-medico/mis-pacientes/{$paciente.idpaciente}-{$paciente.nombre|str2seo}-{$paciente.apellido|str2seo}/consultanueva.html" class="modal-btn border-box dp-plus" role="button"><span>{"Nueva Consulta"|x_translate}</span></a>	
        </article>


    </div>
</div>

<br>


{literal}
<script>
    $(document).ready(function () {
        $("#presion_arterial_tab").inputmask("9[9]/9[9]");



        $("#div_cards_datos_biometricos button[data-modal='yes_datos']").on('click', function (event) {

            var button = event.target;
            var objClass = $(this).attr('class');
            if ($(this).parent('ul') && $(this).parents('ul').attr('id')) {
                var menuOrigin = $(this).parents('ul').attr('id');
            }

            if ($(button).data('modal') == 'yes_datos') {
                var object = $(button).next('[class^="modal-"]');
                var parse = object.html();

                if ($(button).attr('id')) {
                    var id = $(button).attr('id');
                }

                if (typeof id !== 'undefined') {
                    $('.modal-inside').find('.modal-dialog').attr('id', id);
                }
                $('.modal-inside').find('.modal-body').html(parse);
                $('.modal-inside .modal-body').find('.hidden').removeClass('hidden');
                $('.modal-inside').modal();

                if ($('.modal-inside').find('li a').hasClass('gallery-imc')) {
                    $('.gallery-imc').featherlightGallery({
                        gallery: {fadeIn: 300, fadeOut: 300}
                    });
                }
                if ($('.modal-inside').find('li a').hasClass('gallery-perc')) {
                    $('.gallery-perc').featherlightGallery({
                        gallery: {fadeIn: 300, fadeOut: 300}
                    });
                }
            }
        });


        $("#div_cards_datos_biometricos button[data-modal='yes']").on('click', function (event) {

            var button = event.target;
            var objClass = $(this).attr('class');
            if ($(this).parent('ul') && $(this).parents('ul').attr('id')) {
                var menuOrigin = $(this).parents('ul').attr('id');
            }

            buttonTriggers(button, menuOrigin, objClass);
        });



    });



    function submitFormPresionArterialTablero() {

        $("#presion_arterial_tablero_form").validate({
            showErrors: function (errorMap, errorList) {

                // Clean up any tooltips for valid elements
                $.each(this.validElements(), function (index, element) {
                    var $element = $(element);

                    $element.data("title", "") // Clear the title - there is no error associated anymore
                            .removeClass("error")
                            .tooltip("destroy");
                });

                // Create new tooltips for invalid elements
                $.each(errorList, function (index, error) {
                    var $element = $(error.element);

                    $element.tooltip("destroy") // Destroy any pre-existing tooltip so we can repopulate with new tooltip content
                            .data("title", error.message)
                            .addClass("error")
                            .tooltip(); // Create a new tooltip based on the error messsage we just set in the title

                });
            },
            submitHandler: function (form) {
                x_sendForm($('#presion_arterial_tablero_form'), true, function (data) {
                   
                    if (data.result) {
                        x_alert(data.msg,recargar);
                    }else{
                         x_alert(data.msg);
                    }
                });
            }
        });
    }

    function submitColesterolTableroForm() {

        $("#colesterol_tablero_form").validate({
            showErrors: function (errorMap, errorList) {

                // Clean up any tooltips for valid elements
                $.each(this.validElements(), function (index, element) {
                    var $element = $(element);

                    $element.data("title", "") // Clear the title - there is no error associated anymore
                            .removeClass("error")
                            .tooltip("destroy");
                });

                // Create new tooltips for invalid elements
                $.each(errorList, function (index, error) {
                    var $element = $(error.element);

                    $element.tooltip("destroy") // Destroy any pre-existing tooltip so we can repopulate with new tooltip content
                            .data("title", error.message)
                            .addClass("error")
                            .tooltip(); // Create a new tooltip based on the error messsage we just set in the title

                });
            },
            submitHandler: function (form) {
                x_sendForm($('#colesterol_tablero_form'), true, function (data) {
                    
                    if (data.result) {
                        if (data.result) {
                            x_alert(data.msg,recargar);
                        }else{
                            x_alert(data.msg);
                        }
                    }
                });
            }
        });
    }


    function submitTableroFormMC() {

        $("#masa_corporal_tablero_form").validate({
            showErrors: function (errorMap, errorList) {

                // Clean up any tooltips for valid elements
                $.each(this.validElements(), function (index, element) {
                    var $element = $(element);

                    $element.data("title", "") // Clear the title - there is no error associated anymore
                            .removeClass("error")
                            .tooltip("destroy");
                });

                // Create new tooltips for invalid elements
                $.each(errorList, function (index, error) {
                    var $element = $(error.element);

                    $element.tooltip("destroy") // Destroy any pre-existing tooltip so we can repopulate with new tooltip content
                            .data("title", error.message)
                            .addClass("error")
                            .tooltip(); // Create a new tooltip based on the error messsage we just set in the title

                });
            },
            submitHandler: function (form) {
                x_sendForm($('#masa_corporal_tablero_form'), true, function (data) {
                    x_alert(data.msg);
                    if (data.result) {
                        x_alert(data.msg,recargar);
                    }else{
                        x_alert(data.msg);
                    }
                }
                );
            }
        });
    }
</script>
{/literal}

{/if}
{/if}
