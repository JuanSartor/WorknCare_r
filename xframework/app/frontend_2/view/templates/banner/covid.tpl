<style>
    #banner-alert-home{
        margin: 0 10px;
    }

    #banner-alert-home .form-content {
        padding: 50px ;
    }

    @media(max-width:600px){
        #banner-alert-home .form-content {
            padding: 40px 10px;
        }
    }
    #banner-alert-home .modal-content {
        background: transparent !important;
    }
    #banner-alert-home .form-content{
        /*background: rgba(16,106,141,0.85) !important; Teleexpertisa*/
        background: rgba(243,50,67,0.85) !important; /*Francia - Marruecos*/

    }
    #banner-alert-home .form-content p,#banner-alert-home .close-btn i {
        color: #fff !important;
        font-size: 16px !important;
    }
    #banner-alert-home .vertical-alignment-helper {
        display:table;
        height: 100%;
        width: 100%;
    }
    #banner-alert-home .vertical-align-center {
        /* To center vertically */
        display: table-cell;
        vertical-align: middle;
    }
    #banner-alert-home .modal-content {
        /* Bootstrap sets the size of the modal in the modal-dialog class, we need to inherit it */
        width:inherit;
        height:inherit;
        /* To center horizontally */
        margin: 0 auto;
    }
    .modal-backdrop.fade.in{
        z-index: 3;
    }

</style>

<div class="modal fade modal-type-2 modal-type-size-medium in" id="banner-alert-home">
    <div class="vertical-alignment-helper">
        <div class="modal-dialog  vertical-align-center">
            <div class="modal-content">
                <span class="close-btn" data-dismiss="modal" aria-label="Close"><i class="fui-cross"></i></span>
                <div class="form-content">
                    <p class="text-center">{"Alerte Coronavirus Luxembourg!"|x_translate}</p>
                    <p class="text-center"F> {"En cas de symptômes suspects, votre téléconsultation est actuellement remboursée par la CNS (sécurité sociale Luxembourg) pour tous les médecins généralistes sur DoctorPlus!"|x_translate}  </p>
                </div>
            </div>
        </div>
    </div>
</div>
<script>
    $(function () {

        var banner_alert_close_home = localStorage.getItem('banner_alert_close_home');
        if (banner_alert_close_home != "true") {
            $("#banner-alert-home").modal("show");
        }
        $("#banner-alert-home .close-btn").click(function () {
            localStorage.setItem('banner_alert_close_home', true);
            $("#banner-alert-home").modal("hide");
        });

    });
</script>
