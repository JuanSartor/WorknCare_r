<style>

    .mvc-video-guia h2 {
        margin: 0;
        padding: 24px;
        font-size: 24px;
        font-weight: 500;
    }
    .mvc-video-guia label {
        font-size: 18px;
        line-height: 1.5;
        font-weight: 600;
        margin-bottom: 14px;
    }
    .video-container{
        margin-bottom: 24px;
    }
    @media (max-width: 600px){
        .mvc-video-guia h2 {
            padding-top: 12px;
            padding-bottom: 12px;
            font-size: 18px;
        }
        .mvc-video-guia label {
            font-size: 16px;
            font-weight: 500;
            margin-bottom: 14px;
        }
    }
</style>
<section class="mmc-detale-consulta mvc-video-guia row">
    <div class="okm-container">
        <h2 class="mmc-title"><i class="icon-doctorplus-info-circle" style="margin-right: 10px"></i>{"Consejos"|x_translate}</h1>


            <div class="text-center  col-md-6 col-xs-12 video-container">
                <label>{"¿Cómo completar la información de su consultorio?"|x_translate}</label>
                <iframe width="100%" height="310"  src="https://www.youtube.com/embed/mezRT6kvJC8" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>            
            </div>
            <div class="text-center  col-md-6 col-xs-12 video-container">
                <label>{"¿Cómo invitar a un paciente?"|x_translate}</label> 
                <iframe width="100%" height="310"  src="https://www.youtube.com/embed/lIakxsO3iWs" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>            
            </div>
            <div class="text-center  col-md-6 col-xs-12 video-container">
                <label>{"¿Cómo agenda un turno de Video Consulta?"|x_translate}</label>
                <iframe width="100%" height="310"  src="https://www.youtube.com/embed/hPTph27560k" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>            
            </div>
            <div class="text-center  col-md-6 col-xs-12 video-container">
                <label>{"¿Cómo reponder una solicitud de Consulta Express?"|x_translate}</label>
                <iframe width="100%" height="310"  src="https://www.youtube.com/embed/EANk5Yuw8FY" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>            
            </div>
            <div class="text-center  col-md-6 col-xs-12 video-container">
                <label>{"¿Cómo reponder una solicitud de Video Consulta?"|x_translate}</label>
                <iframe width="100%" height="310"  src="https://www.youtube.com/embed/DdzG9We5uEM" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>            
            </div>
            <div class="text-center  col-md-6 col-xs-12 video-container">
                <label>{"¿Cómo gestionar la sala de espera virtual?"|x_translate}</label>
                <iframe width="100%" height="310"  src="https://www.youtube.com/embed/TTN_x_xmEgs" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>            
            </div>
            <div class="text-center  col-md-6 col-xs-12 video-container">
                <label>{"¿Cómo hacer la receta médica?"|x_translate}</label>
                <iframe width="100%" height="310"  src="https://www.youtube.com/embed/tTLOAgyyR48" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>            
            </div>
            <div class="text-center  col-md-6 col-xs-12 video-container">
                <label>{"¿Cómo resolver un problema de sonido?"|x_translate}</label>
                <iframe width="100%" height="310"  src="https://www.youtube.com/embed/dEvN0_9RDrY" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>            
            </div>
            <div class="text-center  col-md-6 col-xs-12 video-container">
                <label>{"¿Cómo resolver un problema de conexión?"|x_translate}</label>
                <iframe width="100%" height="310"  src="https://www.youtube.com/embed/F52WkkwrOxs" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>            
            </div>
    </div>
</section>
<div class="col-xs-12">
    {include file="videoconsulta/guia_uso.tpl"}
</div>

<div class="row text-center">
    <a  href="{$url}panel-medico/" class="btn btn-blue">{"volver"|x_translate}</a>
</div>