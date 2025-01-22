<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>WorknCare - Rapports </title>
        <script src="{$url}xframework/core/libs/libs_js/jquery-1.11.1.min.js"></script>
        {include file="js_templates/a_run.tpl"}
        <script type="text/javascript">
            var BASE_PATH = "{$url}";
        </script>  
        {x_js_global debug=1}
        {x_css_global debug=0}
        <!-- menu emergende de mi perfil -->
        <link rel="stylesheet" type="text/css" href="{$url}xframework/app/medico/view/css/fix.css?v={$smarty.now|date_format:"%j"}" />
        <link rel="shortcut icon" href="{$IMGS}icono-url.png" type="image/png" />
    </head>
    <body class="vista-impresion">
        <div class="vista-impresion-header header-reporte">  
            <img src="{$IMGS}logo_workncare_color.png">
        </div>
        {include file="$content"}
    </body>
    {include file="js_templates/z_run.tpl"}
</html>