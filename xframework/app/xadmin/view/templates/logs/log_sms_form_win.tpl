


<div class="block">


    <div class="top">&nbsp;</div>


    <div class="xForm">

        <input type="hidden"  id="idtraduccion" name="idtraduccion" value="{$smarty.request.id}" />


        <div class="form_container">
          
            <ul>

                <li class="left">
                    <strong>Fecha:</strong> 
                    <span>{$record.fecha}</span>
                </li>
                <li class="right">
                    <strong>Último envío:</strong> 
                    <span>{$record.ultimo_envio}</span>

                </li>   


                <li class="left">
                    <strong>Tipo usuario:</strong> 
                    <span>{$record.dirigido}</span>

                </li>   
                <li class="right">
                    <strong>Nombre usuario:</strong> 
                    <span>{$record.nombre_usuario}</span>
                </li>


                <li class="left">
                    <strong>Email:</strong> 
                    <span>{$record.email}</span>

                </li>   
                <li class="right">
                    <strong>Celular:</strong> 
                    <span>{$record.numero_cel}</span>
                </li>


                <li class="left">
                    <strong>Motivo:</strong> 
                    <span>{$record.contexto}</span>

                </li>  
                <li class="right">
                    <strong>Estado:</strong> 
                    <span>{$record.estado}</span>
                </li>



                <li class="wide">
                    <strong>Texto:</strong> 
                    <br>
                    <span>{$record.texto}</span>
                </li>


                <div class="clear">
                    &nbsp;
                </div>
            </ul>
        </div>

    </div>


</div> 






