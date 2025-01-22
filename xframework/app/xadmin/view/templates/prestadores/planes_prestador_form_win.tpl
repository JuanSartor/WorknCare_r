

<div class="xForm w750">
    <form action="{$controller}.php?action=1&modulo=prestadores&submodulo=planes_prestador_form_win"  method="post"  id="f_planes_prestador" >
        <input type="hidden" name="prestador_idprestador" value="{$smarty.request.idprestador}" />
        <input type="hidden" id="idplan_prestador" name="idplan_prestador" value="{$smarty.request.id}" />


        <div class="form_container">
            <div class="title">
                Datos del plan
            </div>
            <div class="top">&nbsp;</div>
            <ul>

                <li class="wide">
                    <label>Nombre </label> 
                    {x_form_input  id="nombre" name="nombre" descriptor="none" isRequired="true" maxChars=100 class="" value=$record.nombre} 
                </li>   
                <li class="right">
                    <label>Cantidad de Consultas Express </label> 
                    {x_form_input  id="cantidad_ce" name="cantidad_ce" descriptor="integer" isRequired="true" maxChars=100 class="" value=$record.cantidad_ce} 
                </li>  
                <li class="left">
                    <label>Cantidad de Video Consultas </label> 
                    {x_form_input  id="cantidad_vc" name="cantidad_vc" descriptor="integer" isRequired="true" maxChars=100 class="" value=$record.cantidad_vc} 
                </li>  





                <li class="clear"></li>
                <li class="wide ">  

                    {x_form_html_button id="back_hs" label="Volver" w="100" type="button" class="icon arrowleft"}
                    {x_form_html_button id="btnGuardarPlanPrestador" label="Agregar" w="100" type="button" class="icon save"}

                </li>
                <li class="clear"></li>

            </ul>


        </div>
    </form>
</div>






