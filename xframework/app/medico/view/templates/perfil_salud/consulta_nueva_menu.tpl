<div class="row tab-buttons">
    <ul class="nav-tabs nav">
        <li class="active">
            <a href="#anotaciones" role="tab" data-toggle="tab" title='{"Conclusión médica"|x_translate}'>
                <span class="dp-profile"></span><small>{"Conclusión médica"|x_translate}</small>
            </a>
        </li>
        <li>
            <a href="#agregar-archivo" role="tab" data-toggle="tab" title='{"Archivos adjuntos"|x_translate}'>
                <span class="fui-clip"></span><small>{"Archivos adjuntos"|x_translate}</small>
            </a>
        </li>
        {if $medico.mis_especialidades.0.tipo==1 && $medico.pais_idpais==1}
            <li>
                <a href="#agregar-prescripcion" role="tab" data-toggle="tab" class="" title='{"Medicación"|x_translate}'>
                    <span class="dp-medicine"></span><small>{"Medicación"|x_translate}</small>
                </a>
            </li>
            {if $videoconsulta}
                <li>
                    <a href="#agregar-receta" role="tab" data-toggle="tab" class="" title='{"Prescripcion"|x_translate}' >
                        <span class="dp-file"></span><small>{"Prescripcion"|x_translate}</small>
                    </a>
                </li>
            {/if}
        {/if}

    </ul>
</div>