<!DOCTYPE html>
<html lang="{$TRADUCCION_IDIOMA}">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>WorknCare - Error</title>
        {x_css_global debug=0}  

        <!-- menu emergende de mi perfil -->
        <link rel="stylesheet" type="text/css" href="{$url}xframework/app/medico/view/css/fix.css?v={$smarty.now|date_format:"%j"}" />

        <link rel="shortcut icon" href="{$IMGS}icono-url.png" type="image/png" />
    </head>
    <body class="pe-body">
        <section class="pe-container">
            <div class="pe-error-holder">
                <div class="pe-card">
                    <img src="{$IMGS}logo_workncare_color.png" alt="WorknCare"/>
                    {include file="$content"}
                </div>
            </div>
        </section>

    </body>
</html>