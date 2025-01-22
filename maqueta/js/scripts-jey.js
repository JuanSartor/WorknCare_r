var custLookup = $('#patient-lookup');

$(document).ready(function() {

	$('.expand-table').children("tbody").children(" tr:even").click(function(e){
		if($(this).data('display') == 1){
			$(this).data('display', 0);
			$(this).next().removeClass('next-tr');
			$(this).children().eq(3).children().eq(0).removeClass('expanded');
		}else{
			$(this).data('display', 1);
			$(this).next().addClass('next-tr');    
			$(this).children().eq(3).children().eq(0).addClass('expanded');
		}
	});

	$('#VPH-si').change(function(e){ $('#VPH-no').prop('checked', false);});
	$('#VPH-no').change(function(e){ $('#VPH-si').prop('checked', false);});

	$('#inicio-vida-sexual-activa-si').change(function(e){ $('#inicio-vida-sexual-activa-no').prop('checked', false); });
	$('#inicio-vida-sexual-activa-no').change(function(e){ $('#inicio-vida-sexual-activa-si').prop('checked', false); });


	// User progress slider
	var $slider = $("#slider");
	if ($slider.length > 0) {
		$slider.slider({
			disabled: true,
			min: 1,
			max: 4,
			value: 3,
			orientation: "horizontal",
			range: "min"
		});
	}

	$("select").select2({dropdownCssClass: 'dropdown-inverse'});


	// modals
	$('.modal-btn').on('click', function() {
		var targetId = '#' + $(this).data('target');
		$(targetId).modal();
		//console.log(targetId);
	});
	$('.slider-vacunas li').on('click', function() {
		$("#vacuna-aplicada").modal();
	});

	$('.toggle-features').on('click', function() {
		$(this).siblings('.special-features').slideToggle();
	});
	$('.dropdown').on('click', function() {
		$(this).siblings().slideToggle('fast');
	})
	$('.step-btn').on('click', function() {
		var toggleIndicator = $('#signup-steps').find('.active').removeClass();
		$(toggleIndicator).next('li').addClass('active');
	})
	$('.promo-code-btn').on('click', function() {
		$('.promo-code').addClass('active');
	});

	$('button, .role-button').on('click', function(event) {
		var button = event.target;
		var objClass = $(this).attr('class');
		if ($(this).parent('ul') && $(this).parents('ul').attr('id')) {
			var menuOrigin = $(this).parents('ul').attr('id');
		}
		buttonTriggers(button, menuOrigin, objClass);
	});

	// Action Menus

	$('.agenda-header .action').on('click', function(event) {
		event.preventDefault();
		var menu = event.target;
		if ($(menu).data('toggle-menu') !== 'undefined') {
			$(menu).siblings('.action-menu').toggleClass('active');
		}
		if ($(menu).children('.sub-menu').length !== 0 ) {
			var subMenu = $(menu).find('.sub-menu');
			if ($(subMenu).hasClass('property')) {
				$(subMenu).addClass('resize');
				var winHeight = $(subMenu).css('height');
				var winWidth = $(subMenu).css('width');
				$(subMenu).parents('.main-menu').css('height', winHeight);
				$(subMenu).parents('.main-menu').css('width', winWidth);
			}
			$('.main-menu').removeClass('active');
			$(subMenu).toggleClass('active');
		}
		if ($(menu).hasClass('back')) {
			$(menu).parent('.sub-menu').removeClass('active');
			$('.main-menu').addClass('active');
			$('.main-menu').css('height', '');
			$('.main-menu').css('width', '');
		}

	});

	$('.slider-nav').on('click', function() {
		var direction = $(this).data('slide-to');
		var slider = $(this).parent().siblings('.slider');
		var list = $(slider).children('li');
		//var step = $(this).parents('.nav-container').data('slide-value') - 10 + 'px';
		var step = $(this).parents('.nav-container').data('slide-value') + 'px';
		if ((direction) == 'right') {
			//$(this).attr('data-slide-to', 'left');
			$(list).css('transform', 'translateX(-' + step + ')');
		} else {
			//$(this).attr('data-slide-to', 'right');
			$(list).css('transform', 'translateX(15px)');
		};
	});



/**
SELECTOR POR DATA MODAL INLINE
*/
	$('*[data-modalinline="yes"]').click(function(){
		
		var modalclass = $(this).data("modalclass");

		var id = $(this).data("targetinline");

		//Por si viene una clase que se necesita para el modal		
		if(typeof modalclass !== "undefined") {
			$(this).parent().addClass(modalclass);
		}

		//var html_copy = $(this).parent();
		//console.log($(html_copy));
		//var html_copy = $(html_copy)[0].outerHTML;

		if(typeof modalclass !== "undefined"){
			$(this).parent().removeClass(modalclass);
		}


		$('#' + id).find('.modal-body').html($("#" + $(this).data("targetcontent")));
		$('#' + id + '.modal-inside .modal-body').find('.hidden').removeClass('hidden');
		$("#" + id + ".modal-inside").modal();
	});




	//$('.customer-box .data, .popup-box').on('click', function() {
	$('.popup-box').on('click', function() {
		var targetClass = $(this)[0];
		
		$(this).parent().addClass('pop-up');
		
		var html = $(this).parent();
		
		var html = $(html)[0].outerHTML;

		$(this).parent().removeClass('pop-up');
		
		var id = 'modal-box';
		
		modalData(html, id);
	});

	$('#profesionales-frecuentes .dp-email').on('click', function() {
		if($(this).hasClass('show-textarea')){
			$(this).removeClass('show-textarea');
			$(this).next('.enviar-mje').slideUp();
			$(this).parent('li').removeClass('show-textarea-box');
		}else{
			
			$('.enviar-mje').slideUp();
			$("#profesionales-frecuentes .dp-email").removeClass('show-textarea');
			$(this).addClass('show-textarea');
			$(this).next('.enviar-mje').slideDown();
			$(this).parent('li').addClass('show-textarea-box');
		}
	});

	$('.info-btn').on('click', function() {
		if ($(this).siblings('[class^="modal-"]')) {
			var object = $(this).siblings('[class^="modal-"]');
			var parse = object.html();
			modalData(parse);
		}
	});

	// Bootstrap elements behaviour

	$('.modal').on('show.bs.modal', function(e) {
		var windowWidth = $(this).find('.w').css('width');
		if(windowWidth != '0px') {
			$(this).find('.modal-dialog').css('width', windowWidth);
		}
	});

	$('.modal').on('hidden.bs.modal', function(e) {
		$(this).find('.modal-dialog').removeAttr('id');
	});

	$('#patient-lookup').on('input', function() {
		alert('true');
	});

	$(document).on('shown.bs.tab', function (e) {
		if ($(this).attr('class', 'w')) {
			var object = $(e.target).attr('href');
			var windowWidth = $(object).css('width');
			var test = $(object).parents('.modal-dialog').css('width', windowWidth);
		}
	})

	$('.carousel').on('slid.bs.carousel', function () {
		var carousel_id = $(this).attr('id');
		var indicators = $('li[data-target="#' + carousel_id + '"]').closest('.carousel-indicators');
		indicators.find('li.active').removeClass('active');
		var idx = $(this).find('.item.active').index();
		indicators.find('li[data-slide-to="' +  idx + '"]').addClass('active');
	});

	$('#compare-btn').on('click', function() {
		$('#comparison-table').slideToggle('fast');
	});


	$('.toggle-info-box').on('click', function() {
		$('#info-pacientes .fold').slideToggle();
		
	    if ($(this).text() === 'Ocultar menú') {
	        $(this).html('Mostrar menú');
	        $(this).addClass('info-position');
	    } else {
	        $(this).html('Ocultar menú');
	        $(this).removeClass('info-position');
	    }	
	    return false
	});



	$('.active-user').on('click', function() {
		$(".perfil-dropdown" ).stop().slideDown();
	    return false;
	});
	$('.dp-arrow-down').parent('span').on('click', function() {
		$(".perfil-dropdown" ).stop().slideUp();
	    return false;
	});	
	



	$('.icon-notificaciones').on('click', function() {
		$('#notificaciones').slideToggle();
	    return false;
	});
	
	$('.btn-slider').on('click', function() {
		var targetId = '#' + $(this).data('target');
		console.log(targetId);
		if(targetId == "#agregar-paciente"){
			$(targetId).slideDown();
			$("#lista-pacientes").slideUp();
		}else if(targetId == "#lista-pacientes"){
			$(targetId).slideDown();
			$("#agregar-paciente").slideUp();
		}else{
			$(targetId).slideToggle();
			if(targetId != "#opcion-renovacion"){
				$("#opcion-renovacion").slideUp();
			}else{
				$(".opcion-receta").slideUp();
			}	
		}


	});


	if($(".slider-menu").length){
		$('.slider-menu').slick({
			centerMode: false,
			dots: false,
			draggable: false,
			focusOnSelect: false,
			infinite:false,
			nextArrow: '.slider-menu-next',	
			prevArrow: '.slider-menu-prev',
			slidesToScroll: 11,
			slidesToShow: 11,
			touchMove:false,
			responsive: [
			    {
			      breakpoint: 1024,
			      settings: { slidesToShow: 6,  slidesToScroll: 6,}
			    },
			    {
			      breakpoint: 768,
			      settings: {slidesToShow: 4, slidesToScroll: 4,}
			    },		    
			    {
			      breakpoint: 600,
			      settings: {slidesToShow: 3,slidesToScroll: 3,}
			    },
			    {
			      breakpoint: 480,
			      settings: {slidesToShow: 2,slidesToScroll: 2}
			    }
			]
	    });	
	}



});

function buttonTriggers(button, menuOrigin, objClass) {

	if ($(button).data('modal') == 'yes') {
		var object = $(button).next('[class^="modal-"]');
		var parse = object.html();

		if ($(button).attr('id')) {
			var id = $(button).attr('id');
		}
		modalData(parse, id);
	}
}

function modalData(data, id) {
	if (typeof id !== 'undefined'){
		$('.modal-inside').find('.modal-dialog').attr('id', id);
	}
	$('.modal-inside').find('.modal-body').html(data);
	$('.modal-inside .modal-body').find('.hidden').removeClass('hidden');
	$('.modal-inside').modal();

	if($('.modal-inside').find('li a').hasClass('gallery-imc')){
		$('.gallery-imc').featherlightGallery({
			gallery: { fadeIn: 300,	fadeOut: 300}
		});
	}
	if($('.modal-inside').find('li a').hasClass('gallery-perc')){
		$('.gallery-perc').featherlightGallery({
			gallery: { fadeIn: 300,	fadeOut: 300}
		});
	}
}


