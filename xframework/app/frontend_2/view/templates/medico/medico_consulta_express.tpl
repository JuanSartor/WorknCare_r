{include file="medico/menu.tpl"}

{include file="home/login.tpl"}


<section class="mcex-top">
	<div class="okm-container mcex-top-box">
		<img src="{$IMGS}medico/medico-consulta-express.jpg" title='{"Dr. Plus - Médico Consulta Express"|x_translate}'/>
		
		<div class="mcex-top-data-box">
			<figure>
				<i class="icon-doctorplus-chat"></i>			</figure>
			<h1>{"Consulta Express"|x_translate}</h1>
			<p>
			{"La innovadora herramienta de consulta a distancia que le permite capitalizar sus consejos y consultas médicas fuera de su consultorio."|x_translate}</p>
		</div>
	</div>
<div class="okm-container mcex-top-bottom-disclaimer-box">
		{"DoctorPlus promueve las consultas a profesionales y la no búsqueda de consejos por internet para solucionar cuestiones relacionadas a la salud."|x_translate}
	</div>
</section>	

<section class="mcex-content-top">
	<p> {"Hemos creado la herramienta de Consulta Express que lo ayudarán a atender la demanda de pacientes digitalizados y a controlar y cuidar mejor de su salud."|x_translate}
	</p>
	<p> {"Está diseñada para funcionar tanto desde tu dispositivo Android, tablet o notebook."|x_translate}
	</p>
</section>
	
<section class="mcex-content">
	<h3>{"¿Cómo funciona?"|x_translate}</h3>
	<p> {"La Consulta Express es una herramienta que le permite a los pacientes realizar una consulta menor, evacuar una duda o solicitar un consejo médico a un profesional de su elección mediante el intercambio de mensajes."|x_translate}</p>
	<p> {"Las Consulta Express pueden ser aranceladas o  bonificadas según el criterio del  profesional para determinados pacientes*. La tarifa de la misma es determinada por cada profesional que ofrece sus servicios a través de DoctorPlus."|x_translate}	</p>
        <p> {"El paciente abona la Consulta Express antes de realizarla."|x_translate}</p>
	<p> {"DoctorPlus gestiona el cobro y lo computa en la cuenta del profesional  una vez conluida la consulta."|x_translate}</p>
	<p>{"*Servicio ofrecido para las Cuentas Profesionales - Máximo hasta 50 pacientes con atención sin cargo."|x_translate}</p>
  <h4>{"CONSULTA RECHAZADA"|x_translate}</h4>
	<p>{"En el caso de que el profesional lea el motivo de la consulta enviado por el paciente y considere que no puede brindar el consejo profesional adecuado por este medio (ej.  porque considera que el paciente debe concurrir a su consultorio para evaluarlo personalmente, porque considera que el paciente debe concurrir a una guardia para una mejor atención, porque la consulta no es de su competencia, etc.), el profesional puede rechazar la consulta y el importe de la misma es reintegrado al paciente."|x_translate}</p>	
	<h4>{"CONSULTA ANULADA"|x_translate}</h4>
	<p>{"El profesional tiene dos horas para aceptar una solicitud de Consulta Express. Pasado dicho plazo el sistema automáticamente anula la consulta y el importe abonado por la misma es reintegrado al paciente."|x_translate}	</p>
	
	<h4>{"CONSULTA CANCELADA"|x_translate}</h4>
	
	<p>{"El paciente puede cancelar en cualquier momento las solicitudes de Consulta Express que aún no hayan sido respondidas por el profesional."|x_translate}</p>
	
	<h4>{"CONSULTA ABIERTA"|x_translate}</h4>
	
	<p>{"Si el profesional decide aceptar la consulta de su paciente y responderla se inicia una conversación a través de un intercambio de mensajería instantánea con avisos de respuesta sincronizada entre diferentes dispositivos (sms o mail) Durante la conversación se pueden compartir fotografías e imágenes. Los mensajes de respuesta del profesional pueden ser de texto o de voz. El intercambio de mensajes se almacenará automáticamente en el historial de la cuenta del paciente y del profesional quedando así un registro médico de dicha consulta."|x_translate}</p>
	
  <h4>{"CONSULTA CERRADA"|x_translate}</h4>
	
	<p>{"El profesional decide cuándo considera que la consulta ha concluido y la Consulta Express se dá por cerrada. En caso de que el paciente desee hacer otra consulta deberá crear una nueva Consulta Express. Al cerrar una Consulta Express el profesional debe completar un formulario con sus conclusiones las que quedarán almacenadas en historial de registros médicos del paciente (Historia Clínica Digital)"|x_translate} </p>
	
  <h4>{"REGISTRO DE CONSULTAS MEDICAS"|x_translate}</h4>
	
	<p>{"Al finalizar una Consulta Express o una Video Consulta, el profesional deberá dejar registro de sus conclusiones. Los datos ingresados alimentarán el Perfil de Salud del paciente y la información quedará disponible, en caso de que el paciente lo autorice, para ser consultado por otros profesionales registrados en el sitio. Por normas de secreto profesional las conclusiones no serán visibles para el paciente. El paciente solamente podrá visualizar los contenidos ingresados en los campos de prescripción y diagnóstico. Los cuales le servirán como recordatorio de las indicaciones y tratamiento aconsejado por el profesional."|x_translate}</p>
