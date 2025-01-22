<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1, maximum-scale=1, minimum-scale=1, width=device-width, height=device-height, target-densitydpi=device-dpi">

        <title>DoctorPlus</title>

        {include file="js_templates/a_run.tpl"}

        <script type="text/javascript">
            var BASE_PATH = "{$url}";
        </script>  

        {x_js_global debug=1} 


        {x_css_global debug=1}  


        <link rel="shortcut icon" href="{$url}favicon2.png" type="image/png" />

    </head>
    <body>

        <div class="modal" id="winModal" data-load="no" data-keyboard="false" data-backdrop="true" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">	
                </div>
            </div>
        </div>

        <script>
            $(document).ready(function (e) {
                $('#winModal').on('hidden.bs.modal', function () {
                    $(this)
                            .removeData('bs.modal')
                            .find(".modal-content").html('');

                });
            });
        </script>  

        <div class="main-content-wrapper"> 
            <div class="farmacia-container"  id="Main">        
                {include file="$content"}
            </div>
        </div>
        {include file="home/footer.tpl"}


        <!--Modal sugerencia usabilidad horizontal-->
        <div class="" id="check_window_orientation"></div>


        <div class="modal fade modal-type-2 modal-type-size-small" data-load="no" id="usabilidad-modal">
            <div class="modal-dialog">
                <div class="modal-content">
                    <span class="close-btn" data-dismiss="modal" aria-label="Close"><i class="fui-cross"></i></span>
                    <div class="form-content">
                        <h5>{"Sugerencia de usabilidad"|x_translate}</h5>
                        <p><img src="{$IMGS}usabilidad.png" height="67" width="241" alt=""></p>
                        <p>{"Navegar esta sección con la pantalla en sentido horizontal"|x_translate}</p>
                    </div>
                </div>
            </div>
        </div>	


        {include file="js_templates/z_run.tpl"}
        <script type="text/javascript">
            $(document).ready(function () {

                $(':checkbox').radiocheck();

            });
        </script>

        <div class="visible-xs visible-sm"  id="visible-mobile"></div>

    </body>
</html>