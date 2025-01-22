<!-- Modal full width- ver archivos-->
<style>

    .modal.modal-full  {
        position: fixed;
        top: 0;
        right: 0;
        bottom: 0;
        left: 0;
        overflow: hidden;
        z-index: 900000;
    }

    .modal-full .modal-dialog {
        position: fixed;
        margin: 0;
        width: 100%;
        height: 90%;
        padding: 0;
    }

    .modal-full .modal-content {
        position: absolute;
        top: 0;
        right: 0;
        bottom: 0;
        left: 0;
        border: 2px solid #3c7dcf;
        border-radius: 0;
        box-shadow: none;
        width: 90%;
        margin: auto;
    }

    .modal-full  .modal-header {
        position: absolute;
        top: 0;
        right: 0;
        left: 0;
        height: 50px;
        padding: 10px;
        background: #f1f3f5;
        border: 0;
    }
    .modal-full  .modal-header .close{
        font-size: 32px;
    }



    .modal-full .modal-body {
        position: absolute;
        top: 50px;
        bottom: 60px;
        width: 100%;
        font-weight: 300;
        overflow-y: hidden;
        overflow-x: scroll;
        text-align: center;
    }

    .modal-full .modal-footer {
        position: absolute;
        right: 0;
        bottom: 0;
        left: 0;
        height: 60px;
        padding: 10px;
        background: #f1f3f5;
    }

    .modal-full .modal-footer a{
        max-width:150px;
        cursor:pointer;
        padding:10px 20px;
    }
    .modal-full  .modal-content object,.modal-full  .modal-content embed{
        height:100%;
    }
    .modal-full  .modal-content object[type="application/pdf"],.modal-full  .modal-content embed[type="application/pdf"]{
        width:100%;
        height:100%;
    }
    @media (max-width: 992px){
        .modal-full .modal-dialog {
            margin-top: 65px!important;
        }
        .modal-full  .modal-content object,.modal-full  .modal-content embed{
            height: auto;
            width: 100%;
            max-height: 100%;
        }
    }

</style>

<!-- Modal -->

<!-- modal -->
<div id="modal-display-file"
     class="modal animated bounceIn modal-full"
     tabindex="-1"
     role="dialog"
     aria-labelledby="myModalLabel"
     aria-hidden="true">

    <!-- dialog -->
    <div class="modal-dialog">

        <!-- content -->
        <div class="modal-content">

            <!-- header -->
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true" title='{"cerrar"|x_translate}'>&times;</button>
            </div>
            <!-- header -->

            <!-- body -->
            <div class="modal-body">
                <object data="" type="">
                    <embed class="img-responsive" src="" type="" />
                </object>
            </div>
            <!-- body -->

            <!-- footer -->
            <div class="modal-footer">
                <div class="row">
                    <div class="col-xs-12 text-center hidden-xs">
                        <a class="download btn-primary" href="" download="" target="_blank">
                            <i class="fa fa-download"></i>&nbsp;{"descargar"|x_translate}
                        </a>
                    </div>
                    <div class="col-xs-12 text-center visible-xs">
                        <a class="download btn-primary " href=""  target="_blank">
                            <i class="fa fa-download"></i>&nbsp;{"descargar"|x_translate}
                        </a>
                    </div>
                </div>


            </div>
            <!-- footer -->

        </div>
        <!-- content -->

    </div>
    <!-- dialog -->

</div>
<!-- modal -->
{literal}
    <script>
        $(function () {
            $("#modal-display-file").on('hidden.bs.modal', function () {
                $("#modal-display-file object").attr("data", "");
                $("#modal-display-file embed").attr("src", "");
                $("#modal-display-file .download").attr("href", "");

                $("#modal-display-file object").attr("type", "");
                $("#modal-display-file embed").attr("type", "");
            });
        });
    </script>
{/literal}