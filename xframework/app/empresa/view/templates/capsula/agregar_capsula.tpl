<style>
    .dim-btns{
        width: 280px;
        margin-top: 15px;
    }
    .btn-sig-etapa{
        background: white;
        color: #3DB4C0;
        border: solid;
    }
    .font-iconos{
        font-size: 20px;
    }
    .btn-agregar-pregunta:hover {
        background: white !important;
        color: #77cbd3 !important;
        border: solid;
    }
    .label-personalizar{
        margin-bottom: 15px;
        font-size: 15px;
        font-weight: 600;
    }
    .input-personalizar{
        margin-bottom: 15px;
        padding-left: 10px;
    }
    .title-preguntas{
        font-size: 18px;
        margin-top: 55px;
    }
    .container-btn{
        margin-top:70px;
    }
    .input-title{
        width: 433px !important;
    }
    .pregunta-item{
        margin-bottom: 5px;
    }
    .circulo {
        width: 30px;
        height: 30px;
        -moz-border-radius: 50%;
        -webkit-border-radius: 50%;
        border-radius: 50%;
        background: #5cb85c;
        position: absolute;
    }
    .rectangulo {
        width: 45px;
        height: 16px; 
        position: relative;
        top: 7px;
        margin-left: 26px;
    }
    .label-rta{
        font-size: 10px;
        line-height: 1.5;
        font-weight: 600;
        color: #c6cbc6;
    }
    .dim-btn-mod-particular{
        width: 200px;
    }
    .cursors:hover {
        cursor: pointer;
    }
    .modo-select{
        border: 2px solid #82B9EE;
    }
    .img-cerrada{
        width: 80px;
        height: 20px;
    }
    .seleccionado{
        box-shadow: 1px 1px 10px 2px #3c3c3c;
    }
    ul{
        padding: 0px;
        margin: 0px;
    }
    #mi_lista li{
        list-style: none;
        cursor:pointer;
    }

</style>
<section class="okm-container" id="personalizadsec">
    <!-- primer columna -->
    <input  id="idcuestionario" hidden value='{$cuestionario.idcuestionario}'>
    <input  id="idempresaCues" hidden value='{$cuestionario.empresa_idempresa}'>
    <input  id="cantPreguntas" hidden value='{$listado_preguntas|@count}'>
    <input  id="estadoCuestionario" hidden value='{$cuestionario.estado}'>
    <input  id="cant_capsulas_lista" hidden value='{$cant_capsulas_lista}'>


    <div class="col-xs-6 programas-incluidos">
        <h2 class="title">
            <button onclick="location.href = 'JavaScript:window.history.back();'"  class="btn btn-transparen go-back-button btn-volver"><i class="fa fa-chevron-left"></i></button>
                {"Volver"|x_translate}       
        </h2> 
        <div class="container-inputs" style="margin-top: 50px;">
            <div class="col-xs-12">
                <label  class="mapc-label label-personalizar"> {"Añadir titulo"|x_translate}</label>
                <input id="input_titulo" minlength="1" maxlength="30" class="input-personalizar input-title" type="text"  value="{$capsu.titulo}" placeholder="{$capsu.titulo}"/>
            </div>

        </div>
    </div>
    <!-- segunda columna -->
    <div class="col-xs-6 preguntas-incluidas">
        {if $banderaCapsula == '1'}
            <div class="okm-row text-center container-btn">
                <div class="container-datos-bancarios">
                    {include file="capsula/file.tpl"}
                </div>
            </div>
        {/if}  
        {if $banderaCapsula == '2'}
            <div class="okm-row text-center container-btn">
                <div class="container-datos-bancarios">
                    {include file="capsula/link.tpl"}
                </div>
            </div>
        {/if}
        {if $banderaCapsula == '3'}
            <div class="okm-row text-center container-btn">
                <div class="container-datos-bancarios">
                    {include file="capsula/video.tpl"}
                </div>
            </div>
        {/if}
    </div>
    <div class="col-xs-12">
        {if $banderaCapsula == '4'}
            <div class="okm-row text-center ">
                <div class="container-datos-bancarios">
                    {include file="capsula/grabar_video.tpl"}
                </div>
            </div>
        {/if}
    </div>

    <div class="clearfix">&nbsp;</div>
</section>



{literal}
    <script>
        $(function () {


        });
    </script>
{/literal}