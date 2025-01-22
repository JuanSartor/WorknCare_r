{if $paciente.animal!=1}
    {if $paciente.tarjeta_vitale!="" ||$paciente.tarjeta_cns!="" ||$paciente.tarjeta_eID!="" ||$paciente.tarjeta_pasaporte!="" }
        <div class="okm-row">
            <div class="mvc-pshb-box">
                <i class="icon-doctorplus-ficha-tecnica"></i>
                <div class="mvc-pshb-data">
                    {if $paciente.pais_idpais==1}
                        <span>{"Tarjeta Vitale"|x_translate}</span>
                        <span>Nº {$paciente.tarjeta_vitale}</span>
                    {/if}
                    {if $paciente.pais_idpais==2}
                        <span>{"Tarjeta CNS"|x_translate}</span>
                        <span>Nº {$paciente.tarjeta_cns}</span>
                    {/if}
                    {if $paciente.pais_idpais==3}
                        <span>{"Tarjeta eID"|x_translate}</span>
                        <span>Nº {$paciente.tarjeta_eID} </span>
                    {/if}
                    {if $paciente.pais_idpais==4}
                        <span>{"Pasaporte"|x_translate}</span>
                        <span>Nº {$paciente.tarjeta_pasaporte} </span>
                    {/if}
                </div>
            </div>
        </div>
    {/if}
{/if}