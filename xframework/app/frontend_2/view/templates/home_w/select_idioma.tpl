<style>
    .select-idioma img{
        width: 40px;
    }
    .select-idioma{
        /*   position: fixed;
           top: 10px;
           right: 0px;*/
    }
    .select-idioma .open > .dropdown-menu {
        display: block;
        padding: 5px;
        min-width: auto;
        margin-top:2px;
        width: 100%;
    }
    .selec-idioma .select-idioma div.dropdown:not(.open) ul.dropdown-menu {
        display:none;
    }
    .select-idioma li{
        cursor:pointer;
    }
    .dropdown-menu, .select2-drop {
        background-color:  #97bbdf
    } 

    .select-idioma .dropdown-toggle .caret {
        margin-left: 0px;
        border-top: 4px dashed;
        border-right: 4px solid transparent;
        border-left: 4px solid transparent;
        color:#fff;
    }
    @media (max-width: 960px){
        .select-idioma .dropdown .idioma{
            display:inline;
            font-size: 16px;
            color: #fff;
            margin-left: 10px;
        }
    }
    @media (min-width: 960px){
        .select-idioma .dropdown .idioma{
            display:none;

        }
    }
</style>
<div class="select-idioma">
    <div class="dropdown" style="background: #5f94e74f; border-radius: 8px;">
        <button class="dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true">
            {if $TRADUCCION_IDIOMA=="en"}
                <img src="{$IMGS}british_flag.png" alt='{"Sitio en ingles"|x_translate}'  title='{"Sitio en ingles"|x_translate}'>

            {/if}
            {if $TRADUCCION_IDIOMA=="fr"}
                <img src="{$IMGS}france_flag.png" alt='{"Sitio en francés"|x_translate}'  title='{"Sitio en francés"|x_translate}'>

            {/if}

            <span class="caret"></span>
        </button>
        <ul class="dropdown-menu" aria-labelledby="dropdownMenu1">
            {if $TRADUCCION_IDIOMA=="en"}
                <li class="change-language" data-idioma="fr"> 
                    <img src="{$IMGS}france_flag.png" alt='{"Sitio en francés"|x_translate}'  title='{"Sitio en francés"|x_translate}'>

                </li>
            {/if}
            {if $TRADUCCION_IDIOMA=="fr"}
                <li class="change-language" data-idioma="en"> 
                    <img src="{$IMGS}british_flag.png" alt='{"Sitio en ingles"|x_translate}'  title='{"Sitio en ingles"|x_translate}'>

                </li>
            {/if}
        </ul>
    </div>
</div>

{literal}
    <script>
        $(function () {
            $(".change-language").click(function () {
                var idioma = $(this).data("idioma");

                if (idioma != "") {
                    x_doAjaxCall(
                            'POST',
                            BASE_PATH + "set_idioma.do",
                            "idioma=" + idioma,
                            function () {

                                window.location.href = "";

                            });
                }
            });








        });


    </script>
{/literal}