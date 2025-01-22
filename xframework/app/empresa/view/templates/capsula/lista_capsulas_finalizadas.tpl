<style>
    .checkbox .icon-unchecked:before {
        content: "\e60b";
    }
    .checkbox .icon-checked:before {
        content: "\e60c";
    }
    .btn-sig-etapa{
        background: white;
        color: #3DB4C0;
        border: 2px solid;
    }
    .icono-pdf{
        margin-right: 20px;
        font-size: 20px;
        color: red;
    }
    .icono-pdf:hover {
        color: #e37a7a;
    }
    .icono-excel{
        margin-right: 20px;
        font-size: 20px;
        color: #38d338;
    }
    .icono-flyer{
        margin-right: 20px;
        font-size: 20px;
        color: #F5C370;
    }
    .icono-excel:hover {
        color: #9ce19c;
    }
    .icono-eliminar{
        margin-right: 20px;
        font-size: 20px;
        color: black;
    }
    .icono-eliminar:hover {
        color: #9b9595;
    }
    .ajuste-cuestionario{
        border: none;
        border-bottom: solid 1px #c5c5c5;
        border-radius: 0px !important;
    }
    .icono-qr{
        margin-right: 20px;
        font-size: 20px;
        color: #3DB4C0;  
    }
    .icono-qr:hover {
        color: #97b4b7;
    }
    .icono-gift{
        margin-right: 20px;
        font-size: 20px;
        color: #ED799E;
    }
    .icono-gift:hover {
        color: #f10c80;
    }
    .titulo-creado{
        font-size: 16px;
        position: relative;
        left: 305px;
        top: 25px;
        color: #3DB4C0;
    }
    .titulo-visualizaciones{
        font-size: 16px;
        position: relative;
        left: 380px;
        top: 25px;
        color: #3DB4C0;
    }
    .titulo-tipo{
        font-size: 16px;
        position: relative;
        left: 225px;
        top: 25px;
        color: #3DB4C0;
    }
    .div-titulos-tabla{
        display: flex;
        position: relative;
        bottom: 15px;
        left: 190px;
    }

</style>
<section class="okm-container">
    {include file="capsula/modal_compartir_capsula_lista.tpl"}
    <div class="col-xs-12 programas-incluidos">
        <div  style="display: flex;" class="titulos">
            <h2 class="title">
                <button onclick="location.href = '{$url}entreprises/'"  class="btn btn-transparen go-back-button btn-volver"><i class="fa fa-chevron-left"></i></button>
                    {"Capsulas Finalizadas"|x_translate} 
            </h2>

        </div>
        <div class="div-titulos-tabla">
            <h2 class="titulo-tipo">
                {"Tipo"|x_translate} 
            </h2>
            {if $usuario_empresa_logueado.tipo_usuario!='5'}
                <h2 class="titulo-creado">
                    {"Creador"|x_translate} 
                </h2>
            {/if}  

            <h2 class="titulo-visualizaciones">
                {"Visualizaciones"|x_translate} 
            </h2>
        </div>

        {foreach from=$listado_capsulas item=capsula}
            <div class="programa-item ">
                <div style="width: 100%; display: flex;" class="btn btn-white programa-header ajuste-cuestionario" role="button"  >


                    <div style="width: 75%; text-align: left; font-size: 15px;">
            {$capsula.titulo} <span style="position: absolute; left: 415px;">  {if $capsula.tipo_capsula=='1'} {"File"|x_translate}{else if $capsula.tipo_capsula=='2'}{"Link"|x_translate}{else if $capsula.tipo_capsula=='3'}{"Video"|x_translate}{else}{"Vidéo"|x_translate}{/if} </span>    {if $usuario_empresa_logueado.tipo_usuario!='5'}<span style="position: absolute; left: 505px;">  {$capsula.nombre}   {$capsula.apellido}   </span> <span style="position: absolute; left: 710px;">  {$capsula.cant_visitas} </span> {/if}

        </div>
        <div>
            <a>
                <i  data-id="{$capsula.idcapsula}" title="Retirer"  class="fa fa-trash pull-right icono-eliminar btnEliminar"></i>         
            </a> 

            <a target="_blank"  href="{$url}empresa.php?action=1&modulo=capsula&submodulo=capsula_pass_flayer_finalizada&id={$capsula.idcapsula}">
                <i title="Flyer"   class="fa fa-print  pull-right icono-flyer"></i>
            </a> 
            <a  href="{$url}empresa.php?action=1&modulo=capsula&submodulo=informe_capsula_xls&id={$capsula.idcapsula}">
                <i title="Excel"   class="fa fa-file-excel  pull-right icono-excel"></i>
            </a> 

            <a  href="{$url}empresa.php?action=1&modulo=capsula&submodulo=generar_pdf_informe_capsula&id={$capsula.idcapsula}" target="_blank">
                <i title="PDF"  class="fa fa-file-pdf  pull-right icono-pdf"> </i>
            </a>




            <i  data-id="{$capsula.idcapsula}" data-tipo='{$capsula.tipo_capsula}' data-link='{$capsula.link}' title="QR" class="fa fa-qrcode pull-right icono-qr btnGenerarQR"></i>         
            <a href="javascript:;" id="btnGenerarQROculto"  data-toggle="modal" data-target="#modal-compartir-capsula" class="btn btn-xs btn-default  btn-guardar dim-btns btn-generarQR hidden" >{"Generar codigo QR"|x_translate}</a>


        </div>
    </div>
