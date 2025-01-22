
<div role="tabpanel" class="w tab-pane fade" id="agregar-archivo">
    <div class="form-content">
        <h4><strong>{"Archivos adjuntos"|x_translate}</strong> <em>({"Opcional"|x_translate})</em></h4>
        <div id="div_add_archivos" class="estudio-imagenes-files">
        </div>

        {literal}
            <script>
                $(document).ready(function () {
                    x_loadModule('perfil_salud', 'add_archivos_estudios', 'id=' + $("#idpaciente").val() + "&idperfilSaludConsulta=" + $("#idperfilSaludConsulta").val(), 'div_add_archivos', BASE_PATH + "medico");
                });
            </script>
        {/literal}



        <div class="estudio-imagenes-grid nueva-consulta-grid" id="div_archivos_consulta">

        </div>		

        {literal}
            <script>
                $(document).ready(function () {
                    x_loadModule('perfil_salud', 'list_archivos_consulta_nueva', 'id=' + $("#idpaciente").val() + "&idperfilSaludConsulta=" + $("#idperfilSaludConsulta").val(), 'div_archivos_consulta', BASE_PATH + "medico");
                });
            </script>
        {/literal}
        <br>
        <div class="text-center">
            <p>{"Le puede interesar adjuntar la ampliación de historia clínica y estudios complementarios que certifiquen el diagnóstico"|x_translate}</p> 
            <p>{"Los archivos intercambiados con el paciente durante la consulta se adjuntaran a este informe médico"|x_translate}</p>
        </div>
        <div class="clearfix">&nbsp;</div>

    </div>						
</div>
