<div id="colRight">	

    <input type="hidden" id="list_actual_page_3" value="{$paginate.current_page}" />


    <div class="block">


        <div class="top">&nbsp;</div>


        <div class="xForm">
            <form action="{$controller}.php?action=1&modulo=prestadores&submodulo=pacientes_list"  method="post"  id="f_busqueda_pacientes" >
                <input type="hidden"  id="idprestador_busqueda_pacientes" name="idprestador" value="{$smarty.request.idprestador}" />


                <div class="form_container">
                    <div class="title">
                        Pacientes
                    </div>

                    <ul>

                        <li class="left">
                            <label>BUSQUEDA </label> 
                            {x_form_input  id="busqueda_pacientes" name="busqueda" descriptor="none" isRequired="false" maxChars=50 class="" value=$paginate.request.nombre} 
                        </li>   


                        <li class="clear"></li>
                        <li class="wide">           
                            {x_form_html_button id="btnFilterBusquedaPacientes" label="Buscar" class="icon search" w="100" type="button"} 

                            {x_form_html_button id="btnLimpiarBusquedaPacientes" label="Limpiar" class="icon loop" w="100" type="button"} 

                        </li>
                        <li class="clear"></li>


                    </ul>


                </div>
            </form>
        </div>

        <div  class="xTable" id="xTable">
            <div class="container">		
                <table id="list_busqueda_paciente">
                </table> 

                <div id="pager_busqueda_paciente"></div>

            </div>     


        </div> 


        <div class="xForm">
            <form action="{$controller}.php?action=1&modulo=prestadores&submodulo=pacientes_prestador_form_win"  method="post"  id="f_pacientes_prestador" >
                <input type="hidden"   name="idprestador" value="{$smarty.request.idprestador}" />

                <input type="hidden"  id="ids_paciente" name="ids" value="" />
                <div class="form_container">     
                    <ul>
                        <li class="left">
                            <label>Asignar el plan: </label> 
                            <select class="" name="plan_prestador_idplan_prestador" id="plan_prestador_idplan_prestador">
                                <option value="">Seleccione...</option>
                                {html_options options=$combo_plan_prestador }
                            </select>                     
                        </li>   
                    </ul>
                </div>
            </form>

        </div>  
        <div class="top">&nbsp;</div>

        {x_form_html_button id="back_hs" label="Volver" w="100" type="button" class="icon arrowleft"} &nbsp;
        {x_form_html_button id="btnGuardarPacientePrestador" label="Agregar" w="100" type="button" class="icon save"}

    </div> 


</div> 





