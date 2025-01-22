<div class="modal fade modal-inside"  data-load="no" >
    <div class="modal-dialog" style="width:400px">
        <div class="modal-content">
            <div class="modal-body"></div>
        </div><!-- /.modal-content -->
    </div><!-- /.modal-dialog -->
</div>

<article class="col-md-6">
    <div class="card weight">
        <div class="row">
            <div class="col-md-6  col-xs-6">
                <div class="card-header">
                    <h1 class="card-title">{"Peso"|x_translate}</h1>
                    <div class="card-value value">
                        <h2>{if $masa_corporal.peso}{$masa_corporal.peso} {else}__{/if}</h2>
                        <p class="summary status-ok value">{if $masa_corporal.diferencia_peso}{$masa_corporal.diferencia_peso} {else}__{/if}</p>
                        {if $masa_corporal.fecha_peso_dp != ""}
                        <p class="last-modified">{"Último registro"|x_translate} {$masa_corporal.fecha_peso_dp}</p>
                        {else}
                        <p class="last-modified label-sin-registros">{"Nunca ingreso registros"|x_translate}</p>
                        {/if}

                        
                    </div>
                </div>
                <div class="card-header" style="margin-top:130px;">
                    <h1 class="card-title">{"IMC"|x_translate}</h1>
                    <div class="card-value value">
                        <h2>{$masa_corporal.imc}</h2>
                    </div>
                </div>
            </div>
            <div class="col-md-6  col-xs-6">
                <div class="card-header">
                    <h1 class="card-title">{"Altura"|x_translate}</h1>
                    <div class="card-value value">
                        <h2>{if $masa_corporal.altura}{$masa_corporal.altura} {else}__{/if}</h2>
                        <p class="summary status-ok value">{if $masa_corporal.diferencia_altura}{$masa_corporal.diferencia_altura} {else}__{/if}</p>
                        
                        {if $masa_corporal.fecha_altura_dp != ""}
                        <p class="last-modified">{"Último registro"|x_translate} {$masa_corporal.fecha_altura_dp}</p>
                        {else}
                        <p class="last-modified label-sin-registros">{"Nunca ingreso registros"|x_translate}</p>
                        {/if}

                    </div>										
                </div>
                {if $paciente.edad_anio < 17}
                <button class="btn-search search" id="modal-400" data-modal="yes" style="margin-top:72px;">{"Ver Tablas de Percentillos"|x_translate}</button>
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

                <button class="btn-search search" id="modal-400" data-modal="yes_datos" style="margin-top:5px;">{"Ver Tablas de IMC"|x_translate}</button>
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
                {/if}
            </div>
        </div>

        <div class="bottom-data">
            <button class="edit dp-edit"  data-modal="yes_datos">{"Actualizar"|x_translate}</button>
            <div class="modal-edit-data hidden">
                <div class="edit-data patient w">
                    <button data-dismiss="modal" class="close dp-canceled"></button>
                    <h1>{"Índice de Masa Corporal"|x_translate}</h1>
                    <form class="edit patient-data" id="masa_corporal_form" action="{$url}save_masa_corporal_form_m.do" method="post" onsubmit="return false;">
                        <input type="hidden" name="paciente_idpaciente" value="{$idpaciente}" />
                        <input type="hidden" name="perfilSaludBiometricos_idperfilSaludBiometricos" value="{$perfil_salud_biometrico.idperfilSaludBiometricos}" />

                        <div class="form-group underline">
                            <label for="weight">{"Peso"|x_translate}</label>
                            <input class="pull-right" id="peso" name="peso" value="{$masa_corporal.peso}" type="number"> {"kg"|x_translate}
                        </div>
                        <div class="form-group underline">
                            <label for="size">{"Altura"|x_translate}</label>
                            <input class="pull-right" id="altura" name="altura" value="{$masa_corporal.altura}" type="number"> {"cm"|x_translate}
                        </div>
                        <div class="form-group">
                            <label class="checkbox ib" >
                                <input type="checkbox" checked="checked" id="status" data-toggle="checkbox" class="custom-checkbox">
                                {"Ver Estatus según IMC"|x_translate}
                            </label>
                        </div>
                        <input type="submit" onclick="submitFormMC();" value='{"grabar datos"|x_translate}'>
                    </form>
                </div>
            </div>
        </div>
    </div>
</article>
{literal}
<script>
    x_runJS();

    function submitFormMC() {

        $("#masa_corporal_form").validate({
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
                x_sendForm($('#masa_corporal_form'), true, function(data) {
                
                    if(data.result){
                        $(".modal.fade.in:visible").modal('toggle');
                        if ($("#idperfilSaludBiometricos").val() != "") {
                               x_alert(data.msg);
                            x_loadModule('perfil_salud', 'modulo_masa_corporal', 'idpaciente=' + $("#paciente_idpaciente").val(), "div_masa_corporal", BASE_PATH + "medico");
                       actualizar_menu_status_perfilsalud();
                    }else{
                               x_alert(data.msg,recargar);
                        };
                    }else{
                           x_alert(data.msg);
                    }
                });
            }
        });
    }


    $(document).ready(function() {

        $("#div_masa_corporal button[data-modal='yes_datos']").on('click', function(event) {

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


        $('#div_masa_corporal button[data-modal="yes"]').on('click', function(event) {

            var button = event.target;
            var objClass = $(this).attr('class');
            if ($(this).parent('ul') && $(this).parents('ul').attr('id')) {
                var menuOrigin = $(this).parents('ul').attr('id');
            }

            buttonTriggers(button, menuOrigin, objClass);
        });
    });
</script>
{/literal}
{if $smarty.request.print==1}
{literal}
<script>
    $(function () {
        /**Limpiamos todos los botones y comportamiento JS de la vista de impresion para que sea estatica
         * 
         */
        $(".dp-edit").remove();
        $(".vista-impresion a").click(function (e) {
            e.preventDefault();
        });
        $(".vista-impresion button:submit").remove();
    });
</script>
{/literal}
{/if}