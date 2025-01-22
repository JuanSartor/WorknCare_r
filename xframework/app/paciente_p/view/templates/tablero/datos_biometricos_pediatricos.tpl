<div class="modal fade modal-inside"  data-load="no" >
    <div class="modal-dialog" style="width:400px">
        <div class="modal-content">
            <div class="modal-body"></div>
        </div><!-- /.modal-content -->
    </div><!-- /.modal-dialog -->
</div>
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
        <div class="bottom-data" id="div_button_datos_biometricos">
            <button class="btn-search search" data-modal="yes_datos">{"Ver Tablas de IMC"|x_translate}</button>
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

            <button class="btn-search search" data-modal="yes_datos">{"Ver Table de Percentilos"|x_translate}</button>
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
            <p class="last-modified">{"Último registro"|x_translate} {$masa_corporal.fecha_peso_dp} </p>
            {else}
            <p class="last-modified label-sin-registros">{"Nunca ingreso registros"|x_translate}</p>
            {/if}
            <button class="edit dp-edit" id="modal-400" data-modal="yes">{"actualizar"|x_translate}</button>
            <div class="modal-edit-data hidden">
                <div class="edit-data patient w">
                    <button data-dismiss="modal" class="close dp-canceled"></button>
                    <h1>{"Peso"|x_translate}</h1>
                    <form class="edit patient-data" id="masa_corporal_tablero_form" action="{$url}save_masa_corporal_form.do" method="post" onsubmit="return false;">
                        <input type="hidden" name="from_peso" value="1" />
                        <input type="hidden" name="paciente_idpaciente" value="{$idpaciente}" />
                        <input type="hidden" name="perfilSaludBiometricos_idperfilSaludBiometricos" value="{$perfil_salud_biometrico.idperfilSaludBiometricos}" />
                        <div class="form-group underline">
                            <label for="weight">{"Peso"|x_translate}</label>
                            <span class="pull-right" id="weight">
                                <input name="peso" value="{$masa_corporal.peso}" type="number">
                            </span>
                        </div>
                        <div class="form-group" style="margin-top:15px;">
                            <label for="sms"><b{"IMC"|x_translate}</b></label>
                            <span class="pull-right" style="font-size:25px; line-height:25px;">{$masa_corporal.imc}</span>
                        </div>									
                        <input type="submit" onclick="submitTableroFormPediatricoMC('masa_corporal_tablero_form');" value='{"guardar"|x_translate}'>
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
            {if $masa_corporal}
            <p class="last-modified">{"Último registro"|x_translate} {$masa_corporal.fecha_altura_dp} </p>
            {else}
            <p class="last-modified label-sin-registros">{"Nunca ingreso registros"|x_translate}</p>
            {/if}
            <button class="edit dp-edit" id="modal-400" data-modal="yes">{"actualizar"|x_translate}</button>
            <div class="modal-edit-data hidden">
                <div class="edit-data patient w">
                    <button data-dismiss="modal" class="close dp-canceled"></button>
                    <h1>{"Altura"|x_translate}</h1>
                    <form class="edit patient-data" id="altura_tablero_form" action="{$url}save_masa_corporal_form.do" method="post" onsubmit="return false;">
                        <input type="hidden" name="paciente_idpaciente" value="{$idpaciente}" />
                        <input type="hidden" name="from_altura" value="1" />
                        <input type="hidden" name="perfilSaludBiometricos_idperfilSaludBiometricos" value="{$perfil_salud_biometrico.idperfilSaludBiometricos}" />
                        <div class="form-group underline">
                            <label for="size">{"Altura"|x_translate}</label>
                            <span class="pull-right" id="size">
                                <input class="pull-right" id="altura" name="altura" value="{$masa_corporal.altura}" type="number">
                            </span>
                        </div>
                        <div class="form-group" style="margin-top:15px;">
                            <label for="sms"><b>{"IMC"|x_translate}</b></label>
                            <span class="pull-right" style="font-size:25px; line-height:25px;">{$masa_corporal.imc}</span>
                        </div>									
                        <input type="submit" onclick="submitTableroFormPediatricoMC('altura_tablero_form');" value='{"guardar"|x_translate}'>
                    </form>
                </div>
            </div>
        </div>
    </div>
</article>

{literal}
<script>
    $(document).ready(function() {

        $("#div_cards_datos_biometricos button[data-modal='yes_datos']").on('click', function(event) {
            
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

    
                  
                    $('.gallery-imc').featherlightGallery({
                        gallery: {fadeIn: 300, fadeOut: 300}
                    });
                
             
                 
                    $('.gallery-perc').featherlightGallery({
                        gallery: {fadeIn: 300, fadeOut: 300}
                    });
                
            }
        });
        
        
        $("#div_cards_datos_biometricos button[data-modal='yes']").on('click', function(event) {
            
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
            showErrors: function(errorMap, errorList) {

                // Clean up any tooltips for valid elements
                $.each(this.validElements(), function(index, element) {
                    var $element = $(element);

                    $element.data("title", "") // Clear the title - there is no error associated anymore
                            .removeClass("error")
                            .tooltip("destroy");
                });

                // Create new tooltips for invalid elements
                $.each(errorList, function(index, error) {
                    var $element = $(error.element);

                    $element.tooltip("destroy") // Destroy any pre-existing tooltip so we can repopulate with new tooltip content
                            .data("title", error.message)
                            .addClass("error")
                            .tooltip(); // Create a new tooltip based on the error messsage we just set in the title

                });
            },
            submitHandler: function(form) {
                x_sendForm($("#" + id_form), true, function(data) {
                    
                    if (data.result) {
                        x_alert(data.msg, recargar);
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