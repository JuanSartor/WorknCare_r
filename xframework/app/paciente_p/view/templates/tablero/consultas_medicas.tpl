<article class="col-md-8">
    <div class="card grid-overview slider-box">
        <div class="card-header">
            <h1 class="card-title">{"Consultas médicas"|x_translate}</h1>
        </div>
        <div class="card-body">
            
            <ul class="slider-for">

                {foreach from=$list_consultas item=consulta}
                <li>
                    <div class="row">
                        <div class="col-md-12">
                            <h2><span>{$consulta.fecha_format}</span> 
                                 {if $consulta.consultaExpress_idconsultaExpress!=""} 
                            <figure class="green-circle circle-55 card-circle-top">
				<i class="icon-doctorplus-chat"></i>
                            </figure>
                            {/if}
                            {if $consulta.videoconsulta_idvideoconsulta!=""}
                            <figure class="green-circle circle-55 card-circle-top">
				<i class="icon-doctorplus-video-call"></i>
                            </figure>
                            {/if}
                            </h2>	
                        </div>	
                        <div class="data col-md-6"><a href="{$url}panel-paciente/perfil-salud/registros-consultas-medicas-detalle/{$consulta.idperfilSaludConsulta}"><em>{"Profesional consultado"|x_translate}</em>{$consulta.titulo_profesional} {$consulta.nombre} {$consulta.apellido}<br><small>{$consulta.especialidad}</small></a></div>
                        <div class="data col-md-6"><a href="{$url}panel-paciente/perfil-salud/registros-consultas-medicas-detalle/{$consulta.idperfilSaludConsulta}"><em>{"Diagnóstico"|x_translate}</em>{$consulta.diagnostico}</a></div>
                    </div>
                </li>
           

              {foreachelse}
                <li>
                    <div class="row">
                        <br>
                        <div class="data col-md-11"><em><h6>{"No posee consultas médicas"|x_translate} </h6></em></div>
                       
                    </div>
                </li>
                {/foreach}
            </ul>

        </div>
    </div>
</article>

{literal}
<script>
    $('#div_consultas_medicas .slider-for').slick({
        slidesToShow: 1,
        slidesToScroll: 1,
        arrows: false,
        dots: true,
        centerMode: false,
        fade: true
    });
</script>
{/literal}