</section>


<section>
    <div class="carousel slide" data-ride="carousel">

        <div class="item portada-item-2">
            <div class="item active portada-item-2-inner">
                <div class="portada-item-2-card">
                    <h2>{"¡Aumente su capacidad productiva!"|x_translate}</h2>
                    <p>{"Ofrezca sus servicios de Consulta Express a todos los pacientes registrados en DoctorPlus"|x_translate}</p>
                    <p class="bajada">{"Ud. atienda la consulta. DoctorPlus se encarga de gestionar su cobro."|x_translate}</p>
                    <div class="lnk-holder">
                        <a href="#">
                            <figure><i class="icon-doctorplus-people-add"></i></figure>
                            <span>{"PROFESIONALES EN LA RED"|x_translate}</span>
                        </a>
                    </div>

                </div>
            </div>
        </div>

    </div>

    <!-- Controls -->
</div>

<div class="consulta-portada-shadow"></div>
</section>	


{literal}
<script>

    $(function () {


        //formulario envio mail conactto
        $("#btnEnviarMailContacto").click(function(e) {
         
            e.preventDefault();
            // Clean up any tooltips for valid elements
              
                
                $("#f_contacto input:required").each(function(){
                    if($(this).val()==""){
                       $(this).data("title", x_translate("Este campo es obligatorio"))
                                .tooltip("show" );
                    }
                   return false;
                });
              
                if($("#f_contacto textarea").val()==""){
                       $("#f_contacto textarea").data("title", x_translate("Este campo es obligatorio"))
                                .tooltip("show" );
                        
                    }
               
                    //expresion regular para mail
                     if (!validarEmail($("#email_contacto").val())){
                       $("#email_contacto").data("title", x_translate("Ingrese un email valido"))
                                .tooltip("show" );
                         return false;
                    }
                    
                    
            $("#Main").spin("large");
            x_sendForm(
                    $('#f_contacto'),
                    true,
                    function(data){
                        $("#Main").spin(false);
                        x_alert(data.msg);
                    });
        });



        function mulScroll(trgObj) {
            var trgObjHeight = trgObj.outerHeight();
            $('html, body').animate({
                scrollTop: (trgObj.offset().top - trgObjHeight) - 60
            }, 1000);
        }



        $('.hom-servicios-slide').slick({
            dots: false,
            infinite: true,
            speed: 300,
            arrows: false,
            autoplay: true,
            autoplaySpeed: 8000,
            adaptiveHeight: true
        });

        $('.hslide').on("click", function (e) {
            e.preventDefault();
            //scrollToObj($('#srv-slide-0'));
            var slideNumer = $(this).data('slide');
            $('.hom-servicios-slide').slick('slickGoTo', slideNumer);
        });


		$('.hom-slide').on('init', function(event, slide){
			$('.hom-slide').find('.slick-dots').find('button').on('click',function(e){
						slide.slickSetOption('autoplay',false);
			});
		});
        $('.hom-slide').slick({
			dots: true,
			infinite: true,
			speed: 300,
			arrows: false,
			autoplay: true,
			autoplaySpeed: 8000,
			adaptiveHeight: true,
			pauseOnFocus: true,
			pauseOnHover: true,
			pauseOnDotsHover: true,
			adaptiveHeight: true
		});
		$('.hom-slide').on('swipe',function(event, slide, direction){
			slide.slickSetOption('autoplay',false);
		});

        $('#hom-nav-rsp-trg').on('click', function (e) {
            e.preventDefault();

            $('#hom-nav-rsp-get').toggleClass('menu-show');

        });

        $(window).on('scroll', function () {
            var currentTop = $(window).scrollTop();

            if (currentTop >= 60) {
                $('.hom-nav').addClass('transparent');
            } else if (currentTop < 60) {
                $('.hom-nav').removeClass('transparent');
            }

        });




        var menuEl = $('#hom-nav-rsp-get').children('li').children('a');

        menuEl.on('click', function (e) {
      

            if (typeof $(this).data('lnk') !== 'undefined') {
                var lnkTo = "#" + $(this).data('lnk');
                mulScroll($(lnkTo));
            }


            if ($('#hom-nav-rsp-get').hasClass('menu-show')) {
                $('#hom-nav-rsp-get').removeClass('menu-show');
            }

        });


    });
</script>
{/literal}