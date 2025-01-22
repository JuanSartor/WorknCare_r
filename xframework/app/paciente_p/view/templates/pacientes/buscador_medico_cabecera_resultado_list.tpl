
{foreach from=$listado_medicos.rows item=medico}
    <div class="item-medico-cabecera">

        <div class="okm-row ">
            <div class="check-medico-cabecera" >    
                <label class="checkbox">
                    <input type="checkbox" name="idmedico-cabecera" class="select-medico-cabecera" value="{$medico.idmedico}">
                </label>

            </div>
            <div class="medico-cabecera-data-col" >


                <div class="img-medico-cabecera">
                    <a href="{$url}recherche-medecin/professionnels/{$medico.idmedico}-{$medico.nombre|str2seo}-{$medico.apellido|str2seo}.html">
                        {if $medico.imagen.list != ""}
                            <img src="{$medico.imagen.list}" alt="{$medico.titulo_profesional} {$medico.nombre} {$medico.apellido}"  /> 
                        {else}
                            <img src="{$IMGS}extranet/noimage_perfil.png" alt="{$medico.titulo_profesional} {$medico.nombre} {$medico.apellido}"      />
                        {/if}
                    </a>
                </div>
                <div class="medico-cabecera-data">
                    <h3>
                        <a href="{$url}recherche-medecin/professionnels/{$medico.idmedico}-{$medico.nombre|str2seo}-{$medico.apellido|str2seo}.html">{$medico.titulo_profesional} {$medico.nombre} {$medico.apellido}</a>
                    </h3>
                    <h4>{$medico.especialidad.0.especialidad}</h4>
                    {if $medico.direccion_iddireccion!=""}
                        <p>
                            {$medico.direccion|ucfirst} {$medico.numero},  {$medico.localidad|lower|ucfirst}, {$medico.pais}
                        </p>
                    {/if}
                </div>
            </div>
        </div>
    </div>
{foreachelse}
    <div class="item-medico-cabecera">
        <div class="okm-row ">
            <div class="col-xs-12">
                <small class="red">{"No se ha encontrado su médico de cabecera"|x_translate}</small>
            </div>
             <div class="col-xs-12">
                <label for="medico_cabeza_externo" class="checkbox"><input type="checkbox" name="medico_cabeza_externo" value="1" id="medico_cabeza_externo" {if $paciente.medico_cabeza_externo == "1"}checked{/if}>{"Tengo un médico de cabecera que no se encuentra en Doctor Plus"|x_translate}</label>
            </div>
        </div>
    </div>
{/foreach}
<script>
    $(':checkbox').radiocheck();
    $(".select-medico-cabecera").on('click', function () {
        var selected = $(this).context.value;
        if (selected) {
            $(".select-medico-cabecera:checked[value!=" + selected + "]").radiocheck('uncheck');
            if ($("#idmedico_cabecera").length && $("#idmedico_cabecera").length !== "") {
                x_alert("Error. Ya posee un médico de cabecera");
                return false;
            }
            jConfirm({
                title: x_translate("Seleccionar médico de cabecera"),
                text: x_translate('Está por agregar el profesional como médico de cabecera en su lista de profesionales frecuentes. ¿Desea continuar?'),
                confirm: function () {

                    $("body").spin("large");
                    x_doAjaxCall(
                            'POST',
                            BASE_PATH + 'agregar_medico_cabecera.do',
                            'idmedico=' + selected,
                            function (data) {

                                if (data.result) {
                                    x_loadModule('pacientes', 'buscador_medico_cabecera', '', 'buscador_medico_cabecera_container').then(function () {
                                        $("body").spin(false);
                                    });
                                } else {
                                    $("body").spin(false);
                                    x_alert(data.msg);
                                }
                            }

                    );
                },
                cancel: function () {
                    $(".select-medico-cabecera:checked").radiocheck('uncheck');
                },
                confirmButton: x_translate("Si"),
                cancelButton: x_translate("No")
            });

        }
    });


</script>
