<section class="container ceprr-todas">
    <ul>
        {if $consultas_especialidad|@count >0}
            {*si hay hasta 15 especialidades las listamos a todas, si hay mas motramos 14  y 'Ver mas especialidades'*}
            {if $consultas_especialidad|@count <=15}
                {foreach from=$consultas_especialidad item=especialidad_consulta}
                    <li>
                        <a href="{$url}panel-medico/videoconsulta/red.html?idespecialidad[]={$especialidad_consulta.idespecialidad}">
                            <figure  data-idespecialidad="{$especialidad_consulta.idespecialidad}">{$especialidad_consulta.cantidad}</figure>
                                {$especialidad_consulta.especialidad}
                        </a>
                    </li>
                {/foreach}
            {else}
                {foreach from=$consultas_especialidad item=especialidad_consulta name=count_especialidades}
                    {if $smarty.foreach.count_especialidades.iteration <14}
                        <li>
                            <a href="{$url}panel-medico/videoconsulta/red.html?idespecialidad[]={$especialidad_consulta.idespecialidad}">
                                <figure  data-idespecialidad="{$especialidad_consulta.idespecialidad}">  {$especialidad_consulta.cantidad}</figure>
                                    {$especialidad_consulta.especialidad}
                            </a>
                        </li>
                    {else}
                        {*mostramos ver mas especalidades y el resto estn ocultas*}
                        {if $smarty.foreach.count_especialidades.iteration ==14}
                            <li>
                                <a href="javascript:;" class="ceprr-ver-mas">
                                    {"Ver más"|x_translate}
                                </a>
                            </li>
                        {else}
                            <li style="display:none">
                                <a href="{$url}panel-medico/videoconsulta/red.html?idespecialidad[]={$especialidad_consulta.idespecialidad}">
                                    <figure  data-idespecialidad="{$especialidad_consulta.idespecialidad}">  {$especialidad_consulta.cantidad}</figure>
                                        {$especialidad_consulta.especialidad}
                                </a>
                            </li>

                        {/if}
                    {/if}
                {/foreach}
            {/if}
        {else}
            <div class="sin-registros">


                <p>{"No existen Video Consultas publicadas para Profesionales en la Red"|x_translate}.</p>
            </div>
        {/if}


    </ul>
</section>
<script>
    $(function () {
        //verificamos si estaba visible, lo voldemos a mostrar luego de recargar
        if ($("a.ceprr-todas-trigger").hasClass("active")) {
            $('.ceprr-todas').slideDown();
        }

        $("#div_videoconsulta_red_contador").spin(false);

        //mostrar fuiltros
        $('.ceprr-ver-mas').on('click', function (e) {
            e.preventDefault();
            $("#div-especialidad-tags").hide();
            if ($('.ceprr-filtros-holder').is(':hidden')) {
                $('.ceprr-filtros-holder').stop().slideDown();
            }

            $('html, body').animate({
                scrollTop: $("#as_especialidades").offset().top - 200}, 1000);
        });



    });
</script>
