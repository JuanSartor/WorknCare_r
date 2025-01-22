<div class="data-paciente"> 

    <h4 style="margin-left:0px"> 
        {if $paciente.animal!=1}
            <i class="icon-doctorplus-user"></i>
        {else}
            <i class="fas fa-dog"></i>
        {/if}
        {$paciente.nombre} {$paciente.apellido}
        {if $paciente.beneficia_ald==1}
            <label><em>  ({"Paciente ALD"|x_translate})</em></label>
        {/if}
    </h4>
    {if $paciente.animal!=1}
        <div class="cobertura-paciente-row">
            {if $paciente.tarjeta_vitale!=""}
                <p>
                    <span class="">
                        <i class="icon-doctorplus-ficha-tecnica"></i> 
                        {"Tarjeta Vitale"|x_translate}: 
                        {$paciente.tarjeta_vitale}
                    </span>
                </p>
            {/if}
            {if $paciente.tarjeta_cns!=""}
                <p>
                    <span class="">
                        <i class="icon-doctorplus-ficha-tecnica"></i> 
                        {"Tarjeta CNS"|x_translate}: 
                        {$paciente.tarjeta_cns}
                    </span>
                </p>
            {/if}
            {if $paciente.tarjeta_eID!=""}
                <p>
                    <span class="">
                        <i class="icon-doctorplus-ficha-tecnica"></i> 
                        {"Tarjeta eID"|x_translate}: 
                        {$paciente.tarjeta_eID}
                    </span>
                </p>
            {/if}
            {if $paciente.tarjeta_pasaporte!=""}
                <p>
                    <span class="">
                        <i class="icon-doctorplus-ficha-tecnica"></i> 
                        {"Pasaporte"|x_translate}: 
                        {$paciente.tarjeta_pasaporte}
                    </span>
                </p>
            {/if}   
        </div>
    {/if}  
</div>