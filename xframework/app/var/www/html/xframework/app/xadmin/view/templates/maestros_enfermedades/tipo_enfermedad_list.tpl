<div id="colRight">

    <input type="hidden" id="list_actual_page" value="{$paginate.current_page}" />

    <div class="block">

        <div class="title_bar">
            <span class="text">ENFERMEDAD &raquo; TIPO ENFERMEDAD &raquo; </span>

            {x_form_html_button id="btnNew" label="Nuevo" w="100" type="button" class="icon add"}&nbsp;
            
            {x_form_html_button id="back" label="Volver" w="100" type="button" class="icon arrowleft"}

        </div>
        <div class="top">
            &nbsp;
        </div>
        <div class="contenido">

            <div class="xForm">
                <form action="{$controller}.php?action=1&modulo=maestros_enfermedades&submodulo=tipo_enfermedad_list" target="_blank"  method="post"  name="f_busqueda" id="f_busqueda" >
                    <input type="hidden" name="enfermedad_idenfermedad" id="enfermedad_idenfermedad" value="{$enfermedad.idenfermedad}" />

                    <div class="form_container">
                        <div class="title">
                            Consulta de Tipo de Enfermedad
                        </div>

                        <ul>

                            <li class="wide">
                                <label>Enfermedad</label>
                                <span class="lbl" id="pre_id" >{$enfermedad.enfermedad}</span>
                            </li>
                            
                            
                            <li class="wide">
                                <label>Tipo Enfermedad * </label> 
                                {x_form_input  id="tipoEnfermedad" descriptor="none" isRequired="true" maxChars=45 class="" record=$record} 
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

                    <table id="list"></table>

                    <div id="pager"></div>

                </div>

            </div>
        </div>
        <div class="end">
            &nbsp;
        </div>
    </div>

</div>