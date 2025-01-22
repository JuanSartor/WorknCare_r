<style>

    .ce-nc-step-holder ul.ce-nc-steps>li.ce-nc-step figure {
        display: block;
        width: 40px;
        height: 40px;
        line-height: 40px;
    }
    .ce-nc-main-nav {
        min-height: 100px;


        padding-top: 48px;
        padding-bottom: 8px;
    }
    .ce-nc-main-nav .steps-title{
        font-size:24px;
        color:#fff;
    }
    @media(max-width:600px){
        .ce-nc-main-nav {
            min-height: 50px;
            padding-top: 12px;
            padding-bottom: 12px;
        }
        .bst-p3-user-data li p {
            margin-left: 50px;
        }
    }

    .bst-paso-1,.bst-paso-2,.bst-paso-3 {
        position: absolute;
        top: -31px;
        right: -20px;
        font-size: 14px;
        color: #fff;
    }
    .bst-box.medico ul li {
        padding: 4px 16px;
    }
    .bst-medico-data-list li {
        padding: 4px 16px;
    }

    .bst-box.medico ul li figure {
        display: block;
        width: 30px;
        height: 30px;
        position: absolute;
        top: 8px;
        left: 16px;
        line-height: 30px;
        text-align: center;
        font-size: 24px;
        color: #02B8C1;
    }

    .bst-box.paciente img {
        display: inline-block;
        margin:  16px;
        position: absolute;
    }
    .bst-box.paciente .paciente-data {
        display: inline-block;
        padding-left: 82px;
    }

    .bst-box.paciente span {
        padding-top: 12px;
        padding-bottom: 12px;
    }
    .bst-box.paciente h3 {
        padding-top: 12px;
    }
    .bst-p3-user-data li {
        padding: 8px;
    }

</style>
<nav class="ce-nc-main-nav bst-nav-turno">
    <input type="hidden" id="idturno" value="{$turno.idturno}"/>
    <div class="container">
        <div class="row">
            <div class="col-xs-12 col-sm-6 col-md-4 ce-nc-back-holder ">
                <span class="steps-title">{"Sacar turno"|x_translate}</span>

            </div>
            <div class="col-xs-10 col-sm-6 col-md-8 ce-nc-step-holder  hidden-xs">
                <ul class="ce-nc-steps">
                    <li class="ce-nc-step">
                        <span class="bst-paso-1">{"Detalles del turno"|x_translate}</span>
                        <div class="ce-nc-step-divider"></div>
                        <figure>1</figure>
                    </li>
                    {*
                    <li class="ce-nc-step">
                        <span class="bst-paso-2">{"Identificación o registro"|x_translate}</span>
                        <div class="ce-nc-step-divider"></div>
                        <figure>2</figure>
                    </li>
                    *}
                    <li class="ce-nc-step">
                        <span class="bst-paso-3">{"Confirmación"|x_translate}</span>
                        <div class="ce-nc-step-divider"></div>
                        <figure>2</figure>
                    </li>
                </ul>
            </div>
        </div>
    </div>
</nav>
<!--	@PASOS NAV-->