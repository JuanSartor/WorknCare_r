{if $paciente.animal!=1}
    {if $paciente.tarjeta_vitale!="" ||$paciente.tarjeta_cns!="" ||$paciente.tarjeta_eID!="" ||$paciente.tarjeta_pasaporte!="" }
        <li>
            <a href="javascript:;">
                <figure><i class="icon-doctorplus-ficha-tecnica"></i></figure>
                <p>
                    {if $paciente.pais_idpais==1}
                        {"Tarjeta Vitale"|x_translate}<br>
                        Nº {$paciente.tarjeta_vitale}
                    {/if}
                    {if $paciente.pais_idpais==2}
                        {"Tarjeta CNS"|x_translate}<br>
                        Nº {$paciente.tarjeta_cns}
                    {/if}
                    {if $paciente.pais_idpais==3}
                        {"Tarjeta eID"|x_translate}<br>
                        Nº {$paciente.tarjeta_eID}
                    {/if}
                    {if $paciente.pais_idpais==4}
                        {"Pasaporte"|x_translate}<br>
                        Nº {$paciente.tarjeta_pasaporte}
                    {/if}
                </p>
            </a>
        </li>
    {/if}
{/if}