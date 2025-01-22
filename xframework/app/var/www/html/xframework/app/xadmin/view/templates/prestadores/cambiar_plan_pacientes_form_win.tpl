<div id="colRight">	
    <div class="block">

        <div class="top">&nbsp;</div>
        <div class="xForm">
            <form action="{$controller}.php?action=1&modulo=prestadores&submodulo=cambiar_plan_pacientes_form_win"  method="post"  id="f_cambiar_plan" >
                <input type="hidden"   name="idprestador" value="{$smarty.request.idprestador}" />

                <input type="hidden"  id="ids_paciente" name="ids" value="" />
                <div class="form_container">     
                    <div class="title">
                        Cambiar plan
                    </div>

                    <ul>
                        <li class="left">
                            <label>Asignar el plan: </label> 
                            <select class="" name="plan_prestador_idplan_prestador" id="plan_prestador_idplan_prestador">
                                <option value="">Seleccione...</option>
                                {html_options options=$combo_plan_prestador }
                            </select>                     
                        </li>   
                         <li class="clear"></li>
                    </ul>
                </div>
        </div>  
        <div class="top">&nbsp;</div>
        {x_form_html_button id="back_hs" label="Volver" w="100" type="button" class="icon arrowleft"} &nbsp;
        {x_form_html_button id="btnCambiarPlan" label="Cambiar plan" w="100" type="button" class="icon save"}

   </div> 
</div> 





