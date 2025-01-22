<style>
    .agregar_menu{
        position: absolute;
        overflow: visible;
        display: inline-block;
        padding: 0.5em 1em;
        border: 1px solid #B80C1D;
        border-radius: 5px;
        margin: 0;
        text-decoration: none;
        text-align: center;
        text-shadow: -1px -1px 0 rgba(0,0,0,0.3);
        font: 11px/normal sans-serif;
        color: #FFF;
        white-space: nowrap;
        cursor: pointer;
        outline: none;
        background-color: #D00D20;
    }
    .delete_menu{
        position: relative;
        overflow: visible;
        display: inline-block;
        padding: 0.5em ;
        border-radius: 5px;
        border: 1px solid #B80C1D;
        margin: 0;
        text-decoration: none;
        text-align: center;
        text-shadow: -1px -1px 0 rgba(0,0,0,0.3);
        font: 11px/normal sans-serif;
        color: #FFF;
        white-space: nowrap;
        cursor: pointer;
        outline: none;
        background-color: #D00D20;
    }
</style>
<div id="colRight">


    <div class="block">

        <div class="title_bar"><div class="text">USUARIOS &raquo; {if $record}EDITAR USUARIO{else}NUEVO USUARIO{/if} </div>   

            {x_form_html_button id="btnGuardar" label="Guardar" w="100" type="button" class="icon save"}
            &nbsp;

            {x_form_html_button id="new" label="Volver" function_name="x_goTo" w="100" type="button" p1="'usuarios'" p2="'usuarios_list'" p3="''" p4="'Main'" p5="this" class="icon arrowleft"}
        </div>



        <div class="top">&nbsp;</div>
        <div class="contenido">

            <input type="hidden" name="paramsReload" id="paramsReload" value="" />
            <input type="hidden" name="paramsReloadWindow" id="paramsReloadWindow" value="" />          

            <div class="xForm ">
                <form action="{$controller}.php?action=1&modulo=usuarios&submodulo=usuarios_form"  method="post"  name="f_record" id="f_record" >
                    <input type="hidden" name="idusuario" id="idusuario" value="{$record.idusuario}" />
                    <div class="form_container ">
                        <div class="title">Datos del Usuario</div>
                        <ul>


                            <li class="left">
                                <label>Apellido *</label> 
                                {x_form_input  id="apellido" descriptor="none" isRequired="true" maxChars=100 class="" record=$record} 
                            </li>

                            <li class="right">
                                <label>Nombre *</label> 
                                {x_form_input  id="nombre" descriptor="none" isRequired="true" maxChars=100 class="" record=$record}  
                            </li> 

                            <li class="left">
                                <label>Nombre Usuario *</label> 
                                {x_form_input  id="username" descriptor="username" isRequired="true" maxChars=100 class="" record=$record} 
                            </li>


                            <li class="right">
                                <label>E-Mail *</label> 
                                {x_form_input  id="email" descriptor="email" isRequired="true" maxChars=100 class="" record=$record} 
                            </li>   


                            <li class="left">
                                <label>Nueva Password</label> 
                                {x_form_input  id="password" descriptor="none" isRequired="false" maxChars=100 password=1 class=""} 
                            </li>                    


                            <li class="right checkbox-inline">
                                <label>Estado </label> 
                                {x_form_boolean  label_yes='Activo' label_no='Inactivo' value_yes=1 value_no=0 checked=$record.activo default=1 name="activo"}
                            </li>            

                            <li class="right checkbox-inline">
                                <label class="">Notificar nuevo médico registrado</label> 
                                {x_form_boolean  label_yes='SI' label_no='NO' value_yes=1 value_no=0 default=0 checked=$record.notificar_nuevo_medico  name="notificar_nuevo_medico" id="notificar_nuevo_medico"}
                            </li>
                            <li class="left checkbox-inline">
                                <label class="">Contacto soporte</label> 
                                {x_form_boolean  label_yes='SI' label_no='NO' value_yes=1 value_no=0 default=0 checked=$record.contacto_soporte  name="contacto_soporte" id="contacto_soporte"}
                            </li>

                            {if $record.masteradmin==1}
                                <li class="wide" >
                                    <label>Asignar acceso a:</label> 
                                    <span>Acceso total</span>
                                </li> 
                            {else}
                                <li class="wide" id="asignar_accesos" {if $record.idusuario==""}style="display:none"{/if}>
                                    <label>Asignar acceso a:</label> 
                                    <select name="usuario_menu_idusuario_menu" id="usuario_menu_idusuario_menu" class="">
                                        <option value="">Seleccionar...</option>
                                        {html_options options=$combo_usuario_menu}                        
                                    </select>  
                                    <span class="agregar_menu" id="agregar_usuario_menu" title="Agregar">+ Agregar</span>
                                </li> 
                            {/if}

                            <li class="clear">&nbsp;</li>

                        </ul>
                        <div class="clear">&nbsp;</div> 
                        <div id="listado_usuario_acceso" {if $listado_usuario_acceso}style="display:block;"{else}style="display:none"{/if}>
                            <div class="title">Accesos</div>
                            <ul>
                                {foreach from=$listado_usuario_acceso item=usuario_acceso}
                                    <li data-id="{$usuario_acceso.idusuario_acceso}" data-usuario-menu="{$usuario_acceso.usuario_menu_idusuario_menu}" class="usuario_acceso">
                                        <span class="delete_menu" data-id="{$usuario_acceso.idusuario_acceso}" title="Eliminar"> X </span> 
                                        {$usuario_acceso.usuario_menu}
                                    </li>
                                {/foreach}
                            </ul>



                        </div>
                        <div class="clear">&nbsp;</div>

                    </div> 



                    <div class="clear">&nbsp;</div>


                    <div class="clear">&nbsp;</div>




                </form>
                <div class="clear">&nbsp;</div>

            </div>
        </div>  

        <div class="clear">&nbsp;</div>




    </div> 
</div>  
