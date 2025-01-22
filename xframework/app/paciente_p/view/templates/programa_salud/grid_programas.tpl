<div class="background">
    <div class="wrapper">
        <a href="{$url}panel-paciente/" class="btn-volver-home-sante" data-id="14"><i class="fa fa-chevron-left" aria-hidden="true"></i>{"Volver"|x_translate}</a>
        <div class="okm-row text-center section-title">
            <h2>{"Cómo podemos ayudarte?"|x_translate}</h2>
        </div>
        <div class="masonry-container masonry">
            {foreach from=$listado_programas item=programa}
                <div class="item" style="background-image: url('{$programa.imagenes.imagen.original}')" >
                    <div class="programa-destacado-tag" data-id="{$programa.idprograma_salud}">
                        <span class="content">
                            {"Gratuita"|x_translate}
                        </span>
                    </div>
                    <a href="{$url}patient/programmes-bienetre/{$programa.idprograma_salud}-{$programa.programa_salud|str2seo}.html" class="btn-ver-categoria" data-id="{$programa.idprograma_salud}" title='{$programa.programa_salud}'> 

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
    var ids_excepciones_programa = "{$ids_excepciones_programa}";
</script>
<script>
    $(function () {
        //desmarcamos los programas que no son ofrecidos por la empresa
        if (ids_excepciones_programa !== "") {

            if (ids_excepciones_programa !== "ALL") {
                ids_excepciones_programa.split(',').forEach(function (id) {
                    $(".programa-destacado-tag[data-id=" + id + "]").addClass("hide");
                });
                $(".programa-destacado-tag:not(.hide)").show();
            } else {
                $(".programa-destacado-tag").show();
            }
        }
    });
</script>