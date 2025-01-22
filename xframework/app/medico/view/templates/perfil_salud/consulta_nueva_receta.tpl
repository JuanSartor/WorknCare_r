         
{if $videoconsulta}
    <!-- /tab receta -->
    <div role="tabpanel" class="w tab-pane fade" id="agregar-receta">
        <div class="form-content">
            <h4><strong>{"Prescripcion"|x_translate}</strong> <em>({"Opcional"|x_translate})</em></h4>

            <div id="div_add_receta" class="estudio-imagenes-files">
            </div>

            {literal}
                <script>
                    $(document).ready(function () {
                        x_loadModule('perfil_salud', 'add_archivos_receta', 'id=' + $("#idpaciente").val() + "&idperfilSaludConsulta=" + $("#idperfilSaludConsulta").val(), 'div_add_receta', BASE_PATH + "medico");
                    });
                </script>
            {/literal}



            <div class="estudio-imagenes-grid nueva-consulta-grid" id="div_archivos_receta">

            </div>		

            {literal}
                <script>
                    $(document).ready(function () {
                        x_loadModule('perfil_salud', 'list_archivos_receta_nueva', 'id=' + $("#idpaciente").val() + "&idperfilSaludConsulta=" + $("#idperfilSaludConsulta").val(), 'div_archivos_receta', BASE_PATH + "medico");
                    });
                </script>
            {/literal}
            <div class="text-center"> 

                <p>{"Tiene que crear la receta usando su software homologado para generar recetas y  crear un PDF en lugar de imprimirla."|x_translate}</p> 
                <p>{"Adjunte el PDF, generaremos una receta electrónica que la farmacia podrá verificar antes de entregar los medicamentos recetados."|x_translate}</p>
                <p><strong>{"CUIDADO: su prescripción tiene que cumplir con todos los requisitos legales para ser valida (RPPS, AM, etc...)"|x_translate}</strong></p>

            </div>
            <div class="clearfix">&nbsp;</div>



        </div>						
    </div>
    <!-- /tab receta -->
{/if}