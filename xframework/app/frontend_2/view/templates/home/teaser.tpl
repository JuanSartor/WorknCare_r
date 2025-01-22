
<div id="teaser-modal" class="modal fade teaser-modal" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel">
    <div class="modal-dialog modal-md" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>

            </div>
            <div class="modal-body" id="teaser">
                <h4>Le lancement de DoctorPlus est prévu pour le 30 Juin 2019</h4>
                <h6>Laissez-nous vos coordonnées et nous reviendrons vers vous lors du lancement officiel de notre solution!</h6>

                <form id="teaser-form" class="teaser-form" >

                    <div class="col-xs-12">
                        <div class="form-group">
                            <input  id="teaser_email" class="form-control" type="email" placeholder="Ajoutez votre e-mail" >
                        </div>

                        <div class="form-group text-center">
                            <a  id="btnTeaserEnviar" class="btn btn-blue btn-inline ">ENVOYER</a>
                        </div>
                    </div>
                    <div class="clearfix"></div>

                </form>


                <div id="respuesta-teaser" style="display:none;">
                    <h4>Bien reçu!</h4>
                    <h4>A très bientôt sur DoctorPlus</h4>


                    <div class="form-group text-center teaser-form">
                        <a data-dismiss="modal" class="btn btn-blue btn-inline ">FERMER</a>
                    </div>
                </div>


            </div>




        </div>

    </div>
</div>
{literal}
<script>
    $(function () {
        var hide_teaser_modal = sessionStorage.getItem('hide_teaser_modal');
        if (hide_teaser_modal != 1) {
            $("#teaser-modal").modal("show");
        }
        $("#teaser-modal").on("hidden.bs.modal", function () {
            sessionStorage.setItem('hide_teaser_modal', 1);
        });

        $("#btnTeaserEnviar").click(function () {
            if (!validarEmail($("#teaser_email").val())) {
                $("#teaser_email").data("title", x_translate("Ingrese un email válido")).tooltip("show");
              
                return false;
            }
            x_doAjaxCall(
                    'POST',
                    BASE_PATH + "registrar_email_teaser.do",
                    "email=" + $("#teaser_email").val(),
                    function (data) {

                        
                        if (data.result) {
                            $("#teaser-form").slideUp();
                            $("#respuesta-teaser").slideDown();

                        }else{
                            x_alert(data.msg);
                        }
                    }
            );

        });
    });
</script>
{/literal}

