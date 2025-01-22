<link rel="stylesheet" type="text/css" href="{$url}xframework/app/medico/view/css/mensajes-imagenes-slider.css" />
<div class="modal-header">
    <span id="close-ver-archivo" style="float: right; cursor:pointer;">X</span>
    <div class="modal-title">
        <h5>{$estudio.titulo}:</h5>
    </div>
</div>
<div class="modal-body">
    <div>
        <div class="slider slider-nav-carrousel">
            {foreach from=$listado item=file name=listado}
                <div class='slider-item-container'>
                    <a href="{$file.url}" title="{$file.nombre}" data-ext="{$file.ext}" data-filename="{$file.nombre}" >
                        <img src="{$file.path_images}"  style="width:110px; height: 110px;  margin: auto;" title="{$file.nombre}">

                    </a>
                    <div class='iterator'>{$smarty.foreach.listado.iteration}</div>
                </div>
            {/foreach}
        </div>						
    </div>						
</div>

{literal}
    <script>
        $(document).ready(function () {
            $('#ver-archivo .slider-nav-carrousel').slick({
                slidesToShow: 3,
                slidesToScroll: 1,
                asNavFor: '#ver-archivo .slider-for',
                dots: false,
                centerMode: false,
                focusOnSelect: true,
                draggable: true
            });
            $("#close-ver-archivo").click(function () {
                $('#ver-archivo').modal("hide");
            });

            $(".slider-item-container a").click(function (e) {
                e.preventDefault();
                var ext = $(this).data("ext");
                var type = "";
                switch (ext) {
                    case "pdf":
                        type = "application/pdf";
                        break;
                    case "jpeg":
                        type = " image/jpeg";
                        break;
                    case "jpg":
                        type = "image/jpeg";
                        break;
                    case "png":
                        type = "image/png";
                        break;
                    case "gif":
                        type = "image/gif";
                        ;
                        break;
                    case "bmp":
                        type = "image/bmp";
                        ;
                        break;
                    case "webp":
                        type = "image/webp";
                        ;
                        break;
                }

                var src = $(this).attr("href") + "?" + new Date().getTime();
                //quitamos el archivo anterios
                $("#modal-display-file .modal-body").empty();
                $("#modal-display-file .modal-body").append("<object><embed></embed></object>");
                $("#modal-display-file .modal-body object embed").addClass("img-responsive");

                //agregamos path del nuevo archivo
                $("#modal-display-file object").attr("data", src);
                $("#modal-display-file embed").attr("src", src);
                $("#modal-display-file .download").attr("href", src);

                $("#modal-display-file object").attr("type", type);
                $("#modal-display-file embed").attr("type", type);
                $("#modal-display-file").modal("show");
            });
        });
    </script>
{/literal}