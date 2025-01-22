<style>
    /*Buscador medico cabeza*/
    .medico-cabecera-container{
        margin-bottom: 30px;
    }
    .mapc-input-line.input-group input{
        width: 70%;

        display: inline-block;
    }
    .mapc-input-line.input-group .input-group-btn button{
        width: 30%;
        line-height: inherit;
        height: 100%;
        display: inline-block;
        position: absolute;
        top:0px;
        background: #21b797;
        border: 1px solid #69aaac;
        padding: 10px 15px;
    }


    .item-medico-cabecera{
        margin-bottom: 16px;
    }

    .medico-cabecera-data h3 {
        margin: 0;
        padding: 0 0 2px;
        font-size: 16px;
        line-height: 18px;
        color: #415b70;
    }

    .medico-cabecera-data h4 {
        margin: 0;
        padding: 0 0 4px;
        font-size: 16px;
        line-height: 18px;
        color: #1ABCA1;
        font-weight: 400;
    }
    .medico-cabecera-data p {
        font-size: 14px;
        line-height: 16px;
        color: #78909C;
        display: block;
        max-width: 450px;
        margin: 0;
    }
    .img-medico-cabecera,.medico-cabecera-data,.check-medico-cabecera,.medico-cabecera-data-col{
        display:inline-block;
        vertical-align: middle;
    }
    @media(max-width: 600px){
        .medico-cabecera-data,.img-medico-cabecera {
            display: block;
            text-align: center;
        }
    }
    .check-medico-cabecera label.checkbox{
        display:inline-block;
    }
    .img-medico-cabecera img{
        border-radius:50%;
        width:60px;
    }
    .eliminar-medico-cabecera{
        margin-right:10px;
        color:#f33243;
    }

</style>
<div class="medico-cabecera-container">
    <!-- Medico de cabeza-->
    <div class="input-row" id="div_medico_cabeza" >
        <div class="pul-col-x2">
            <label>{"Tiene médico de cabeza?"|x_translate}</label>
        </div>
        {if $posee_medico_cabecera==1}
            <input type="hidden" value="1" name="medico_cabeza"/>
        {/if}
        <div class="pul-col-x2 check-holder" >
            <div class="col-md-4 col-xs-6">
                <label for="medico_cabeza_si" class="radio"><input type="radio" name="medico_cabeza" value="1" id="medico_cabeza_si" {if $paciente.medico_cabeza == "1" || $posee_medico_cabecera==1}checked{/if}>{"Si"|x_translate}</label>
            </div>
            <div class="col-md-4 col-xs-6">
                <label for="medico_cabeza_no" class="radio"><input type="radio"  name="medico_cabeza" value="0" id="medico_cabeza_no" {if $paciente.medico_cabeza == "0" && $posee_medico_cabecera!=1}checked{/if} >{"No"|x_translate}</label>
            </div>
            <div class="clearfix"></div>
        </div>
    </div>

    <div class="okm-row" id="medico_cabecera_seleccionado">
        {if $medico_cabecera}
            <input type="hidden" id="idmedico_cabecera" value="{$medico_cabecera.idmedico}">
            <div class="check-medico-cabecera">
                <button class="fui-trash eliminar-medico-cabecera" data-id='{$medico_cabecera.idmedico}' title='{"Eliminar"|x_translate}'></button>
            </div>
            <div class="medico-cabecera-data-col" >
                <div class="img-medico-cabecera">
                    <a href="{$url}recherche-medecin/professionnels/{$medico_cabecera.idmedico}-{$medico_cabecera.nombre|str2seo}-{$medico_cabecera.apellido|str2seo}.html">
                        {if $medico_cabecera.images.list != ""}
                            <img src="{$medico_cabecera.images.list}" alt="{$medico_cabecera.tituloprofesional} {$medico_cabecera.nombre} {$medico_cabecera.apellido}"
                                 /> 
                        {else}
                            <img src="{$IMGS}extranet/noimage_perfil.png" alt="{$medico_cabecera.tituloprofesional} {$medico_cabecera.nombre} {$medico_cabecera.apellido}"
                                 />
                        {/if}
                    </a>
                </div>
                <div class="medico-cabecera-data">
                    <h3>
                        <a href="{$url}recherche-medecin/professionnels/{$medico_cabecera.idmedico}-{$medico_cabecera.nombre|str2seo}-{$medico_cabecera.apellido|str2seo}.html">{$medico_cabecera.tituloprofesional} {$medico_cabecera.nombre} {$medico_cabecera.apellido}</a>
                    </h3>
                    <h4>{$medico_cabecera.mis_especialidades.0.especialidad}</h4>
                    {if $medico_cabecera.direccion_iddireccion!=""}
                        <p>
                            {$medico_cabecera.direccion.direccion|ucfirst} {$medico_cabecera.direccion.numero},  {$medico_cabecera.direccion.localidad_corta|lower|ucfirst}, {$medico_cabecera.direccion.pais}
                        </p>
                    {/if}
                </div>
            </div>
        {/if}
    </div>

    <div class="input-row" id="div_buscador_medico_cabecera" {if $paciente.medico_cabeza == "1" && !$medico_cabecera}style="display:block;"{else}style="display:none;"{/if}>

        <div class="pul-col-x2">
            <div class="mapc-input-line input-group">
                <input  id="nombre_medico_cabecera" type="text"  placeholder='{"Apellido"|x_translate}'>
                <span class="input-group-btn">
                    <button class="btn btn-default" type="button" id="buscar_medico_cabecera" >{"buscar"|x_translate}</button>
                </span>
            </div>
        </div>
    </div>
    <div id="div_buscador_medico_cabecera_resultado_list">

    </div>
