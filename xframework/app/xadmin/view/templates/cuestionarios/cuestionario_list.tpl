<div id="colRight">	

    <input type="hidden" id="list_actual_page" value="{$paginate.current_page}" />

    <div class="block">

        <div class="title_bar"><span class="text">	Cuestionarios&raquo; </span>

            {x_form_html_button id="btnNew" label="Nuevo" w="100" type="button" class="icon add"}&nbsp;

        </div>    

        <div class="top">&nbsp;</div>
        <div class="contenido">

            <div class="xForm">

                <form action="{$controller}.php?action=1&modulo=cuestionarios&submodulo=cuestionario_list" target="_blank"  method="post"  name="f_busqueda" id="f_busqueda" >

                    <div class="form_container">
                        <div class="title">
                            Consulta de Cuestionarios
                        </div>

                        <ul>

                            <li class="left">
                                <label>Titulo </label> 
                                {x_form_input  id="titulo" descriptor="none" isRequired="false" maxChars=45 class="" value=$paginate.request.titulo} 
                            </li>  
                            <li class="right">
                                <label>Empresa</label> 
                                {x_form_input  id="empresa" descriptor="none" isRequired="false" maxChars=45 class="" value=$paginate.request.empresa} 
                            </li> 
                            <li class="right checkbox-inline">
                                <label class="">{"GENERICOS"|x_translate}</label> 
                                {x_form_boolean  label_yes='OUI' label_no='NON' value_yes=1 value_no=0 checked=0  name="generico" id="visible"}
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

            <div  class="xTable" id="xTable">
                <div class="container">		

                    <table id="list">
                    </table> 

                    <div id="pager"></div>

                </div>     
            </div> 
        </div>
        <div class="end">&nbsp;</div>
    </div>         
</div>