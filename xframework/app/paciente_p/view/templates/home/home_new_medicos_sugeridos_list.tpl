
<style>
    a.pcuh-pp-slide-item>figure {
        position: relative;
    }
    a.pcuh-pp-slide-item .pul-pp-like-box figure {
        line-height: 23px;
        border: solid 2px;
    }
    a.pcuh-pp-slide-item .pul-pp-like-box {
        text-align: center;
        padding: 0;
        position: absolute;
        bottom: 0px;
        right: 0px;
    }
</style>
{if $medicos_sugeridos_list && $medicos_sugeridos_list|@count>0}
    <section class="pul-profesionales-posibles">
        <div class="okm-container">
            <h2>{"Profesionales que tal vez te interese conocer"|x_translate}</h2>

            <div class="pul-pp-slide-hodler">
                <a href="javascript:;" class="pul-pp-slide-controls left"><i class="icon-doctorplus-left-arrow"></i></a>
                <div class="pul-pp-slide-box">
                    <div class="pul-pp-slide">
                        {foreach from=$medicos_sugeridos_list item=medico_sugerido}
                            <a class="pcuh-pp-slide-item" href="{$url}panel-paciente/profesionales/{$medico_sugerido.idmedico}-{$medico_sugerido.nombre|str2seo}-{$medico_sugerido.apellido|str2seo}.html">

                                <figure>
                                    {if !$medico_sugerido.imagen}
                                        <img src="{$IMGS}extranet/noimage_perfil.png" title="{$medico_sugerido.nombre} {$medico_sugerido.apellido}" alt="{$medico_sugerido.nombre} {$medico_sugerido.apellido}">
                                    {else}
                                        <img src="{$medico_sugerido.imagen.list}" title="{$medico_sugerido.nombre} {$medico_sugerido.apellido}" alt="{$medico_sugerido.nombre} {$medico_sugerido.apellido}">
                                    {/if}
                                    <span class="pul-pp-like-box">
                                        <figure data-id="{$medico_sugerido.idmedico}"><i class="icon-doctorplus-corazon"></i></figure>
                                    </span>
                                </figure>
                                <div class="pcuh-pf-slide-item-data">
                                    <p>{$medico_sugerido.titulo_profesional} {$medico_sugerido.nombre} {$medico_sugerido.apellido}</p>
                                    <span>{$medico_sugerido.especialidad.0.especialidad}</span>
                                </div>
                                {*
                                <div class="pul-pp-star-box">
                                <ul class="ratting estrellas-{$medico_sugerido.estrellas}">
                                <li><i class="icon-doctorplus-star"></i></li>
                                <li><i class="icon-doctorplus-star"></i></li>
                                <li><i class="icon-doctorplus-star"></i></li>
                                <li><i class="icon-doctorplus-star"></i></li>
                                <li><i class="icon-doctorplus-star"></i></li>
                                </ul>
                                </div>
                                *}


                                {*
                                {if $medico_sugerido.valoracion >0}
                                <div class="pul-pp-recomend-box">
                                {if $medico_sugerido.valoracion ==1}
                                {$medico_sugerido.valoracion} {"paciente lo recomienda"|x_translate}
                                {else}
                                {$medico_sugerido.valoracion} {"pacientes lo recomendaron"|x_translate}
                                {/if}
                                </div>
                                {/if}  
                                *}
                            </a>
                        {/foreach}

                    </div>
                </div>
                <a href="javascript:;" class="pul-pp-slide-controls right"><i class="icon-doctorplus-right-arrow"></i></a>
            </div>
        </div>
    </section>
{/if}

{literal}
    <script>
        $(function () {
            //js profesionales que te gustaria conocer
            $('.pul-pp-slide-controls.left, .pul-pp-slide-controls.right').on('click', function (e) {
                e.preventDefault();
            });

            $('.pul-pp-slide').slick({
                centerMode: false,
                dots: false,
                draggable: true,
                focusOnSelect: false,
                infinite: true,
                autoplay: true,
                autoplaySpeed: 12000,
                nextArrow: '.pul-pp-slide-controls.right',
                prevArrow: '.pul-pp-slide-controls.left',
                slidesToScroll: 6,
                slidesToShow: 6,
                responsive: [
                    {
                        breakpoint: 990,
                        settings: {slidesToShow: 5, slidesToScroll: 5, }
                    },
                    {
                        breakpoint: 800,
                        settings: {slidesToShow: 4, slidesToScroll: 4, }
                    },
                    {
                        breakpoint: 720,
                        settings: {slidesToShow: 3, slidesToScroll: 3, }
                    },
                    {
                        breakpoint: 600,
                        settings: {slidesToShow: 1, slidesToScroll: 1, }
                    }
                ]
            });

            //boton setear o eliminar medico favorito
           /* $('.pul-pp-like-box').children('figure').on('click', function (e) {


                $element = $(this);
                var id = $(this).data('id');
                x_doAjaxCall(
                        'POST',
                        BASE_PATH + 'marcar_favorito.do',
                        'idmedico=' + id,
                        function (data) {
                            if (data.result) {
                                $element.toggleClass('active');
                            } else {
                                x_alert(data.msg);
                            }
                        }
                );

            });*/
        });
    </script>
{/literal}