</div>
{literal}
    <script>
        $(function () {
            $(":radio").radiocheck();
            $(":checkbox").radiocheck();

            /*if ("#medico_cabeza_si").is(":checked"){
             $("#div_buscador_medico_cabecera").show();
             }*/
            //buscar medico de cabeza
            $("#buscar_medico_cabecera").click(function () {
                if ($("#nombre_medico_cabecera").val() !== "") {
                    $(".medico-cabecera-container").spin("large");
                    x_loadModule('pacientes', 'buscador_medico_cabecera_resultado_list', 'medico_ti=' + $("#nombre_medico_cabecera").val(), 'div_buscador_medico_cabecera_resultado_list').then(function () {
                        $(".medico-cabecera-container").spin(false);
                    });
                }

            });
            //quitar medico de cabeza

            $("#medico_cabeza_no").on('change.radiocheck', function () {
                if ($(".eliminar-medico-cabecera").length > 0) {
                    $(".eliminar-medico-cabecera").trigger("click");
                }

                $("#div_buscador_medico_cabecera_resultado_list").empty();
                $("#div_buscador_medico_cabecera").slideUp();
                $("#div_medico_cabeza .select-required").removeClass("select-required").tooltip("destroy");

            });
            $(".eliminar-medico-cabecera").click(function () {

                $element = $(this);
                var id = $(this).data('id');

                jConfirm({
                    title: x_translate("Eliminar médico de cabecera"),
                    text: x_translate('Está por eliminar el profesional como médico de cabecera. Permanecerá en su lista de profesionales frecuentes. ¿Desea continuar?'),
                    confirm: function () {

                        $("body").spin("large");
                        x_doAjaxCall(
                                'POST',
                                BASE_PATH + 'eliminar_medico_cabecera.do',
                                'idmedico=' + id,
                                function (data) {
                                    $("body").spin(false);
                                    if (data.result) {
                                        $("#medico_cabeza_no").prop("checked", true)
                                        $("#medico_cabecera_seleccionado").empty();

                                    } else {
                                        x_alert(data.msg);
                                    }
                                }

                        );
                    },
                    cancel: function () {
                        $("#medico_cabeza_si").radiocheck("check");
                    },
                    confirmButton: x_translate("Si"),
                    cancelButton: x_translate("No")
                });


            });

            //mostrar buscador
            $("#medico_cabeza_si").on('change.radiocheck', function () {
                $("#div_buscador_medico_cabecera").slideDown();
                $("#div_medico_cabeza .select-required").removeClass("select-required").tooltip("destroy");
            });
        });
    </script>

{/literal}