</div>
{/foreach}
</div>

</section>

{literal}
    <script>
        $(function () {

            $("#btnclosemodal").click(function () {
                window.location.href = BASE_PATH + "entreprises/capsulelistacheve.html";
            });
            $(".btnEliminar").click(function () {

                idcapsula = $(this).data("id");
                jConfirm({
                    title: x_translate("Eliminar capsula"),
                    text: x_translate('Una vez eliminada la capsula no podrá ser visualizada!'),
                    confirm: function () {


                        x_doAjaxCall(
                                'POST',
                                BASE_PATH + "empresa.php?action=1&modulo=capsula&submodulo=eliminar_capsula_finalizada",
                                'idcapsula=' + idcapsula,
                                function (data) {
                                    if (data.result) {
                                        window.location.href = BASE_PATH + "entreprises/capsulelistacheve.html";
                                    }
                                }

                        );
                    },
                    cancel: function () {

                    },
                    confirmButton: x_translate("Si"),
                    cancelButton: x_translate("No")
                });
            });

            $(".btnGenerarQR").click(function () {
                idcapsulaQR = $(this).data("id");
                tipo = $(this).data("tipo");
                link = $(this).data("link");
                x_doAjaxCall(
                        'POST',
                        BASE_PATH + "empresa.php?action=1&modulo=capsula&submodulo=obtener_hash_ccapsula",
                        'idcapsula=' + idcapsulaQR,
                        function (data) {
                            //  console.log(data);
                            if (data.result) {
                                x_loadModule('capsula', 'lista_capsulas_finalizadas', 'id=' + data.hash + "&tipo=" + tipo + "&link=" + link, 'Main').then(function () {
                                    $('#btnGenerarQROculto').click();
                                });
                            }
                        }

                );
            });


// lo que esta de aca para abajos es para la copia
            var copyToClipboard = function (elementId) {
                console.log("copy" + elementId);
                var input = document.getElementById(elementId);
                var isiOSDevice = navigator.userAgent.match(/ipad|iphone/i);
                if (isiOSDevice) {

                    var editable = input.contentEditable;
                    var readOnly = input.readOnly;
                    input.contentEditable = true;
                    input.readOnly = false;
                    var range = document.createRange();
                    range.selectNodeContents(input);
                    var selection = window.getSelection();
                    selection.removeAllRanges();
                    selection.addRange(range);
                    input.setSelectionRange(0, 999999);
                    input.contentEditable = editable;
                    input.readOnly = readOnly;
                } else {
                    input.select();
                }

                document.execCommand('copy');
            };
            function CopyToClipboard2(containerid) {
                if (window.getSelection) {
                    //limpiar seleccion
                    if (window.getSelection().empty) {  // Chrome
                        window.getSelection().empty();
                    } else if (window.getSelection().removeAllRanges) {  // Firefox
                        window.getSelection().removeAllRanges();
                    }

                    var range = document.createRange();
                    range.selectNode(document.getElementById(containerid));
                    window.getSelection().addRange(range);
                    document.execCommand("Copy");
                } else if (document.selection) {
                    document.selection.empty();
                    var range = document.body.createTextRange();
                    range.moveToElementText(document.getElementById(containerid));
                    range.select().createTextRange();
                    document.execCommand("Copy");
                }
                var icon_content = "<div class='text-center'><br><img src='" + BASE_PATH + "xframework/app/themes/dp02/imgs/icon-ctrl-v.png' style='width: 50%;'></div>";
                x_alert(x_translate("Ahora pega este mensaje en el cuerpo de tu correo electrónico presionando las teclas Ctrl + V en tu teclado.") + icon_content);
            }
            $("#btn-copy-contenido").click(function () {
                CopyToClipboard2("content_to_copy");
            });


        });
    </script>
{/literal}