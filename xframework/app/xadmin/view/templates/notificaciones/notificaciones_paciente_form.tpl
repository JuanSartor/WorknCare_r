<div id="colRight">

    <input type="hidden" id="list_actual_page" value="{$paginate.current_page}" />

    <div class="block">

        <div class="title_bar">
            <span class="text">NOTIFICACIONES PACIENTES &raquo; {if $record} EDITAR {else} NUEVA{/if} </span>

            {x_form_html_button id="btnGuardar" label="Enviar" w="100" type="button" class="icon save"}
            &nbsp;    
            {x_form_html_button id="back" label="Volver" w="100" type="button" class="icon arrowleft"}
        </div>
        <div class="top">
            &nbsp;
        </div>
        <div class="contenido">

            <div class="xForm">
                <form action="{$controller}.php?action=1&modulo=notificaciones&submodulo=notificaciones_paciente_form" target="_blank"  method="post"  name="f_record" id="f_record" >
                    <input type="hidden" name="idnotificacionSistema" id="idnotificacionSistema" value="{$record.idnotificacionSistema}" />
                    <input type="hidden" name="ids" id="ids" value="" />
                    <input type="hidden" name="is_notificacion_medico" id="is_notificacion_medico" value="0" />
                    
                    <div class="form_container">
                        <div class="title">
                            Ingrese los datos de la notificacion
                        </div>

                        <ul>
                            
                            <li class="wide">
                                <label>Título *</label>
                                {x_form_input  id="titulo" descriptor="none" isRequired="true" maxChars=100 class="" record=$record}
                            </li>
                            
                            <li class="wide">
                                <label>URL</label>
                                {x_form_input  id="url" descriptor="text" isRequired="false" maxChars=100 class="" record=$record}
                            </li>

                            <li class="wide">
                                <label>Texto</label>
                                {x_form_textarea  id="descripcion" name="descripcion" isRequired="false" rows=1 cols=70 class="" maxChars=1000 value=$record.descripcion}
                            </li>

                            <li class="clear"></li>
                            
                            <li class="left">
                                <label>Fecha Vencimiento</label>
                                {x_form_date date_format="%d/%m/%Y"  input_format = "dd/mm/yyyy" input_name="fechaVencimiento" isRequired="false" value=$record.fechaVencimiento|date_format:"%d/%m/%Y"}
                            </li>

                            <li class="clear"></li>

                        </ul>

                    </div>
                </form>
            </div>
            
            <div class="xForm">
                <form action="{$controller}.php?action=1&modulo=notificaciones&submodulo=notificaciones_paciente_form_list" target="_blank"  method="post"  name="f_busqueda" id="f_busqueda" >
                    <input type="hidden" name="idnotificacionSistema" value="{$record.idnotificacionSistema}" />
                    <div class="form_container">
                        <div class="title">
                            Pacientes a Notificar
                        </div>

                        <ul>

                            <li class="wide">
                                <label>Nombre</label>
                                {x_form_input  id="nombre" descriptor="none" isRequired="false" maxChars=30 class="" record=$record}
                            </li>

                            <li class="clear"></li>
                            
                            <li class="left">
                                <label>Apellido</label>
                                {x_form_input  id="apellido" descriptor="none" isRequired="false" maxChars=30 class="" record=$record}
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