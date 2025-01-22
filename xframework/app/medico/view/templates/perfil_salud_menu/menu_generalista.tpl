<ul class="slider-menu">

    <li><a href="{$url}panel-medico/mis-pacientes/{$paciente.idpaciente}-{$paciente.nombre|str2seo}-{$paciente.apellido|str2seo}/registro-consultas-medicas.html"  title='{"Registro consultas médicas"|x_translate}'><i class="dpp-consulta"></i></a><span>{"Registro consultas médicas"|x_translate}</span></li>
    <li><a href="{$url}panel-medico/mis-pacientes/{$paciente.idpaciente}-{$paciente.nombre|str2seo}-{$paciente.apellido|str2seo}/estudios-imagenes.html" title='{"Estudios e Imágenes"|x_translate}' ><i class="fui-clip"></i></a><span>{"Estudios e Imágenes"|x_translate}</span></li>
    <li><a href="{$url}panel-medico/mis-pacientes/{$paciente.idpaciente}-{$paciente.nombre|str2seo}-{$paciente.apellido|str2seo}/medicamentos.html" title='{"Medicamentos"|x_translate}' ><i class="dpp-medicina"></i></a><span>{"Medicamentos"|x_translate}</span></li>

    <li><a href="{$url}panel-medico/mis-pacientes/{$paciente.idpaciente}-{$paciente.nombre|str2seo}-{$paciente.apellido|str2seo}/datos-biometricos.html" title='{"Datos biométricos"|x_translate}' {if $estadoTablero.datosbiometricos==0}class="alert"{/if}><i class="dpp-male"></i></a><span>{"Datos biométricos"|x_translate}</span></li>
    <li><a href="{$url}panel-medico/mis-pacientes/{$paciente.idpaciente}-{$paciente.nombre|str2seo}-{$paciente.apellido|str2seo}/enfermedades-patologias.html" title='{"Enfermedades y Patologías"|x_translate}' {if $estadoTablero.enfermedades==0 || $estadoTablero.patologias==0}class="alert"{/if}><i class="dpp-patologia"></i></a><span>{"Enfermedades y Patologías"|x_translate}</span></li>
    <li><a href="{$url}panel-medico/mis-pacientes/{$paciente.idpaciente}-{$paciente.nombre|str2seo}-{$paciente.apellido|str2seo}/antecedentes.html"  title='{"Antecedentes"|x_translate}' {if $estadoTablero.antecedentes_familiares==0 || $estadoTablero.antecedentes_pediatricos==0}class="alert"{/if}><i class="dpp-dna"></i></a><span>{"Antecedentes"|x_translate}</span></li>
    <li><a href="#{*{$url}panel-medico/mis-pacientes/{$paciente.idpaciente}-{$paciente.nombre|str2seo}-{$paciente.apellido|str2seo}/vacunas.html*}" title='{"Vacunas"|x_translate}'><i class="dpp-vacuna"></i></a><span>{"Vacunas"|x_translate}</span></li>

</ul>
