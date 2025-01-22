<div id="colRight">	

    <input type="hidden" id="list_actual_page" value="{$paginate.current_page}" />

    <div class="block">

        <div class="title_bar"><span class="text">LISTADO DE REEMBOLSOS &raquo; </span>



        </div>    
        <div class="top">&nbsp;</div>
        <div class="contenido">

            <div class="xForm">
                <form action="{$controller}.php?action=1&modulo=contable&submodulo=reembolsos_list" target="_blank"  method="post"  name="f_busqueda" id="f_busqueda" >

                    <div class="form_container">
                        <div class="title">
                            Reembolsos 
                        </div>

                        <ul>

                            <li class="left">
                                <label>Nombre Beneficiario </label> 
                                {x_form_input  id="nombre_beneficiario" descriptor="none" isRequired="false" maxChars=45 class="" value=$paginate.request.nombre_beneficiario} 
                            </li> 
                            <li class="right">
                                <label>Apellido Beneficiario </label> 
                                {x_form_input  id="apellido_beneficiario" descriptor="none" isRequired="false" maxChars=45 class="" value=$paginate.request.apellido_beneficiario} 
                            </li> 
                            <li class="left">
                                <label>Programa </label> 
                                {x_form_input  id="nombre_programa" descriptor="none" isRequired="false" maxChars=45 class="" value=$paginate.request.nombre_empresa} 
                            </li>  
                            <li class="right">
                                <label>IBAN </label> 
                                {x_form_input  id="iban" descriptor="none" isRequired="false" maxChars=45 class="" value=$paginate.request.iban} 
                            </li> 
                            <li class="left">
                                <label>Empresa </label> 
                                {x_form_input  id="empresa" descriptor="none" isRequired="false" maxChars=45 class="" value=$paginate.request.iban} 
                            </li> 
                            <li class="right">
                                <label>Estado </label> 
                                <select name="estado" id="estado" class="">
                                    <option value="">Seleccionar...</option>
                                    <option value="0">Pendiente Validacion</option>
                                    <option value="2">Rechazado</option>
                                    <option value="1">Validado</option>
                                </select>   
                            </li>

                            <li class="clear"></li>
                            <li class="wide">           
                                {x_form_html_button id="btnFilter" label="Buscar" class="icon search" w="100" type="button"} 

                                {x_form_html_button id="btnLimpiar" label="Limpiar" class="icon loop" w="100" type="button"} 
                            </li>
                            <li class="clear"></li>
                        </ul>
                    </div>
                </form>
            </div>


            <div class="clear"> </div>                    

            <div class="separator">&nbsp;</div>
            <div  class="xTable" id="xTable">
                <div class="container">	

                    <div class="clearfix"></div>
                    <table id="list">
                    </table> 
                    <div id="pager"></div>
                </div>     
            </div> 
        </div>
        <div class="end">&nbsp;</div>
    </div>         
</div>