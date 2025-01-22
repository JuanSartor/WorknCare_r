	//TODO: Anexar todo lo necesario para funciones de cadena
	
	/********************************
	*
	*	Manejo de Strings
	*
	*********************************/
	
	//convierte un string a seo format
	var str2Seo = function(text){
        
        text = trim(text);        
        text = text.toLowerCase();
        text = text.replace(/,/g, "_");
        text = text.replace(/:/g, "_");
        text = text.replace(/-/g,"_");
        text = text.replace(/\s/g, "_");
        text = text.replace(/,/g, "_");
        text = text.replace(/''/g, "");	
        text = text.replace(/\\/g, "");        
        text = text.replace(/;/g, "_");
        text = text.replace(/:/g, "_");
        text = text.replace(/á/g, "a");
        text = text.replace(/é/g, "e");
        text = text.replace(/í/g, "i");
        text = text.replace(/ó/g, "o");
        text = text.replace(/ú/g, "u");
        text = text.replace(/ä/g, "a");
        text = text.replace(/ë/g, "e");
        text = text.replace(/ï/g, "i");
        text = text.replace(/ö/g, "o");
        text = text.replace(/ü/g, "u");
        text = text.replace(/'.'/g, "_");
        text = text.replace(/'!'/g, "");
        text = text.replace(/'¡'/g, "");
        text = text.replace(/'+'/g, "");
        text = text.replace(/'?'/g, "");
        text = text.replace(/'¿'/g, "");
        //text = text.replace(/'('/g, "");
        //text = text.replace(/')'/g, "");
        //text = text.replace(/'['/g, "");
        //text = text.replace(/']'/g, "");
       // text = text.replace(/'{'/g, "");
       // text = text.replace(/'}'/g, "");
       // text = text.replace(/'%'/g, "_");
        text = text.replace(/ñ/g, "ni");
        text = text.replace(/à/g, "a");
        text = text.replace(/è/g, "e");
        text = text.replace(/ì/g, "i");
        text = text.replace(/ò/g, "o");
        text = text.replace(/ù/g, "u");
        text = text.replace(/À/g, "a");
        text = text.replace(/È/g, "e");
        text = text.replace(/Ì/g, "i");
        text = text.replace(/Ò/g, "o");
        text = text.replace(/Ù/g, "u");
        text = text.replace(/â/g, "a");
        text = text.replace(/ê/g, "e");
        text = text.replace(/î/g, "i");
        text = text.replace(/ô/g, "o");
        text = text.replace(/û/g, "u");
        text = text.replace(/Â/g,"a");
        text = text.replace(/Ê/g,"e");
        text = text.replace(/Î/g,"i");
        text = text.replace(/Ô/g,"o");
        text = text.replace(/Û/g,"u");
        text = text.replace(/ç/g,"c");
        text = text.replace(/Ç/g,"c");
        text = text.replace(/ã/g,"a");
        text = text.replace(/õ/g,"õ");
        text = text.replace(/c/g,"c");
        text = text.replace(/g/g,"g");
        text = text.replace(/G/g,"g");
        text = text.replace(/g/g,"g");
        text = text.replace(/g/g,"g");
        text = text.replace(/g/g,"g");
        text = text.replace(/G/g,"g");

        
        return text;
    }
    
    //funcion que permite cortar el excedente de texto en un objeto cuando se supera una cantidad de lineas
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
		el.after('<a href="#" class="text-cut-lnk-mas">voir plus</a');
		
		el.next('a.text-cut-lnk-mas').bind('click',function(e){
			e.preventDefault();
			var parEl = $(this).prev(objClass).outerHeight();
			
			if(parEl < totalHeight){
				$(this).prev(objClass).animate({
					height: totalHeight+16
				}, 600);
				$(this).html('voir moins');
			}else if(parEl >= totalHeight){
				$(this).prev(objClass).animate({
					height: parentHeight
				}, 600);
				$(this).html('voir plus');
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
				el.after('<a href="#" class="text-cut-lnk-mas">voir plus</a');

				el.next('a.text-cut-lnk-mas').bind('click',function(e){
					e.preventDefault();
					var parEl = $(this).prev(objClass).outerHeight();

					if(parEl < totalHeight){
						$(this).prev(objClass).animate({
							height: totalHeight+16
						}, 600);
						$(this).html('voir moins');
					}else if(parEl >= totalHeight){
						$(this).prev(objClass).animate({
							height: parentHeight
						}, 600);
						$(this).html('voir plus');
					}



				});

			}
		//@if general	
		}
		//@foreach
			
	});
		
	
	//--	
	}
        /**Validador expresion regular email
         * 
         * @param {type} email
         * @returns {unresolved}
         */
        var validarEmail=function(email){
            return email.match(/^[a-zA-Z0-9\._-]+@([a-zA-Z0-9_-]+[.][a-zA-Z0-9_-]+)+$/);
            
        }
	


