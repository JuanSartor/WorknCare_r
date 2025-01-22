<div class="background">
    <div class="wrapper">
        <div class="okm-row text-center section-title">
            <h2>{"Cómo podemos ayudarte?"|x_translate}</h2>
        </div>
        <div class="masonry-container masonry">
            {foreach from=$listado_programas item=programa}
                <div class="item" style="background-image: url('{$programa.imagenes.imagen.original}')" >
                    <a href="{$url}thematique/{$programa.idprograma_salud}-{$programa.programa_salud|str2seo}.html" class="btn-ver-categoria" data-id="{$programa.idprograma_salud}" title='{$programa.programa_salud}'> 
                        <div class="img-container">
                            <div class="title-holder">
                                {$programa.programa_salud}
                            </div>
                        </div>
                    </a>
                </div>

            {/foreach}

        </div>
    </div>

</div>
<div class="clearfix"></div>
<script>
    $(function () {
        /* $(".btn-ver-categoria").click(function (e) {
         e.preventDefault();
         console.log("mostrar categorias:" + $(this).data("id"));
         x_loadModule("programa_salud", "listado_categorias", "idprograma_salud=" + $(this).data("id"), "Main");
         })
         */

    });
</script>