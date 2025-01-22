<h2 id="pbn-instrucciones-btn" class="pbn-instrucciones-title">
    {"¿Cómo funciona?"|x_translate}
    <i class="fa fa-chevron-down flecha animatedColor"></i>
</h2>
<section id="pbr-instrucciones" class="pbr-instrucciones-holder" style="display:none;">
    <div class="okm-row">
        <div class="pbr-instrucciones-col">
            <i class="icon-doctorplus-map-point pbr-icon-1"></i>
            <h3>{"Buscá médicos"|x_translate}</h3>
            <h4>{"según tus preferencias"|x_translate}</h4>
        </div>
        <div class="pbr-instrucciones-col">
            <i class="icon-doctorplus-24 pbr-icon-2"></i>
            <h3>{"Consultá"|x_translate}</h3>
            <h4>{"su disponiblidad"|x_translate}</h4>
        </div>
        <div class="pbr-instrucciones-col">
            <i class="icon-doctorplus-calendar-time pbr-icon-3"></i>
            <h3>{"Reservá"|x_translate}</h3>
            <h4>{"tu turno on line"|x_translate}</h4>
        </div>
    </div>
    <div class="okm-row">
        <div class="pbr-instrucciones-img-col">
            <img src="{$IMGS}pbr/pbr-img-1.png" />
        </div>
        <div class="pbr-instrucciones-img-col">
            <img src="{$IMGS}pbr/pbr-img-2.png" />
        </div>
        <div class="pbr-instrucciones-img-col">
            <img src="{$IMGS}pbr/pbr-img-3.png" />
        </div>
    </div>

</section>


<section class="pbr-banners-background">
    <div class="container pbr-banners">
        <div class="okm-row">
            <h2  id="pbr-banners-title" class="pbr-banners-title">
                {"Disfrute también de estas herramientas que le ofrece DoctorPlus"|x_translate}
                <i class="fa fa-chevron-down flecha animatedColor"></i>
            </h2>
        </div>

        <div id="pbr-banner-holder" class="okm-row pbr-banner-holder" style="display:none;">
            <div class="pbr-banner-col">
                <div class="pbr-banner-card boder-profiter">
                    <img src="{$IMGS}mobile-red-with-hand.svg" />
                    <h4 class="pbr-banner-card-title color-txt-profitez">
                        <!--   <figure class="pbr-banner-icon-ce">
                               <i class="icon-doctorplus-chat"></i>
                           </figure> -->
                        {"Consulta Express"|x_translate}
                    </h4>
                    <p class="pbr-banner-card-content">
                        {"¿Todavía perdés tiempo en un consultorio por una consulta breve?"|x_translate}
                        {"Consultá a tus médicos de confianza sin moverte de tu casa"|x_translate}
                    </p>
                    <a href="{$url}panel-paciente/guia-de-uso/" class="pbr-banner-card-action txt-masinfo-profiter">{"MÁS INFO"|x_translate}</a>
                </div>
            </div>
            <div class="pbr-banner-col">
                <div class="pbr-banner-card boder-profiter">
                    <img src="{$IMGS}laptop-dr-plus-claud.svg" />
                    <h4 class="pbr-banner-card-title color-txt-profitez">
                        <!--   <figure class="pbr-banner-icon-ps">
                               <i class="icon-doctorplus-pharmaceutics"></i>
                           </figure> -->
                        {"Perfil de Salud"|x_translate}
                    </h4>
                    <p class="pbr-banner-card-content">
                        {"Su Perfil de Salud y el de su familia en  un solo lugar. Visualice y tenga siempre a mano el resultado de sus estudios y chequeos."|x_translate}
                    </p>
                    <a href="{$url}panel-paciente/guia-de-uso/" class="pbr-banner-card-action txt-masinfo-profiter">{"MÁS INFO"|x_translate}</a>
                </div>
            </div>
        </div>
    </div>
</section>
<script>
    $(function () {
        //evento para desplegar las intrucciones de 'Como funciona' en version movil
        $('#pbn-instrucciones-btn').on('click', function () {
            $('#pbr-instrucciones').slideToggle();
        });
        $('#pbr-banners-title').on('click', function () {
            console.log("11");
            $('#pbr-banner-holder').slideToggle();
        });
    });
</script>