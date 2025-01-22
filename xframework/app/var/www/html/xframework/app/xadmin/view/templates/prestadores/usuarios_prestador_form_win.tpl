









<div class="xForm w750">
    <form action="{$controller}.php?action=1&modulo=prestadores&submodulo=usuarios_prestador_form_win"  method="post"  id="f_usuarios_prestador" >
        <input type="hidden" name="prestador_idprestador" value="{$smarty.request.idprestador}" />
        <input type="hidden" id="idusuario_prestador" name="idusuario_prestador" value="{$smarty.request.id}" />


        <div class="form_container">
            <div class="title">
                Datos del usuario
            </div>
            <div class="top">&nbsp;</div>
            <ul>

                <li class="left">
                    <label>Nombre </label> 
                    {x_form_input  id="nombre_usuario" name="nombre" descriptor="none" isRequired="true" maxChars=100 class="" value=$record.nombre} 
                </li>   
                <li class="right">
                    <label>Apellido </label> 
                    {x_form_input  id="apellido_usuario" name="apellido" descriptor="none" isRequired="true" maxChars=100 class="" value=$record.apellido} 
                </li>  
                <li class="left">
                    <label>Username </label> 
                    {x_form_input  id="username_usuario" name="username" descriptor="none" isRequired="true" maxChars=100 class="" value=$record.username} 
                </li> 
                {if !$record}
                <li class="left">
                    <label>Password </label> 
                    {x_form_input  id="password_usuario" name="password" descriptor="none" isRequired="false" maxChars=100 class="" value=$record.password} 
                </li>  
                {/if}
                <li class="right">
                    <label>Email </label> 
                    {x_form_input  id="email_usuario" name="email" descriptor="none" isRequired="true" maxChars=100 class="" value=$record.email} 
                </li>  

                <li class="left">
                    <label>Tipo usuario</label> 
                    <select class="" name="tipousuario" id="tipousuario">
                        <option value="0" {if !$record || $record.tipousuario==0}selected{/if}>Secretario/a</option>
                        <option value="1" {if $record && $record.tipousuario==1}selected{/if}>Administrador</option>
                    </select>             
                </li>
                {if $record}
                <li class="left" style="display:none" id="div_password_usuario">
                    <label>Password </label> 
                    {x_form_input  id="password_usuario" name="password_usuario" descriptor="none" isRequired="false" maxChars=100 class="" } 
                </li>  
                {/if}
                <li class="rigth">
                    <label>Estado</label> 
                    {x_form_boolean  label_yes='Activo' label_no='Inactivo' value_yes=1 value_no=0 default=1  checked=$record.active name="active" id="active"}
                </li>

                <li class="clear"></li>
                <li class="wide ">  

                    {x_form_html_button id="back_hs" label="Volver" w="100" type="button" class="icon arrowleft"}


                    {if $record}
                    {x_form_html_button id="btnGuardarUsuarioPrestador" label="Guardar" w="100" type="button" class="icon save"}
                    {x_form_html_button id="btnResetPassword" label="Guardar nueva Password" w="100" type="button" class="icon loop "}
                    {x_form_html_button id="btnShowPassword" label="Cambiar Password" w="100" type="button" class="icon loop "}
                    {else}
                    {x_form_html_button id="btnGuardarUsuarioPrestador" label="Agregar" w="100" type="button" class="icon save"}
                    {/if}
                </li>
                <li class="clear"></li>

            </ul>


        </div>
    </form>
</div>






