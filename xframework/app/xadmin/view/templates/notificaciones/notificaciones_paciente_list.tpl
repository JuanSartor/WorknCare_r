<div id="colRight">

    <input type="hidden" id="list_actual_page" value="{$paginate.current_page}" />

    <div class="block">

        <div class="title_bar">
            <span class="text">NOTIFICACIONES PACIENTES &raquo; LISTADO </span>

            {x_form_html_button id="btnNew" label="Nuevo" w="100" type="button" class="icon add"}&nbsp;

        </div>
        <div class="top">
            &nbsp;
        </div>
        <div class="contenido">

            <div class="xForm">
                <form action="{$controller}.php?action=1&modulo=notificaciones&submodulo=notificaciones_paciente_list" target="_blank"  method="post"  name="f_busqueda" id="f_busqueda" >
                    
                    <div class="form_container">
                        <div class="title">
                            Consulta de Notificaciones de pacientes
                        </div>

                        <ul>

                            <li class="wide">
                                <label>Texto</label>
                                {x_form_textarea  id="descripcion" name="descripcion" isRequired="false" rows=1 cols=70 class="" maxChars=1000 value=$paginate.request.texto}
                            </li>

                            <li class="clear"></li>
                            
                            <li class="left">
                                <label>Fecha Creación</label>
                                {x_form_date date_format="%d/%m/%Y"  input_format = "dd/mm/yyyy" input_name="fechaNotificacion" isRequired="false" value=$paginate.request.fechaNotificacion}
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