


<div class="block">


    <div class="top">&nbsp;</div>

    <div class="xForm">
        <div class="form_container">

            <ul>

                <li class="left">
                    <strong>From:</strong> 
                    <span>{$record.mail_from_name}: {$record.mail_from}</span>
                </li>
                <li class="right">
                    <strong>To:</strong> 
                    <span>{$record.mail_to}</span>

                </li>   
                <li class="wide">
                    <strong>Asunto:</strong> 
                  
                    <span>{$record.mail_subject}</span>

                </li>   




                <li class="left">
                    <strong>Fecha:</strong> 
                    <span>{$record.fecha}</span>
                </li>   
                <li class="right">
                    <strong>Estado:</strong> 
                    {if $record.estado==1}
                        <span>Enviado</span>
                    {/if}
                    {if $record.estado==0}
                        <span>Pendiente</span>
                    {/if}
                    {if $record.estado==99}
                        <span>NO enviar</span>
                    {/if}

                </li>

                <div class="clear">
                    &nbsp;
                </div>
            </ul>
        </div>
    </div>
    <div class="top">&nbsp;</div>
    <div class="xForm">

        <input type="hidden"  id="idtraduccion" name="idtraduccion" value="{$smarty.request.id}" />
        {$record.body}


    </div>


</div> 






