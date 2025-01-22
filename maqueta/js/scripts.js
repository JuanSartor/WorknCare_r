var custLookup = $('#patient-lookup');
(function ($) {

/// funciones globales:
	function mulScroll(trgObj){
		var trgObjHeight = trgObj.outerHeight();
		$('html, body').animate({
			scrollTop:(trgObj.offset().top - trgObjHeight) - 60
		}, 1000);
	}
	
	// va directo al elemento sin el top
	function scrollToEl(trgObj){
		var trgObjHeight = trgObj.outerHeight();
		$('html, body').animate({
			scrollTop: trgObj.offset().top - 60
		}, 1000);
	}
	
	
	//--	
	
	function textcut(objClass, lines){
			
		$(objClass).each(function(i,val){
		//foreach
		
		if($(this).children('span').children('p').length == 0){
		
		var el = $(this);
		
		var fontSize = el.css('font-size').match(/\d+/)[0];
		var lineHeight = el.css('line-height').match(/\d+/)[0];
		var lineHeightRem = lineHeight/14;
		var linesToShow = lines;
		
		var parentHeight = fontSize*lineHeightRem*linesToShow;
		
		//console.log(totalHeight+" ---- "+parHeight);
		el.css({
			"display"	: "block", 
			"display"	: "-webkit-box",
			"font-size": fontSize,
			"line-height": lineHeightRem,
			"height"	: parentHeight,
			"-webkit-box-orient"	: "vertical",
			"overflow"	: "hidden"
		});
	
		var totalHeight = el.children('span').innerHeight();
//		
//		console.log("Span H: "+totalHeight);
//		console.log("P H: "+parHeight);
		
	
		if(totalHeight > parentHeight){
		el.after('<a href="#" class="text-cut-lnk-mas">ver más</a');
		
		el.next('a.text-cut-lnk-mas').bind('click',function(e){
			e.preventDefault();
			var parEl = $(this).prev(objClass).outerHeight();
			
			if(parEl < totalHeight){
				$(this).prev(objClass).animate({
					height: totalHeight+16
				}, 600);
				$(this).html('ver menos');
			}else if(parEl >= totalHeight){
				$(this).prev(objClass).animate({
					height: parentHeight
				}, 600);
				$(this).html('ver más');
			}
			
			
		});
		
		}
		

		//-->if general
		}else if($(this).children('span').children('p').length > 0){
			
			var el = $(this);
			var par = el.children('span').children('p');

			var parTotalLines = 0;
			var parTotal = el.children('span').children('p').length;
			var linesToShow = lines;

			var cantLinesCount = 0;

			var cantLinesPerPar = new Array();

//			totalHeight = el.outerHeight();

			par.each(function(z,valz){
				// calculo y reseteo de los parrafos
				fontSize = $(this).css('font-size').match(/\d+/)[0];
				lineHeight = $(this).css('line-height').match(/\d+/)[0];
				parPadding = par.css('margin-bottom');


				var parLineHeight = lineHeight;


				// setteo de los parrafos
				$(this).css({
					"font-size": fontSize,
					"line-height": lineHeight+'px',
					"margin-top": 0,
					"margin-bottom": parPadding
				});

				var parHeight = $(this).outerHeight();
				var cantParLines = parHeight/lineHeight;

				parTotalLines += parseInt(cantParLines);

				cantLinesPerPar[z] =  parseInt(cantParLines);
			});

			
			totalHeight = el.outerHeight();
			//cantidad de parra fos a mostrar para calcular los margenes

			var cantParToshow = 0;

			// si las lineas totales abarcan mas de 1 parrafo
			if(parTotalLines > linesToShow){
				// cuantos parrafos abarcan el total de lineas

				var tempParLinesCount = 0;

				for(h=0; h < parTotal; h++){

					if(tempParLinesCount < linesToShow){
						tempParLinesCount += cantLinesPerPar[h];
						cantParToshow += 1;
					}

				}

			}
			var parPaddingClean = parseInt(parPadding.match(/\d+/)[0]);
			var parMarginToShow = parseInt((cantParToshow-1)*parPaddingClean);
			var parHeightToShow = linesToShow*lineHeight;
			var heightToShow = parMarginToShow + parHeightToShow;

			//console.log(el.data('name')+" - "+heightToShow+" alto inni:  "+totalHeight);

			//console.log(heightToShow);
			
			
			if(heightToShow < totalHeight){
			
			el.css({
				"display"	: "block", 
				"height"	: heightToShow+"px",
				"-webkit-box-orient"	: "vertical",
				"overflow"	: "hidden"
			});
			
			}

			parentHeight = heightToShow;
			
			
			if(totalHeight > parentHeight){
				el.after('<a href="#" class="text-cut-lnk-mas">ver más</a');

				el.next('a.text-cut-lnk-mas').bind('click',function(e){
					e.preventDefault();
					var parEl = $(this).prev(objClass).outerHeight();

					if(parEl < totalHeight){
						$(this).prev(objClass).animate({
							height: totalHeight+16
						}, 600);
						$(this).html('ver menos');
					}else if(parEl >= totalHeight){
						$(this).prev(objClass).animate({
							height: parentHeight
						}, 600);
						$(this).html('ver más');
					}



				});

			}
		//@if general	
		}
		//@foreach
			
	});
		
	
	//--	
	}
	
	
	if($('.text-cut').length > 0){
		textcut('.text-cut',$('.text-cut').data('lines') );
	}
	
	

	function scrollToObj(trgObj){
				var trgObjHeight = trgObj.outerHeight();
				$('html, body').animate({
					scrollTop: trgObj.offset().top - trgObjHeight
				}, 1000);
	}
	
	
	
	
	
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
		var menu = event.currentTarget;
		if ($(menu).data('toggle-menu') !== 'undefined') {
			$(menu).siblings('.action-menu').toggle(function(){
				usr_click_outside_menu();
			});
		
		}
		if ($(menu).children('.sub-menu').length !== 0 ) {
			var subMenu = $(menu).find('.sub-menu');
			if ($(subMenu).hasClass('property') && !$(subMenu).hasClass('active')) {
				$(subMenu).addClass('resize');
				var winHeight = $(subMenu).css('height');
				var winWidth = $(subMenu).css('width');
				$(subMenu).parents('.main-menu').css('height', winHeight);
				$(subMenu).parents('.main-menu').css('width', winWidth);
			}else if($(subMenu).hasClass('property') && $(subMenu).hasClass('active')){
				$('.main-menu').addClass('active');
				$('.main-menu').css('height', '');
				$('.main-menu').css('width', '');
			}
			$('.main-menu').removeClass('active');
			$(subMenu).toggleClass('active');
		}
		if ($(menu).hasClass('back')) {
			

			
			if($(menu).parent('.sub-menu').hasClass('property')){
				$(menu).parent('.sub-menu').removeClass('resize');
			}
			$('.main-menu').addClass('active');
			$('.main-menu').css('height', '');
			$('.main-menu').css('width', '');
	
		}

		
		
	});
	
	//agenda-action-menu
	function usr_click_outside_menu(){
		if($('#agenda-menu').length > 0){
		$(document).on('click', function(event){
			//event.preventDefault();

			if (
				$('#agenda-menu').has(event.target).length == 0
				&&
				!$('#agenda-menu').is(event.target)
			){
				if(
					$('#agenda-menu').find('.action-menu').is(':visible')){
					$('#agenda-menu').find('.action-menu').hide();
				}	
			//	
				
			}
		});
	}
	}

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
	})

	// $('.customer-box .data, .popup-box').on('click', function() {
	// 	var targetClass = $(this)[0];
	// 	$(this).parent().addClass('pop-up');
	// 	var html = $(this).parent();
	// 	var html = $(html)[0].outerHTML;
	// 	$(this).parent().removeClass('pop-up');
	// 	var id = 'modal-box';
	// 	modalData(html, id);
	// });

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
	});

	$(document).on('shown.bs.tab', function (e) {
		if ($(this).attr('class', 'w')) {
			var object = $(e.target).attr('href');
			var windowWidth = $(object).css('width');
			var test = $(object).parents('.modal-dialog').css('width', windowWidth);
		}
	})

	/*$('.carousel').on('slid.bs.carousel', function () {
		var carousel_id = $(this).attr('id');
		var indicators = $('li[data-target="#' + carousel_id + '"]').closest('.carousel-indicators');
		indicators.find('li.active').removeClass('active');
		var idx = $(this).find('.item.active').index();
		indicators.find('li[data-slide-to="' +  idx + '"]').addClass('active');
	});*/

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
	
	$('.btn-slider').on('click', function(e) {
		e.preventDefault();
		
		var targetId = '#' + $(this).data('target');
		var targetClass = '.' + $(this).data('target');
		
		if(targetId == "#agregar-paciente"){
			
			$(targetId).slideDown(
				{
				done:	function(){
					scrollToEl($(targetId));
					}
			});
			$("#lista-pacientes").slideUp();
			$("#lista-sin-cargo").slideUp();
			
		}else if(targetId == "#lista-pacientes"){
			
			$(targetId).slideDown(
				{
					done:	function(){
						scrollToEl($(targetId));
					}
				});
			$("#agregar-paciente").slideUp();
			$("#lista-sin-cargo").slideUp();
			
			
		}else if(targetId == "#lista-sin-cargo"){

			
			$("#agregar-paciente").slideUp();
			$("#lista-pacientes").slideUp();
			$(targetId).slideDown(
				{
					done:	function(){
						scrollToEl($(targetId));
					}
				});
			
		}else if(targetClass == ".datos-nuevo-paciente"){
			
			$(targetClass).slideToggle();
			
		}else{			
			// $(targetClass).slideToggle();
			$(this).parents('.item-contenido').children(targetClass).slideToggle();
			if(targetClass != ".opcion-renovacion"){
				$(this).parents('.item-contenido').children(".opcion-renovacion").slideUp();
			}else{
				$(this).parents('.item-contenido').children(".opcion-receta").slideUp();
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


	/// consulta express nueva consulta tabla precios
	if($('.ce-ultimos-consumos').length > 0){
		cflag = true;
		$('.ce-ultimos-consumos').on('click', function(e){
			e.preventDefault();
			
			if(cflag){
				$('.ce-nc-consulta-precios-tabla-holder').slideDown();
				$(this).children().toggleClass('nc-rotate');
				cflag = false;
			}else{
				$('.ce-nc-consulta-precios-tabla-holder').slideUp();
				$(this).children().toggleClass('nc-rotate');
				cflag = true;
			}
			
		});
	}
	
	if($('.ce-nc-footer-table-lnk-action').length > 0){
		$('.ce-nc-footer-table-lnk-action').on('click', function(e){
			e.preventDefault();
			$('.ce-nc-pagination').show();
		});
	}
	
	
	function getScrollBarWidth() {
		var inner = document.createElement('p');
		inner.style.width = "100%";
		inner.style.height = "200px";

		var outer = document.createElement('div');
		outer.style.position = "absolute";
		outer.style.top = "0px";
		outer.style.left = "0px";
		outer.style.visibility = "hidden";
		outer.style.width = "200px";
		outer.style.height = "150px";
		outer.style.overflow = "hidden";
		outer.appendChild (inner);

		document.body.appendChild (outer);
		var w1 = inner.offsetWidth;
		outer.style.overflow = 'scroll';
		var w2 = inner.offsetWidth;
		if (w1 == w2) w2 = outer.clientWidth;

		document.body.removeChild (outer);

		return (w1 - w2);
	};
	
	function getViewportWidth(){
		return $(window).width() + getScrollBarWidth();
	}
	
	function tablaprecios(vpw){
		if(vpw < 800 ){

			$('.nc-td').children('i').show();

			$('.nc-row').on('click', function(e){
				
				//cambiar texto
				texto = $(this).find('[data-type="tipo"]').text();
				$(this).next('.nc-row-small').find('.nc-td').last().html(texto);
				
				//muetra row
				hrow = $(this).next('.nc-row-small');
				
				if($(hrow).is(":visible")){
					$(hrow).hide();
				}else{
					$(hrow).show();
				}
				
				
				symbolPlus = $(this).find('i')
				
				if(symbolPlus.hasClass('icon-doctorplus-circle-add')){
					//open
					symbolPlus.removeClass('icon-doctorplus-circle-add')
						.addClass('icon-doctorplus-circle-minus')
						.addClass('nc-symbol-red');
					$(this).find('.nc-td').addClass('nc-td-border');
					
					
					
					
				}else if(symbolPlus.hasClass('icon-doctorplus-circle-minus')){
					//close
					symbolPlus.removeClass('icon-doctorplus-circle-minus')
						.addClass('icon-doctorplus-circle-add')
						.removeClass('nc-symbol-red');
				}
				
				
				
			});
		}else{
			$('.nc-td').children('i').hide().stop();
			$('.nc-row').off('click');
			$('.nc-row-small').hide();
		}
	}
	
	if($(".nc-tabla-precios").length > 0){
		var vpw = $(window).width() + getScrollBarWidth();
		tablaprecios(vpw);
		
		$(window).resize(function() {
			var vpw = $(window).width() + getScrollBarWidth();
			//vpw = jQuery('body').width() + getScrollBarWidth();
			tablaprecios(vpw);
		});
		
	}
	
	// nueva consulta checkbox toolbar
	
	if($('.cs-nc-p2-toolbar-right').length > 0){
		
		$(':checkbox').radiocheck();
	}
	

	
	if(($('.paciente-nav-trigger').length > 0) || ($('.paciente-nav-menu-burger').length > 0)){
		$('.paciente-nav-trigger').on('click',function(e){
			e.preventDefault();
			$pacienteMenu = $('#paciente-menu');
			$pacienteMenu.toggleClass('menu-show');

		});


		$('.paciente-nav-menu-burger').on('click',function(e){
			e.preventDefault();
			var vpw = $(window).width() + getScrollBarWidth();
			$burgerMenu = $('#burger-menu');
			$burgerMenu.toggleClass('menu-show');
		});


		$(document).on('click', function(event) {
			if ((!$(event.target).closest('.paciente-nav-trigger').length)) {
				$('#paciente-menu').removeClass('menu-show');
			}
			if ((!$(event.target).closest('.paciente-nav-menu-burger').length) 
					&& 
					$('.paciente-nav-menu-burger').is(':visible')) {
				$('#burger-menu').removeClass('menu-show');
			}
		});
		
		
		
	}
	


function buttonTriggers(button, menuOrigin, objClass) {

	if ($(button).data('modal') == 'yes') {
		var object = $(button).next('[class^="modal-"]');
		var parse = object.html();

		var modalDataId = $(button).data('id');
		
		if ($(button).attr('id')) {
			var id = $(button).attr('id');
		}
		modalData(parse, id, modalDataId);
	}
}

	function modalData(data, id, dataId) {
	if (typeof id !== 'undefined'){
		$('.modal-inside').find('.modal-dialog').attr('id', id);
	}else{
		$('.modal-inside').find('.modal-dialog').attr('id', dataId);
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

//-------------------------------------------------

// 								ratting stars

//-------------------------------------------------



	$.fn.rating = function( method, options ) {
		method = method || 'create';
		// This is the easiest way to have default options.
		var settings = $.extend({
			// These are the defaults.
			limit: 5,
			value: 0,
			glyph: "glyphicon-star",
			coloroff: "gray",
			coloron: "gold",
			size: "2.0em",
			cursor: "default",
			onClick: function () {},
			endofarray: "idontmatter"
		}, options );
		var style = "";
		style = style + "font-size:" + settings.size + "; ";
		style = style + "color:" + settings.coloroff + "; ";
		style = style + "cursor:" + settings.cursor + "; ";



		if (method == 'create')
		{
			//this.html('');	//junk whatever was there

			//initialize the data-rating property
			this.each(function(){
				attr = $(this).attr('data-rating');
				if (attr === undefined || attr === false) { $(this).attr('data-rating',settings.value); }
			})

			//bolt in the glyphs
			for (var i = 0; i < settings.limit; i++)
			{
				this.append('<span data-value="' + (i+1) + '" class="ratingicon glyphicon ' + settings.glyph + '" style="' + style + '" aria-hidden="true"></span>');
			}

			//paint
			this.each(function() { paint($(this)); });

		}
		if (method == 'set')
		{
			this.attr('data-rating',options);
			this.each(function() { paint($(this)); });
		}
		if (method == 'get')
		{
			return this.attr('data-rating');
		}
		//register the click events
		this.find("span.ratingicon").click(function() {
			rating = $(this).attr('data-value')
			$(this).parent().attr('data-rating',rating);
			paint($(this).parent());
			settings.onClick.call( $(this).parent() );
		})
		function paint(div)
		{
			rating = parseInt(div.attr('data-rating'));
			div.find("input").val(rating);	//if there is an input in the div lets set it's value
			div.find("span.ratingicon").each(function(){	//now paint the stars

				var rating = parseInt($(this).parent().attr('data-rating'));
				var value = parseInt($(this).attr('data-value'));
				if (value > rating) { $(this).css('color',settings.coloroff); }
				else { $(this).css('color',settings.coloron); }
			})
		}

	};


	
	
	//--------------------------------------------------
	//					Profesionales en la red
	//--------------------------------------------------
	
	if($(".cs-nc-profesionales-en-la-red").length > 0){

		$(':checkbox').radiocheck();
		$(function() {
			$( "#slider-range" ).slider({
				range: true,
				min: 50,
				max: 300,
				values: [ 50, 300 ],
				slide: function( event, ui ) {
					$( "#amount-min" ).val( "$" + ui.values[ 0 ]);
					$( "#amount-max" ).val( "$" + ui.values[ 1 ]);
				}
			});
			$( "#amount-min" ).val( "$" + $( "#slider-range" ).slider( "values", 0 )); 
			$( "#amount-max" ).val( "$" + $( "#slider-range" ).slider( "values", 1 )); 


		});
	}
	
	if($('.cs-range-mas-filtros').length > 0){
		fflag = true;
		$('.cs-range-mas-filtros-trigger').on('click',function(e){
			e.preventDefault();
			if(fflag){
				$('.cs-range-mas-filtros').stop().slideDown();
				$(this).html('Menos filtros');
				fflag = false;
			}else if(!fflag){
				$('.cs-range-mas-filtros').stop().slideUp();
				$(this).html('Más filtros');
				fflag = true;
			}
		});
		
		
	}

//---------------------------------------------------------------
//									Input
//---------------------------------------------------------------
	

	
	if($('.okm-input-icon').length > 0){	
		$('.okm-input-icon').children('input').on('input', function(){
			if(!$(this).parent().hasClass('focus')){
				$(this).parent().addClass('focus');
			}else if(!$(this).val()){
				$(this).parent().removeClass('focus');
			}
		});
	}
	
	
	//---------------------------------------------------------------
	//									PBN
	//---------------------------------------------------------------

	
	
	$('#pbn-instrucciones, .pbr-instrucciones-trigger').on('click',function(e){
		e.preventDefault();
		$('#pbr-instrucciones').fadeToggle();
	});

	
	$('.pbn-map-trigger').on('click', function(e){
		e.preventDefault();
		$('#pbn-map').slideToggle();
	});
	

	if($('.ratting-like').length > 0){
		$('.ratting-like').on('click', function(e){
			e.preventDefault();
			$(this).toggleClass('selected');
		});
	}
	
	if($('.pbn-static-btn').length > 0){

		var headerHeight = $('#menu').height() + 50;
		var elepos = $('.pbn-static-btn').offset().top;
		var topspace = elepos - headerHeight;





		$(window).on('scroll', function () {
			var currentTop = $(window).scrollTop();
			var currentElePos = $('.pbn-static-btn').offset().top;
			var currentElePosH = $('.pbn-static-btn').offset().left;
			var btnposV = currentElePos - currentTop;


			if(currentTop > topspace){

				if(!$('.pbn-static-btn').hasClass('rounded')){

					$('.pbn-static-btn').addClass('rounded');
					$('.pbn-static-btn').css({
						position:'fixed',
						top: 120,
						right:'5%',
						'z-index': 9000
					});
					
					$("#pbn-map").css({
						position: 'fixed',
						top: 104,
						left:0,
						width:'100%'
					});
				}

			}else if(currentTop < topspace){
				if($('.pbn-static-btn').hasClass('rounded')){
					$('.pbn-static-btn').removeClass('rounded');
					$('.pbn-static-btn').css({
						position:'relative',
						top: 0,
						left: 'inherit',
						'z-index': 1

					});
					$("#pbn-map").css({
						position: 'absolute',
						top: 0,
						left:0
					});
				}
			}

		});
	}
	
	
	
	// consultorio PBP cards actions
	
	function getHeightText(trigger, obj, inner, height){
	
		$.each(trigger,function(i,val){
			
			var animateObj = $(this).prev(obj);
			var innerObj = animateObj.children(inner);

			var altoIni = height;
			var altoSlide = innerObj.outerHeight();

			
			if(altoSlide <= altoIni){
				$(this).hide();
				console.log(altoSlide);
				console.log(altoIni);
			}
			
		});
		
			
	
	}
	
	function verMasTexto(trigger, obj, inner, height){

		var animateObj = trigger.prev(obj);
		var innerObj = animateObj.children(inner);

		var altoIni = height;
		var altoSlide = innerObj.outerHeight();

		
		
		if(animateObj.outerHeight() <= altoIni){

			animateObj.animate({
				height: altoSlide
			}, 600);
			trigger.html('Menos');
		}else{
			animateObj.animate({
				height: altoIni
			}, 600);
			trigger.html('Más...');
		}
			
	
	}
	

	
	if($('.map-static-btn').length > 0 ){
		
		$('.map-static-btn').on('click',function(e){
			e.preventDefault();
			$('#mapa').slideToggle();
		});
	}
	
	if($('.pbp-card').length > 0){
		
		var vpw = $(window).width() + getScrollBarWidth();
		if(vpw <= 800){
			
			$('.pbp-card').find('h3').on('click',function(e){
				$(this).next('.pbp-card-slide').slideToggle(function(){
					
					if($(this).is(':visible')){
						textcut(".pbp-perfil-profesional-expand-text",$(".pbp-perfil-profesional-expand-text").data('linesrsp'));
					}
					
				});
				$(this).toggleClass('selected');
			});
		}else{
			textcut(".pbp-perfil-profesional-expand-text",$(".pbp-perfil-profesional-expand-text").data('lines'));
		}
		
	
	}
	
//	if($('.pbp-medico-ficha').length > 0){
//
//		var viewPortWidth = getViewportWidth();
//
//		if(viewPortWidth > 800){
//		}else if(viewPortWidth <= 800){
//			textcut(".pbp-perfil-profesional-expand-text",$(".pbp-perfil-profesional-expand-text").data('linesrsp'));
//		}




	//}
	if($('.pbp-tarifa-tipo-trigger').length > 0){
		
		$('.pbp-tarifa-tipo-trigger').on('click', function(e){
			e.preventDefault();
			if($('.pbp-tarifa-tipo-trigger').hasClass('selected')){
				$('.pbp-tarifa-tipo-trigger').removeClass('selected');
			}
			$(this).addClass('selected');
			var tipoData = $(this).data('type');
			
			$.each($('.pbp-presencial'),function(i, val){
				if($(this).data('src') == tipoData){
					if($(this).hasClass('hidden')){
						$(this).removeClass('hidden');
					}
				}else{
					if(!$(this).hasClass('hidden')){
						$(this).addClass('hidden');
					}
				}
			});
			
			
			
		});
		
	}
	
	
	// scroll to
	
	$('.pbp-turno-trigger').on('click', function(e){
		e.preventDefault();
		var dTarget = $(this).attr('href');
		scrollToObj($(dTarget));
	});
	
	
	// NOMINA Slide turnos ver otros
	
	if($('.pbn-turno-vacio-trigger').length > 0){
		
		$('.pbn-turno-vacio-trigger').on('click', function(e){
			e.preventDefault();
			var obj = $(this)
								.parent('.pbn-turno-vacio')
								.parent('.gnlist-profesional-holder')
								.parent('.pbn-col-profesional')
								.next('.pbn-col-turno');
			obj.toggle();
			
			var sliderReset = obj
												.children('.pbn-turnos-holder')
												.children('.pbn-turnos-slide-holder');
			sliderReset.get(0).slick.setPosition();
			});
	}
	
	
//--------------------------------------------------------------
//									fn menu	
//--------------------------------------------------------------
	
	if($('#float-nav').length > 0){
		
		$('.fn-usr-trigger').on('click', function(e){
			e.preventDefault();
			
			$(this).hide().prev('.fn-menu').slideDown();
		});
		
		
		$('.fn-close').on('click', function(e){
			$(this).parent().slideUp(function(){
				$(this).next('.fn-usr-trigger').fadeIn();
			});
			
			
		});
		
		
		$('.fn-mdc-usr-trigger').on('click',function(e){
			e.preventDefault();
			$(this).toggleClass('selected-submenu');
			$(this).next('.fn-mdc-usr-holder').fadeToggle();
		});
		
		
	}	
	

	//--------------------------------------------------------------
	//						Medico usuario logeado info porfesional
	//--------------------------------------------------------------
	if($('.mul-nosificaciones-list').length > 0){
	
		$('#sms, #both').on('click',function(e){
			
			
			if($(this).is(':checked')){
				$('.mul-slide-sms-validar').slideDown();
			}else if(!$('#sms').is(':checked') && !$('#both').is(':checked')){
				$('.mul-slide-sms-validar').slideUp();
			}
		});
		
		$('.validar-close-triger').on('click', function(e){
			e.preventDefault();
			$('.mul-slide-sms-validar').slideUp();
		});
}
	

	//--------------------------------------------------------------
	//						cobertura slide
	//--------------------------------------------------------------	
	
	if($('.bst-cobertura-slide-box').length > 0){
		
		$('.tengo-cobertura-trigger').on('click', function(e){
			e.preventDefault();
			if(!$(this).hasClass('disabled')){
				$('.cobertura-slide-box-1').slideUp();
				$('.cobertura-slide-box-2').slideDown();
				$('.pago-particular .custom-checkbox').radiocheck('uncheck');
			}
		});
		
		$('.cobertura-guardar-datos').on('click', function(e){
			e.preventDefault();
			if(!$(this).hasClass('disabled')){
				$('.cobertura-slide-box-2').slideUp();
				$('.cobertura-slide-box-3').slideDown();
				$('.pago-particular .custom-checkbox').radiocheck('uncheck');
			}
		});
		
		$('.cobertura-cambiar-datos').on('click', function(e){
			e.preventDefault();
			if(!$(this).hasClass('disabled')){
				$('.cobertura-slide-box-3').slideUp();
				$('.cobertura-slide-box-2').slideDown();
				$('.pago-particular .custom-checkbox').radiocheck('uncheck');
			}
		});
		
		
	}
	
	$('.pago-particular .custom-checkbox').on('click', function(e){
		
		if($(this).is(':checked')){
			if($('.cobertura-slide-box-3').is(':visible')){
				$('.cobertura-data-list').addClass('disabled');
				$('.pago-particular .custom-checkbox').toggle('check');
			}
			if($('.cobertura-slide-box-2').is(':visible')){
				$('.cobertura-slide-box-2').slideUp();
				$('.cobertura-slide-box-1').slideDown();
				$('.pago-particular .custom-checkbox').radiocheck('check');
			}
			$('.cobertura-btn').addClass('disabled');
		}else{
			if($('.cobertura-btn').hasClass('disabled')){
				$('.cobertura-btn').removeClass('disabled');
			}
		}
		
	});
	
	if($('.bst-cambiar-pacientes-slide').length > 0){
		
		$('.bst-cambiar-pacientes-trigger').on('click', function(e){
			e.preventDefault();
			$(this).next('.bst-cambiar-pacientes-slide').slideToggle();
			$(this).children('.icon-doctorplus-arrow-down').toggleClass('btn-up-arrow');
		});
	}
	
	if($('.ver-mapa-trigger').length > 0){
		
		$('.ver-mapa-trigger').on('click', function(e){
			e.preventDefault();
			$('#bst-mapa').slideToggle();
			
		});
		
	}
	
	if($('.bst-validar-trigger').length > 0){
		
	$('.bst-validar-trigger').on('click', function(e){
		e.preventDefault();
		$('.bst-cel-validar-slide-1').slideUp();
		$('.bst-cel-validar-slide-2').slideDown();
	});
		
	}
	
	
	
	//----------------------------------------------
	// 								PACIENTE HOME
	//----------------------------------------------
	
	
	
	if($('.hp-slide').length > 0){
		
		
		$('.hp-slide').on('init', function(event, slide){
			$('.hp-slide').find('.slick-dots').find('li').on('click',function(e){
				$('.hp-slide').slick('slickSetOption','autoplay',false,true);
			});
		});
	
		
		$('.hp-slide').slick({
			dots: true,
			infinite: true,
			speed: 300,
			autoplay: true,
			autoplaySpeed: 8000 ,
			adaptiveHeight: true,
			pauseOnFocus: true,
			pauseOnHover: true,
			pauseOnDotsHover: true
		});
		

		
		
		$('.hp-slide').on('swipe',function(event, slide, direction){
			slide.slickSetOption('autoplay',false);
		});
		
	}
	
	
	if($('.hp-servicios-slide').length > 0){
		$('.hp-servicios-slide').slick({
			dots: false,
			infinite: true,
			speed: 300,
			arrows: false,
			autoplay: true,
			autoplaySpeed: 8000,
			adaptiveHeight: true
		});
		
		
		$('.hp-servicios-slide').on('swipe',function(event, slide, direction){
			slide.slickSetOption('autoplay',false);
		});
		
		$('#srv-slide-0').on('click', function(e){
			e.preventDefault();
			$('.hp-servicios-slide').slick('slickGoTo', 0);
			$('.hp-servicios-slide').slick('slickSetOption','autoplay',false,true);
		});
		
		$('#srv-slide-1').on('click', function(e){
			e.preventDefault();
			$('.hp-servicios-slide').slick('slickGoTo', 1);
			$('.hp-servicios-slide').slick('slickSetOption','autoplay',false,true);
		});
		
		$('#srv-slide-2').on('click', function(e){
			e.preventDefault();
			$('.hp-servicios-slide').slick('slickGoTo', 2);
			$('.hp-servicios-slide').slick('slickSetOption','autoplay',false,true);
		});
		
		$('#srv-slide-3').on('click', function(e){
			e.preventDefault();
			$('.hp-servicios-slide').slick('slickGoTo', 3);
			$('.hp-servicios-slide').slick('slickSetOption','autoplay',false,true);
		});
		
		$('#srv-slide-4').on('click', function(e){
			e.preventDefault();
			$('.hp-servicios-slide').slick('slickGoTo', 4);
			$('.hp-servicios-slide').slick('slickSetOption','autoplay',false,true);
		});
		

		
		$('#consulta-express-trigger, #ph-ce-slide-trigger-2').on("click", function(e){
			e.preventDefault();
			scrollToObj($('#srv-slide-0'));
			$('.hp-servicios-slide').slick('slickGoTo', 0);
		});
		
		$('#consulta-video-trigger-1, #consulta-video-trigger-2').on("click", function(e){
			e.preventDefault();
			scrollToObj($('#srv-slide-1'));
			$('.hp-servicios-slide').slick('slickGoTo', 1);
		});


		
		//scrollToObj(trgObj)
		
	}
	
	

	//----------------------------------------------
	// 								login
	//----------------------------------------------


	if($('#login').length > 0){
		
		$('#timeout-trigger').on('click', function(e){
			$('#timeout').show();
			$('#login').hide();
			$('#passrecovery').hide();
			$('#recoverytext').hide();
		});
		
		
		$('#loginbtn').on('click', function(e){
			$('#login').show();
			$('#passrecovery').hide();
			$('#recoverytext').hide();
			$('#timeout').hide();
		});
		
	
		
		$('.ForgotPassTrigger').on('click', function(e){
			e.preventDefault();
			$('#login').hide();
			$('#timeout').hide();
			$('#passrecovery').fadeIn();
		});
		
		$('#sendpass').on('click', function(e){
			e.preventDefault();
			$('#passrecovery').hide();
			$('#recoverytext').fadeIn();
		});
		
	}
	
	
	//----------------------------------------------
	// 						usuario logeado menu admin
	//----------------------------------------------
	
	if($('.mul-datos-administrador-box').length > 0){
		
		$('#mul-validar-cel-tgr').on('click', function(e){
			e.preventDefault();
			$('#mul-validar-cel').slideToggle();
		});
		
		$('#mul-validar-mail-tgr').on('click', function(e){
			e.preventDefault();
			$('#mul-validar-mail').slideToggle();
		});
		
		$('#mul-validar-cel-revalidar-tgr').on('click', function(e){
			e.preventDefault();
			$('#mul-validar-cel-revalidar').slideToggle();
		});
		
		
		$('.mul-validar-close-triger').on('click', function(e){
			e.preventDefault();
			$(this).parent('h2').parent('.validar-cell-box').parent('.mul-slide-validar-box').slideUp();
		});
		
	}
	

	
	
	if($('.mad-menu').length > 0){
		
		function mulScroll(trgObj){
			var trgObjHeight = trgObj.outerHeight();
			$('html, body').animate({
				scrollTop:(trgObj.offset().top - trgObjHeight) - 60
			}, 1000);
		}
		
		
		
		$('#mul-configuracion-trg').on('click', function(e){
			e.preventDefault();
			
			if(!$(this).children('figure').hasClass('active')){
				
				$('#mul-datos-administrador-trg').children('figure').removeClass('active');
				$('#mul-vencimientos-trg').children('figure').removeClass('active');
				
				$(this).children('figure').addClass('active');
				
				$('.mul-configuracion-box, .mul-datos-administrador-box, .mul-vencimientos-box').hide();
				$('.mul-datos-administrador-box').slideDown();
				
				var mulvpw = $(window).width() + getScrollBarWidth();
				
				if(mulvpw <= 600){
					mulScroll($('.mul-datos-administrador-box'));
				}

			}
			

		});
		
		
		$('#mul-datos-administrador-trg').on('click', function(e){
			e.preventDefault();

			if(!$(this).children('figure').hasClass('active')){
				
				$('#mul-configuracion-trg').children('figure').removeClass('active');
				$('#mul-vencimientos-trg').children('figure').removeClass('active');
				
				$(this).children('figure').addClass('active');
				
				

				$('.mul-configuracion-box, .mul-datos-administrador-box, .mul-vencimientos-box').hide();
				$('.mul-configuracion-box').slideDown();
				
				var mulvpw = $(window).width() + getScrollBarWidth();

				if(mulvpw <= 600){
					mulScroll($('.mul-configuracion-box'));
				}

			}


		});
		
		
		$('#mul-vencimientos-trg').on('click', function(e){
			e.preventDefault();

			if(!$(this).children('figure').hasClass('active')){
				
				$('#mul-configuracion-trg').children('figure').removeClass('active');
				$('#mul-datos-administrador-trg').children('figure').removeClass('active');
				
				$(this).children('figure').addClass('active');

				$('.mul-configuracion-box, .mul-datos-administrador-box, .mul-vencimientos-box').hide();
				$('.mul-vencimientos-box').slideDown();
				
				
				var mulvpw = $(window).width() + getScrollBarWidth();

				if(mulvpw <= 600){
					mulScroll($('.mul-vencimientos-box'));
				}

			}


		});
		
		
		
	}
	
	
	//--------------------------------------------------------
	//                HOME MEdicos
	//--------------------------------------------------------
	
	

	
	if($('.hom-servicios-slide').length > 0){
		$('.hom-servicios-slide').slick({
			dots: false,
			infinite: true,
			speed: 300,
			arrows: false,
			autoplay: true,
			autoplaySpeed: 8000,
			adaptiveHeight: true,
			pauseOnFocus: true,
			pauseOnHover: true,
			pauseOnDotsHover: true
		});
		
		$('.hslide').on("click", function(e){
			e.preventDefault();
			//scrollToObj($('#srv-slide-0'));
			var slideNumer = $(this).data('slide');
			$('.hom-servicios-slide').slick('slickGoTo', slideNumer);
			$('.hom-servicios-slide').slick('slickPause');
			$('.hom-servicios-slide').slick('slickSetOption','autoplay',false,true);
			
		});
		
		$('.hom-servicios-slide').on('swipe',function(event,slide,direction){
			$('.hom-servicios-slide').slick('slickSetOption','autoplay',false,true);
			$('.swipe-icon-box').hide();
		});
		
	}
	
	if($('#hom-nav-rsp-trg').length > 0){
		$('#hom-nav-rsp-trg').on('click', function(e){
			e.preventDefault();
			
			$('#hom-nav-rsp-get').toggleClass('menu-show');
			
		});
		
		$(window).on('scroll', function () {
			var currentTop = $(window).scrollTop();
			
			if(currentTop >= 60){
				$('.hom-nav').addClass('transparent');
			}else if(currentTop < 60){
				$('.hom-nav').removeClass('transparent');
			}
			
		});
		
		
		
		
		var menuEl = $('#hom-nav-rsp-get').children('li').children('a');
		
		menuEl.on('click', function(e){
			e.preventDefault();
			
			if(typeof $(this).data('lnk') !== 'undefined'){
				var lnkTo = "#"+$(this).data('lnk');
				mulScroll($(lnkTo));
			}
			
			
			if($('#hom-nav-rsp-get').hasClass('menu-show')){
				$('#hom-nav-rsp-get').removeClass('menu-show')
			}
			
		});
		
		
		$('#loginbtn').on('click', function(e){
			e.preventDefault();
			$('.usrlogin').modal('toggle');
		});
		
	}
	
	if($('.hom-slider-box').length > 0){
		
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
			pauseOnDotsHover: true
		});
		
		$('.hom-slide').on('swipe',function(event, slide, direction){
			slide.slickSetOption('autoplay',false);
		});
		
	
	}
	
	if($('.hom-contacto-box').length > 0){
	
		$('input[type="submit"').on('click', function(e){
			e.preventDefault();
			
			$('#hom-contacto-box').slideUp();
			$('#hom-contacto-msg').show();
			
			
		})
	}
	
	
//----------------------------------------------	
//   Medico Abono	
//----------------------------------------------	
	
	if($('.mapc-login-box').length > 0){

		$('#timeout-trigger').on('click', function(e){
			$('#mapc-login').hide();
			$('#mapc-passrecovery').hide();
			$('#mapc-recoverytext').hide();
		});


		$('#loginbtn').on('click', function(e){
			$('#mapc-login').show();
			$('#mapc-passrecovery').hide();
			$('#mapc-recoverytext').hide();
		});



		$('.ForgotPassTrigger').on('click', function(e){
			e.preventDefault();
			$('#mapc-login').hide();
			$('#mapc-passrecovery').fadeIn();
		});

		$('#mapc-sendpass').on('click', function(e){
			e.preventDefault();
			$('#mapc-passrecovery').hide();
			$('#mapc-recoverytext').fadeIn();
		});

	}	
	
	if($('.mapc-codigo-promocion').length > 0){
		$('.mapc-codigo-promocion').on('click', function(e){
			e.preventDefault();
			$('.mapc-codigo-promocion-box').slideToggle();
		});
	}
	
	
	
	if($('#signup-steps').length > 0){
		
		$('#mapc-mi-cuenta-btn').on('click', function(e){
			e.preventDefault();
			$('.mapc-mi-cuenta').slideUp();
			$('.mapc-mi-identificacion').slideDown();
			
			$('#signup-steps').children('li.active').removeClass('active');
			
			$('#signup-steps').children('li').eq(1).addClass('active');
			
		});
		
		$('#mapc-mi-identificacion-btn').on('click', function(e){
			$('.mapc-mi-identificacion').slideUp();
			$('.mapc-pago').slideDown();

			$('#signup-steps').children('li.active').removeClass('active');

			$('#signup-steps').children('li').eq(2).addClass('active');

		});
		
		
		$('#mapc-finalizar-pago').on('click', function(e){
			e.preventDefault();
			$('.mapc-transaccion-ok').slideDown();
			$('.mapc-transaccion-error').slideDown();
		});
		
		
		$('#accordion-trg-1').on('click', function(e){
			e.preventDefault();
			$('#collapseOne').collapse('toggle');
			$('#collapseTwo').collapse('toggle');
		});
		
		$('#accordion-trg-2').on('click', function(e){
			e.preventDefault();
			$('#collapseTwo').collapse('toggle');
		});
		
	}
	

	if($('.pul-datos-paciente').length > 0){
		$('#accordion-pul-trg').on('click', function(e){
			e.preventDefault();
			$('#collapseOne').collapse('hide');
			$('#collapseTwo').collapse('show');
			//
		});
		
		
		$('#particular').on('click',function(e){
			$('.pul-np-dis').attr('disabled', 'disabled');
		});
		
		$('#cobertura').on('click',function(e){
			$('.pul-np-dis').removeAttr('disabled');
		});
		
		$('.pul-np-privacidad-trg').on('click', function(e){
			e.preventDefault();
			$('#privacidad').modal('show');
		});
		
	}
	
	if($('.mvc-video-guia').length > 0){
		$('#guiaUsoTrg').on('click', function(e){
			scrollToEl($('#guiaUsoTarget'));
		});
	}
	
	if($('.mvc-video').length > 0){
		
		$(".mvc-chat-box").mCustomScrollbar({
			theme:"dark-3"
		});
		
		jQuery.each(jQuery('textarea[data-autoresize]'), function() {
			

			var offset = this.offsetHeight - this.clientHeight;

			var resizeTextarea = function(el) {
				jQuery(el).css('height', 'auto').css('height', el.scrollHeight + offset);
			};
			jQuery(this).on('keyup input', function() { resizeTextarea(this); }).removeAttr('data-autoresize');
		});	
		
	
		if(getViewportWidth() >= 801){
		
			$('#mvc-profile-trg').on('click', function(e){
				e.preventDefault();

				if(!$(this).hasClass('active')){
					$('#mvc-chat-trg').removeClass('active');
					$(this).addClass('active');

					$('#mvc-chat').slideUp();
					$('#mvc-profile').slideDown();
				}

			});


			$('#mvc-chat-trg').on('click', function(e){
				e.preventDefault();

				if(!$(this).hasClass('active')){
					$('#mvc-profile-trg').removeClass('active');
					$(this).addClass('active');

					$('#mvc-profile').slideUp();
					$('#mvc-chat').slideDown();

				}

			});
		
		}else if(getViewportWidth() <= 800){
			
			
			
			
			$('#mvc-profile-trg').on('click', function(e){
				e.preventDefault();
				scrollToEl($('.mvc-profile-box'));
			});
			
			$('#mvc-chat-trg').on('click', function(e){
				e.preventDefault();
				scrollToEl($('.mvc-data-box'));
			});
			
			
			//mvc-video-float-visible
			$(window).on('scroll', function () {
				var currentTop = $(window).scrollTop();
				var elementTop = $('.mvc-data-top').offset().top + 60;
				if(currentTop > elementTop){
					$('.mvc-video-float').fadeIn();
				}else if(currentTop <= elementTop){
					$('.mvc-video-float').fadeOut();
					
					$('#video-btn-float').on('click', function(e){
						e.preventDefault();
						scrollToEl($('.mvc-video-col'));
					});
				}
				
			});
		
	}

			
			
		$('#mvc-video-btn-start').on('click', function(e){
				e.preventDefault();
			if(!$(this).hasClass('calling-label-show')){
				$(this).addClass('calling-label-show');
			}
			});
	
		
		$('#profesionales-frecuentes-trg').on('click', function(e){
			e.preventDefault();
			$('#profesionales-frecuentes').modal('show');
		});
		
		$('.mvc-video-attach-modal').on('click', function(e){
			e.preventDefault();
			$('#ver-archivo').modal('show');
		});
		
		//mvc-video-attach-modal
		
	//--	
		
		
		
	}
	
	
	if($('.mvc-guia-grid').length > 0){
		
		if(getViewportWidth() >= 601){
		
		var $grid = $('.mvc-guia-grid').masonry({
			columnWidth: '.mvc-grid-sizer',
			gutter: '.mvc-grid-gutter',
			itemSelector: '.mvc-guia-item',
			percentPosition: true
		});
			
		}else if(getViewportWidth() <= 800){
			
		$('.mvc-guia-holder-trg').on('click', function(e){
			e.preventDefault();
			
			if(!($(this).siblings('.mvc-guia-holder').hasClass('open'))){
			function close_all_cards(){
				$('.mvc-guia-holder').each(function(){
					if($(this).hasClass('open')){
						$(this).removeClass('open');
						$(this).slideUp();
					}
				});
			}
			close_all_cards();
			
			$(this).siblings('.mvc-guia-holder').slideToggle().addClass('open');
			}else{
			$(this).siblings('.mvc-guia-holder').slideToggle().removeClass('open');
			}
		});
		
	}
	}
	
	
	if($('.video-consulta-pasos').length > 0){
		
		$('#usr-help-trg').on('click', function(e){
			e.preventDefault();
			
			$('#usr-help-box').slideToggle();
		});
		
		$('#alert-modal').on('click', function(e){
			e.preventDefault();
			
			$('#modal-alert').modal('toggle');
		});
	}
	
	
	
	if($('.plogin-registro').length > 0){
		
		$('#accordion-pul-trg').on('click', function(e){
			e.preventDefault();
			$('#collapseOne').collapse('hide');
			$('#collapseTwo').collapse('show');
			//
		});


		$('#nuevaCuenta').on('click', function(e){
			e.preventDefault();
			
			$("#registroAccordon").slideUp();
			$("#mensajeRegistro").slideDown();
			scrollToEl($("#registroAccordon"));
			
			
			
		});

	}
	
	if($('#pacientesSinCargo').length > 0){
		$('#codigoEticaShow').on('click', function(e){
			e.preventDefault();
			$('#codigoEtica').slideDown();
			$(this).hide();
			$('#codigoEticaHide').show();
		});
		
		$('#codigoEticaHide').on('click', function(e){
			e.preventDefault();
			$('#codigoEtica').slideUp();
			$(this).hide();
			$('#codigoEticaShow').show();
		});
		
		$('#pacientesSinCargoClose').on('click', function(e){
			e.preventDefault();
			$('#pacientesSinCargo').slideUp();
		});
	
	}
	
	
	if($('.lista-pacientes').length > 0){
		
		$('.modal-paciente-contacto-sbmt').on('click', function(e){
			e.preventDefault();
			$(this).parent('.more-data').slideUp('fast');
			$(this).parent('.more-data').siblings('.modal-paciente-msg-sbmt').slideDown();
		});
	}
	
	
	if($('.ce-pc-consulta-trigger').length > 0){

	$(".ce-pc-consulta-trigger").on('click', function(e){
		e.preventDefault();
		$(this).parent().siblings('.ce-pc-consulta-holder-slide').slideToggle(function(el){

			if($(this).is(':visible')){
				$(this).siblings('.ce-pc-consulta-btn-holder').children('.ce-pc-consulta-trigger').html('Ocultar consulta');
			}else{
				$(this).siblings('.ce-pc-consulta-btn-holder').children('.ce-pc-consulta-trigger').html('Mostrar consulta');
			}

		});


	});
	
	}
	
	
	if($('.cv-pendientes-box').length > 0){
		
		$('.ce-ca-mdl-rechazo-consulta').on('click',function(e){
			e.preventDefault();
			if($(this).parent().siblings('.chat-motivo-rechazo-holder').is(':hidden')){
				$(this).parent().siblings('.chat-motivo-rechazo-holder').slideDown();
			}
		});
		
	}
	
	if($('.cv-consulta-select').length > 0){

		
		$('.cv-consulta-select-trg').change(function (e) {
		
		var $dataTiempo = 	$(this).find('option:selected').data('time');
			
			if($dataTiempo == 5 || $dataTiempo == 10){
				$(this).closest('.audio-actions-panel').siblings('.vc-registro-lista-disclaimer').slideDown();
				scrollToEl($(this));
			}else{
				$(this).closest('.audio-actions-panel').siblings('.vc-registro-lista-disclaimer').slideUp();
			}	
			
			
		})
		
		
	}
	
	
	if($('.mmc-costos-periodo').length > 0){
		
		$('#paso-0-trg').on('click', function(e){
			e.preventDefault();
			$('#mmc-paso-0').hide();
			$('#mmc-paso-1').slideDown();
		});
		
		$('#paso-1-trg').on('click', function(e){
			e.preventDefault();
			$('#mmc-paso-1').hide();
			$('#mmc-paso-2').fadeIn();
		});
		
		$('#paso-2-trg').on('click', function(e){
			e.preventDefault();
			$('#mmc-paso-2').hide();
			$('#mmc-paso-3').fadeIn();
		});
		
		$('#paso-2-cancelar-trg').on('click', function(e){
			e.preventDefault();
			$('#mmc-paso-2').slideUp();
			$('#mmc-paso-0').slideDown();
			scrollToEl($('.mmc-title'));
		});
		
		$('#paso-3-cancelar-trg').on('click', function(e){
			e.preventDefault();
			$('#mmc-paso-3').slideUp();
			$('#mmc-paso-0').slideDown();
			scrollToEl($('.mmc-title'));
		});
	}
	if($('.resumen-trg').length > 0){
		$('.resumen-trg').on('click', function(e){
			e.preventDefault();
			scrollToEl($('.mmc-resumen-top'));
		});
	}
	
	if($('.vc-sde-cancelar-trg').length > 0){
		
		$('.vc-sde-cancelar-trg').on('click', function(e){
			e.preventDefault();
			$(this).closest('.vs-espera-cancelar-btn-box').siblings(".vc-sde-cancelar-msg").slideDown();
		});
	}

	if($('.cancelar-msd-trig').length > 0){
		$('.cancelar-msd-trig').on('click', function(e){
			e.preventDefault();
			$(this).closest('.vc-audio-actions-panel').slideUp();
			$(this).closest('.vc-audio-actions-panel').siblings('.vc-sde-turno-cerrado-box').slideDown();
		});
	}
	
	
	
	if($('.va-atender-card').length > 0){
		
		function flipCard(e){
			e.velocity({
				rotateX: "180deg",
				delay: 500,
				duration: 2000
			});
		}
		flipCard($('.va-atender-card-flip'));
		
	}
	
	if($('.vc-interrumpidas-ayuda-box').length > 0){
		$('#vc-interrumpidas-card-trg').on('click', function(e){
			e.preventDefault();
			$('.vc-interrumpidas-ayuda-box').slideToggle();
		});
	}
	
	if($('.mul-form-type').length > 0){
		$('.section-swap-trg').on('click', function(e){
			e.preventDefault();
			
			if(!($(this).hasClass('active'))){
				$('.section-swap-trg').removeClass('active');
				$(this).addClass('active');
				var seccion = $(this).data('info');
				$('.mul-form-type').hide();
				$('#info-' + seccion).show();
				scrollToEl($('#info-' + seccion));
			}
			
			
		});
		
		
		$('#iva-trg').change(function (e) {

			var $dataIva = 	$(this).find('option:selected').data('type');
			
			if($dataIva == "ri"){
				$('#condicion-iva').slideDown();
			}else{
				
				if($('#constancia-iva').is(':visible')){
					$('#constancia-iva').slideUp();
				}
				if($('#condicion-iva').is(':visible')){
					$('#condicion-iva').slideUp();
					$('#extension-iva').prop("checked", false);
				}
			}
			
		});
		
		$('#extension-iva').on('click', function(e){
			
			if($(this).is(':checked')){
				$('#constancia-iva').slideDown();	
			}
			
		});
		
		
	}
	
	
	if($('#info-consultorios').length > 0){
		$('.consultorios-trg').on('click', function(e){
			e.preventDefault();
			
			if(!($(this).hasClass('active'))){
				$('.consultorios-trg').removeClass('active');
				$(this).addClass('active');
				
				$('.consultorios-src').slideUp();
				$($(this).data('src')).slideDown();
			}
		});
		
		$('#dc-del-content-trg').on('click', function(e){
			e.preventDefault();
			$('#dc-del-content').slideUp();
			$('#dc-del-disclaimer').slideDown();
			
		});
		
		$('.dc-modal-del').on('click', function(e){
			e.preventDefault();
			$('#dc-modal-con-del').modal(['show']);
		});
		
		$('#dc-modal-notificacion-pacientes-trg').on('click', function(e){
			e.preventDefault();
			$('#dc-modal-info-pacientes').modal(['show']);
		});
		
		$('input').on('beforeItemRemove', function(event) {
			// event.item: contains the item
			$('#dc-modal-info-pacientes-cancelados').modal(['show']);
		});
	}
	
	
	if($('.td-turno-datos-paciente-trg').length > 0){
		
		$('.td-turno-datos-paciente-trg').on('click', function(e){
			e.preventDefault();
			
			
			$(this).next('.td-turno-datos-paciente-collapse').slideToggle(function(){
				
				$slider =  $('.td-slide-box');

				$slider.find(".slick-slide").height("auto");
				$slider.slick("setOption", '', '', true);
				
			});
			$(this).find('.arrow').toggleClass('rotate');
			

		})
		
		
	}
	
	if($('.td-slide-box').length > 0){
		$('.td-slide-box').slick({
			dots: false,
			infinite: true,
			speed: 300,
			arrows: true,
			autoplay: false,
			autoplaySpeed: 8000,
			adaptiveHeight: true,
			pauseOnFocus: true,
			pauseOnHover: true,
			pauseOnDotsHover: true,
			adaptiveHeight: false
		});
		
		
		$('.td-slide-box').on('afterChange', function(event, slick, currentSlide){
			$slider =  $('.td-slide-box');

			$slider.find(".slick-slide").height("auto");
			$slider.slick("setOption", 'adaptiveHeight', true, true);
		});
		
		$('.td-slide-arrow.left').on('click', function(e){
			e.preventDefault();
			$('.td-slide-box').slick('slickPrev');
		});
		
		$('.td-slide-arrow.right').on('click', function(e){
			e.preventDefault();
			$('.td-slide-box').slick('slickNext');
		});
		
		
		
		$('.td-slide-box').on('afterChange', function(event, slick, direction){
			if($('.td-swipe-icon').is(':visible')){
				$('.td-swipe-icon').hide();
			}
		});

		
		
		
	}
	if($('.td-tooltip-btn').length > 0){
		$('.td-tooltip-btn').on('click', function(e){
			e.preventDefault();
			$('.td-tooltip-btn').tooltipster('open');
		});
	}
	
	
	
	if($('.js-rsp').length > 0){
		enquire.register("screen and (max-width:1200px)", {

			match : function() {
				// medico home img swap
				imgSrc = $('#hin-img-rsp-swap').data('altimg-1200');
				$('#hin-img-rsp-swap').attr('src', imgSrc);
				
			},      

			unmatch : function() {
				// medico home img swap
				imgSrc = $('#hin-img-rsp-swap').data('altimg-big');
				$('#hin-img-rsp-swap').attr('src', imgSrc);
			}
		});
	}
	
	
	
}( jQuery ));
