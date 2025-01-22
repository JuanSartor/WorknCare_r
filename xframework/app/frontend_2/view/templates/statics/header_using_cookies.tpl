{if $smarty.request.analiticas=="1"}
    {literal}
        <!-- Global site tag (gtag.js) - Google Analytics -->
        <script async src="https://www.googletagmanager.com/gtag/js?id=G-L2Z3YE7730"></script>
        <script>
            window.dataLayer = window.dataLayer || [];
            function gtag() {
                dataLayer.push(arguments);
            }
            gtag('js', new Date());

            gtag('config', 'G-L2Z3YE7730');
        </script>
    {/literal}
{/if}
{if $smarty.request.funcionales=="1"}

    {*Incluimos hubspot chat en home public y adhesion pass *}
    {if  $smarty.request.from_submodulo=="index" || $smarty.request.from_submodulo=="registro_form"}

        <!-- Start of HubSpot Embed Code -->
        <script type="text/javascript" id="hs-script-loader" async defer src="//js-na1.hs-scripts.com/19574221.js"></script>
        <!-- End of HubSpot Embed Code -->
    {/if}
{/if}