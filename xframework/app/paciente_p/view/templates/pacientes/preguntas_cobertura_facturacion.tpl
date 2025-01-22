
<div class="okm-row" id="div_cobertura_facturacion" {if $paciente.titular!=1 && $paciente.pais_idpais!=1}style="display:none"{/if} >
    <div class="input-row" id="div_beneficia_ald">
        <div class="pul-col-x2">
            <label>{"Beneficia de afección de largo plazo?"|x_translate}</label>
        </div>
        <div class="pul-col-x2 check-holder" >
            <div class="col-md-4 col-xs-6">
                <label for="beneficia_ald_si" class="radio"><input type="radio" name="beneficia_ald" value="1" id="beneficia_ald_si" {if $paciente.beneficia_ald == "1"}checked{/if}>{"Si"|x_translate}</label>
            </div>
            <div class="col-md-4 col-xs-6">
                <label for="beneficia_ald_no" class="radio"><input type="radio" name="beneficia_ald" value="0" id="beneficia_ald_no" {if $paciente.beneficia_ald == "0"}checked{/if} >{"No"|x_translate}</label>
            </div>
            <div class="clearfix"></div>
        </div>


    </div>

    <div class="input-row" id="div_afeccion"  {if $paciente.beneficia_ald != "1"}style="display:none;"{/if}>
        <div class="pul-col-x2">
            <label>{"Cual es?"|x_translate}</label>
        </div>
        <div class="pul-col-x2">
            <div class="mapc-registro-form-row mapc-select pul-np-select">
                <select id="afeccion_idafeccion" name="afeccion_idafeccion"  class="form-control select select-primary select-block mbl" data-title="Seleccione la afección">
                    <option value="">{"Seleccione la afección"|x_translate}</option>
                    {html_options options=$combo_afeccion selected=$afeccion.idafeccion}
                </select>
            </div>
        </div>
    </div>

    <div class="input-row" id="div_beneficia_exempcion" {if $paciente.beneficia_exempcion == ""}style="display:none;"{/if}>
        <div class="pul-col-x2">
            <label>{"Beneficia de una exención?"|x_translate}</label>
        </div>
        <div class="pul-col-x2 check-holder" >
            <div class="col-md-4 col-xs-6">
                <label for="beneficia_exempcion_si" class="radio"><input type="radio" name="beneficia_exempcion" value="1" id="beneficia_exempcion_si" {if $paciente.beneficia_exempcion == "1"}checked{/if}>{"Si"|x_translate}</label>
            </div>
            <div class="col-md-4 col-xs-6">
                <label for="beneficia_exempcion_no" class="radio"><input type="radio" name="beneficia_exempcion" value="0" id="beneficia_exempcion_no" {if $paciente.beneficia_exempcion == "0"}checked{/if} >{"No"|x_translate}</label>
            </div>
            <div class="clearfix"></div>
        </div>


    </div>


    <div class="input-row" id="div_posee_cobertura" {if $paciente.posee_cobertura == ""}style="display:none;"{/if}>
        <div class="pul-col-x2">
            <label>{"Tiene una cobertura?"|x_translate}</label>
        </div>
        <div class="pul-col-x2 check-holder" >
            <div class="col-md-4 col-xs-6">
                <label for="posee_cobertura_si" class="radio"><input type="radio" name="posee_cobertura" value="1" id="posee_cobertura_si" {if $paciente.posee_cobertura == "1"}checked{/if}>{"Si"|x_translate}</label>
            </div>
            <div class="col-md-4 col-xs-6">
                <label for="posee_cobertura_no" class="radio"><input type="radio" name="posee_cobertura" value="0" id="posee_cobertura_no" {if $paciente.posee_cobertura == "0"}checked{/if} >{"No"|x_translate}</label>
            </div>
            <div class="clearfix"></div>
        </div>
    </div>

    <div class="input-row" id="div_obra_social" {if $paciente.posee_cobertura != "1"}style="display:none;"{/if}>
        <div class="pul-col-x2">
            <label>{"Cual es?"|x_translate}</label>
        </div>
        <div class="pul-col-x2">
            <div class="mapc-input-line">
                <input type="hidden" name="idobraSocial" id="idobraSocial" value="{$obra_social.idobraSocial}"/>
                <input  id="as_obra_social" name="as_obra_social" type="text" class="especialidad-input"  placeholder='{"Buscar cobertura médica"|x_translate}' data-title='{"Buscar cobertura médica"|x_translate}' value="{$obra_social.nombre}">

            </div>
        </div>
    </div>

</div>
<script>
    $(function () {
        $("#beneficia_ald_si").on('change.radiocheck', function () {
            $("#div_afeccion").slideDown();

            if ($("#afeccion_idafeccion").val() !== "") {
                $("#div_beneficia_exempcion").slideDown();
            }
            $("#div_beneficia_ald .select-required").removeClass("select-required").tooltip("destroy");

        });
        $("#afeccion_idafeccion").on("change", function () {
            if ($("#afeccion_idafeccion").val() !== "") {
                $("#div_beneficia_exempcion").slideDown();
                $("#div_afeccion .select-required").removeClass("select-required").tooltip("destroy");
            } else {
                $("#div_beneficia_exempcion").slideUp();
            }
        });

        $("#beneficia_ald_no").on('change.radiocheck', function () {
            $("#div_afeccion").slideUp();
            $("#div_beneficia_exempcion").slideDown();
            $("#div_beneficia_ald .select-required").removeClass("select-required").tooltip("destroy");

        });
        $("#beneficia_exempcion_si").on('change.radiocheck', function () {
            $("#div_posee_cobertura").slideDown();
            $("#div_beneficia_exempcion .select-required").removeClass("select-required").tooltip("destroy");

        });

        $("#beneficia_exempcion_no").on('change.radiocheck', function () {
            $("#div_posee_cobertura").slideDown();
            $("#div_beneficia_exempcion .select-required").removeClass("select-required").tooltip("destroy");

        });

        $("#posee_cobertura_si").on('change.radiocheck', function () {
            $("#div_obra_social").slideDown();
            if ($("#idobraSocial").val() !== "") {
                $("#div_medico_cabeza").slideDown();
            }
            $("#div_posee_cobertura .select-required").removeClass("select-required").tooltip("destroy");

        });

        $("#posee_cobertura_no").on('change.radiocheck', function () {
            $("#div_obra_social").slideUp();
            $("#div_medico_cabeza").slideDown();
            $("#div_posee_cobertura .select-required").removeClass("select-required").tooltip("destroy");

        });
        $("#idobraSocial").on("change", function () {
            if ($("#idobraSocial").val() !== "") {
                $("#div_medico_cabeza").slideDown();
                $("#div_obra_social .select-required").removeClass("select-required").tooltip("destroy");
            } else {
                $("#div_medico_cabeza").slideUp();
            }
        });

    });
</script>