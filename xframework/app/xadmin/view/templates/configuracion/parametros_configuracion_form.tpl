<style>
    .xForm label {
        width: 400px !important;
    }
    .xForm .wide input {
        width: 200px;
    }
</style>
<div id="colRight">



    <div class="block">

        <div class="title_bar"><div class="text">Configuración del sistema</div>   

            {x_form_html_button id="btnGuardar" label="Guardar" w="100" type="button" class="icon save"}
            &nbsp;    
            {x_form_html_button id="back" label="Volver" w="100" type="button" class="icon arrowleft"}
        </div>
        <div class="top">&nbsp;</div>
        <div class="contenido">

            <input type="hidden" name="paramsReload" id="paramsReload" value="" />
            <input type="hidden" name="paramsReloadWindow" id="paramsReloadWindow" value="" />          

            <div class="xForm ">
                <form action="{$controller}.php?action=1&modulo=configuracion&submodulo=parametros_configuracion_form"  method="post"  name="f_record" id="f_record" >

                    <div class="form_container ">
                        <div class="title">Tarifa Profesional </div>
                        <ul>

                            <li class="wide">
                                <label>Tarifa abono (EUR)</label> 
                                {x_form_input  id="MONTO_CUOTA" descriptor="integer" isRequired="true" maxChars=11 class="" value=$MONTO_CUOTA} 
                            </li>  

                        </ul>

                        <div class="clear">&nbsp;</div> 

                    </div>

                    <div class="form_container ">
                        <div class="title">Duracion de consultas </div>
                        <ul>

                            <li class="wide">
                                <label>Duración de videoconsulta (minutos)</label> 
                                {x_form_input  id="VIDEOCONSULTA_DURACION" descriptor="integer" isRequired="true" maxChars=11 class="" value=$VIDEOCONSULTA_DURACION} 
                            </li> 
                            <li class="wide">
                                <label>Vencimiento de sala videoconsulta (minutos)</label> 
                                {x_form_input  id="VIDEOCONSULTA_VENCIMIENTO_SALA" descriptor="integer" isRequired="true" maxChars=11 class="" value=$VIDEOCONSULTA_VENCIMIENTO_SALA} 
                            </li> 
                            <li class="wide">
                                <label>Notificar medico demoraro en sala  (minutos)</label> 
                                {x_form_input  id="VIDEOCONSULTA_NOTIFICAR_MEDICO_DEMORADO" descriptor="integer" isRequired="true" maxChars=11 class="" value=$VIDEOCONSULTA_NOTIFICAR_MEDICO_DEMORADO} 
                            </li>
                            <li class="wide">
                                <label>Duración videoconsulta pendiente de finalización (horas)</label> 
                                {x_form_input  id="VIDEOCONSULTA_HORAS_PENDIENTE_FINALIZACION" descriptor="integer" isRequired="true" maxChars=11 class="" value=$VIDEOCONSULTA_HORAS_PENDIENTE_FINALIZACION} 
                            </li> 
                            <li class="wide">
                                <label>Duración videoconsulta pendiente - Particular  (horas)</label> 
                                {x_form_input  id="VENCIMIENTO_VC_FRECUENTES" descriptor="integer" isRequired="true" maxChars=11 class="" value=$VENCIMIENTO_VC_FRECUENTES} 
                            </li>
                            <li class="wide">
                                <label>Duración de videoconsulta pendiente - RED  (horas)</label> 
                                {x_form_input  id="VENCIMIENTO_VC_RED" descriptor="integer" isRequired="true" maxChars=11 class="" value=$VENCIMIENTO_VC_RED} 
                            </li>

                        </ul>

                        <div class="clear">&nbsp;</div> 

                    </div>

                    <div class="form_container ">
                        <div class="title">Tarifas de consultas </div>
                        <ul>
                            <!--  
                                "COMISION_CE",
                                "COMISION_VC",
                            -->
                            <li class="wide">
                                <label>Tarifa minima Consejo (EUR)</label> 
                                {x_form_input  id="PRECIO_MINIMO_CE" descriptor="integer" isRequired="true" maxChars=11 class="" value=$PRECIO_MINIMO_CE} 
                            </li>
                            <li class="wide">
                                <label>Tarifa máxima Consejo (EUR)</label> 
                                {x_form_input  id="PRECIO_MAXIMO_CE" descriptor="integer" isRequired="true" maxChars=11 class="" value=$PRECIO_MAXIMO_CE} 
                            </li>
                            <li class="wide">
                                <label>Tarifa minima Video Consulta (EUR)</label> 
                                {x_form_input  id="PRECIO_MINIMO_VC" descriptor="integer" isRequired="true" maxChars=11 class="" value=$PRECIO_MINIMO_VC} 
                            </li>
                            <li class="wide">
                                <label>Tarifa máxima Video Consulta (EUR)</label> 
                                {x_form_input  id="PRECIO_MAXIMO_VC" descriptor="integer" isRequired="true" maxChars=11 class="" value=$PRECIO_MAXIMO_VC} 
                            </li>
                            <li class="wide">
                                <label>Tarifa minima Video Consulta con Turno (EUR)</label> 
                                {x_form_input  id="PRECIO_MINIMO_VC_TURNO" descriptor="integer" isRequired="true" maxChars=11 class="" value=$PRECIO_MINIMO_VC_TURNO} 
                            </li>
                            <li class="wide">
                                <label>Tarifa máxima Video Consulta  con Turno (EUR)</label> 
                                {x_form_input  id="PRECIO_MAXIMO_VC_TURNO" descriptor="integer" isRequired="true" maxChars=11 class="" value=$PRECIO_MAXIMO_VC_TURNO} 
                            </li>
                            <li class="wide">
                                <label>Comisión Doctorplus Consejo (EUR)</label> 
                                {x_form_input  id="COMISION_CE" descriptor="integer" isRequired="true" maxChars=11 class="" value=$COMISION_CE} 
                            </li>
                            <li class="wide">
                                <label>Comisión Doctorplus Video Consulta (EUR)</label> 
                                {x_form_input  id="COMISION_VC" descriptor="integer" isRequired="true" maxChars=11 class="" value=$COMISION_VC} 
                            </li>

                        </ul>

                        <div class="clear">&nbsp;</div> 

                    </div>


                    <div class="clear">&nbsp;</div>


                </form>
            </div> 
        </div>  
        <div class="end">&nbsp;</div> 
    </div>   
</div>

{literal}
    <script>
        $(function () {
            x_runJS();

            $("#btnGuardar").click(function () {

                x_sendForm(
                        $('#f_record'),
                        true,
                        function (data) {
                            x_alert(data.msg);
                        }
                );
            });
            $("#back").click(function () {
                x_goTo('home', 'home', '', 'Main', this);
            });




        })
    </script>
{/literal}