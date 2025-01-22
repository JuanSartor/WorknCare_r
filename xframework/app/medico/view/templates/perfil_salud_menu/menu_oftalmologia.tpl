<ul class="slider-menu">
    {*los ven todos*}
    <li><a href="{$url}panel-medico/mis-pacientes/{$paciente.idpaciente}-{$paciente.nombre|str2seo}-{$paciente.apellido|str2seo}/registro-consultas-medicas.html"  title='{"Registro consultas médicas"|x_translate}'><i class="dpp-consulta"></i></a><span>{"Registro consultas médicas"|x_translate}</span></li>
    <li><a href="{$url}panel-medico/mis-pacientes/{$paciente.idpaciente}-{$paciente.nombre|str2seo}-{$paciente.apellido|str2seo}/estudios-imagenes.html" title='{"Estudios e Imágenes"|x_translate}' ><i class="fui-clip"></i></a><span>{"Estudios e Imágenes"|x_translate}</span></li>
    <li><a href="{$url}panel-medico/mis-pacientes/{$paciente.idpaciente}-{$paciente.nombre|str2seo}-{$paciente.apellido|str2seo}/medicamentos.html" title='{"Medicamentos"|x_translate}' ><i class="dpp-medicina"></i></a><span>{"Medicamentos"|x_translate}</span></li>

    <li><a href="{$url}panel-medico/mis-pacientes/{$paciente.idpaciente}-{$paciente.nombre|str2seo}-{$paciente.apellido|str2seo}/control-visual.html" title='{"Visión"|x_translate}'><i class="dpp-ojo"></i></a><span>{"Visión"|x_translate}</span></li>
</ul>