<section class="programs">
    <div class="programs-bg"></div>
    <div class="first-section">    
        <img src="xframework/app/themes/dp02/img/home_w_program_image.png" alt="Girl smiling"></img>    
        <div>
            <h5>{"Centralisez la gestion de vos actions Prévention & QVT"|x_translate}
            </h5>
            <p>{"Vous générez questionnaires, capsules d’information et Pass Prévention & QVT en quelques minutes, tout le reste est  automatisé."|x_translate}</p>
            <a>{"Je découvre"|x_translate}</a>
        </div>
    </div>
    <h3>{"Déployez I'action de votre choix en quelques clics"|x_translate}</h3>
    <div class="second-section">
        <div class="program">
            <img src="xframework/app/themes/dp02/img/home_w_program_image.png" alt="Girl smiling"></img>
            <div>
                <h5>{"Risque Psychosociaux"|x_translate}</h5>
                <p>{"3 Programmes"|x_translate}</p>
            </div>
            <img class="expansion-icon" src="xframework/app/themes/dp02/img/expand_more.svg" alt="expansion icon"></img>
            <div class="expansion-hidden">
                Esto debería estar oculto
            </div>  
        </div>
        <div class="program">
            <img src="xframework/app/themes/dp02/img/home_w_program_image.png" alt="Girl smiling"></img>
            <div>
                <h5>Risque Psychosociaux</h5>
                <p>3 Programmes</p>
            </div>
            <img class="expansion-icon" src="xframework/app/themes/dp02/img/expand_more.svg" alt="expansion icon"></img>
            <div class="expansion-hidden">
                Esto debería estar oculto
            </div>   
        </div>
        <div class="program">
            <img src="xframework/app/themes/dp02/img/home_w_program_image.png" alt="Girl smiling"></img>
            <div>
                <h5>Risque Psychosociaux</h5>
                <p>3 Programmes</p>
            </div>
            <img class="expansion-icon" src="xframework/app/themes/dp02/img/expand_more.svg" alt="expansion icon"></img>
            <div class="expansion-hidden">
                Esto debería estar oculto
            </div>  
        </div>
        <div class="program">
            <img src="xframework/app/themes/dp02/img/home_w_program_image.png" alt="Girl smiling"></img>
            <div>
                <h5>Risque Psychosociaux</h5>
                <p>3 Programmes</p>
            </div>
            <img class="expansion-icon" src="xframework/app/themes/dp02/img/expand_more.svg" alt="expansion icon"></img>
            <div class="expansion-hidden">
                Esto debería estar oculto
            </div>  
        </div>
    </div>

</section>

{literal}
    <script>
        $(function () {
            $('.expansion-icon').click(function () {
                $(this).parent().find('.expansion-hidden').slideToggle();
                //change src to the img                
                if ($(this).attr('src') === 'xframework/app/themes/dp02/img/expand_more.svg') {
                    $(this).attr('src', 'xframework/app/themes/dp02/img/expand_less.svg');
                } else {
                    $(this).attr('src', 'xframework/app/themes/dp02/img/expand_more.svg');
                }
            });


        });
    </script>
{/literal}