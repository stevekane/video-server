

(function($) {
    
    //this handles class changing with support of next/prev and nav buttons. All animation are supposed to be handled with css3, not js.
    	$.isOnScreen = function(elem,entire)
	{
		var entire = entire === undefined ? true : entire;
		var docViewTop = $(window).scrollTop();
		var docViewBottom = docViewTop + $(window).height();

		var elemTop = $(elem).offset().top;
		var elemBottom = elemTop + $(elem).height();
		if (entire) {
			return ((elemBottom <= docViewBottom) && (elemTop >= docViewTop));
		} else {
			return ( ( elemTop >= docViewTop || elemBottom >= docViewTop ) && ( elemTop <= docViewBottom || elemBottom <= docViewBottom ) )
		}
		
	}
	
	
	//this handles class changing with support of next/prev and nav buttons. All animation are supposed to be handled with css3, not js.
	$.fn.quickSlider = function(options) {
	
		var defaults = {
			slides: "quick-slider-single",			//class of single slides
			next: "quick-slider-next",				//next btn class
			prev: "quick-slider-prev",				//prev btn class
			nav: "quick-slider-nav",				//navigation (circles for example) class
			pauseButton: "quick-slider-pause",		//class of pause button (todo)
			autoplay: 5000,							
			hoverpause : true,						//pause sliding on hover
			pauseInvisible : true,					//pause when slider is not visable on screen
			callback : {				
				slide : function(slide,slider) {}	//callback after each slide
			},
			cascade : {								//it will add initClass to each .className element inside active slide and then it will remove initClass from one element after another with .delay time between. It allows to some cascade aniamtion of content of each slide
				enable : true,
				className : "quick-slider-cascade",
				delay : 100,
				initDelay: 400,
				initClass : "cascade-init"
			}
		};
		options = $.extend({}, defaults, options);	
	
		return $(this).each(function(){
	
			var t = $(this).css('overflow','hidden');
			var keyPressedFlag = false;						//used to ignore pause of slider when keyboard navigating
			var slides = $('.' + options.slides,t),
			prev = $('.' + options.prev,t),
			next = $('.' + options.next,t),
			nav = $('.' + options.nav,t),
			interval = 0;
	
			if ( slides.length < 2 ) {
				slides.eq(0).addClass('active');
				return;
			}
	
			var slide = function(elem) {
				if ( ( t.hasClass('paused') && !keyPressedFlag ) || ( options.pauseInvisible && !$.isOnScreen(t,false) ) ) {					
					return;
				}				
				var index = slides.index(elem);
				$('.last.' + options.slides,t).removeClass('last');
				$('.active.' + options.slides,t).addClass('last').removeClass('active');	    
	    
				$('.active.' + options.nav,t).removeClass('active')
				$('.' + options.nav,t).eq(index).addClass('active');	    
	    	    
				elem.addClass('active');
				
				if ( options.cascade.enable ) {
					
					$("." + options.cascade.className, elem).addClass(options.cascade.initClass).each(function(i){
						$(this).stop().delay(options.cascade.initDelay + i*options.cascade.delay).promise().done(function(){
							$(this).removeClass(options.cascade.initClass);
						})
					})
				}
	    
				clearInterval(interval);
				autoPlay();
				
				options.callback.slide(elem,t);
			};

			
			
			prev.click(function(){
				slide($('.active.' + options.slides,t).prevOrLast('.' + options.slides));
			});
			next.click(function(){
				slide($('.active.' + options.slides,t).nextOrFirst('.' + options.slides));	    
			});
			nav.click(function(){
				if ( $(this).hasClass('active') ) {
					return;
				}
				var index = nav.index(this);
				slide($('.' + options.slides,t).eq(index));
			});
	
			$(document).keydown(function(e){
				if (e.keyCode == 37) {
					keyPressedFlag = true;
					slide($('.active.' + options.slides,t).prevOrLast('.' + options.slides));
				}
				if (e.keyCode == 39) { 
					keyPressedFlag = true;
					slide($('.active.' + options.slides,t).nextOrFirst('.' + options.slides));
				}  
				keyPressedFlag = false;
			});
	
			var autoPlay = function() {
				interval = setInterval(function(){
					slide($('.active.' + options.slides,t).nextOrFirst('.' + options.slides));
				},options.autoplay)
			}
	    
			if ( options.autoplay ) {
				autoPlay();
			}
	    
			if ( options.hoverpause ) {
				slides.mouseenter(function(){		    
					t.addClass('paused');
				});
				slides.mouseleave(function(){		    
					t.removeClass('paused');
				})
			}
			
			slide(slides.removeClass('active').eq(0));
			nav.removeClass('active').eq(0).addClass('active');
			
		});
	}
    
    
    //custom functions
    $.fn.prevOrLast = function(selector)
    {
	var prev = this.prev(selector);
	return (prev.length) ? prev : this.nextAll(selector).last();
    };

    $.fn.nextOrFirst = function(selector)
    {
	var next = this.next(selector);
	return (next.length) ? next : this.prevAll(selector).last();
    }; 
    $.fn.fadeSlideUp = function(){
	var height = $(this).outerHeight();	
	$(this).animate({
	    'top':'-=' + height + 'px'
	},200);
    }
    
    $.fn.fadeSlideIn = function(){
	$(this).each(function(){
	    var left = parseInt($(this).css('left'));
	    
	    $(this).css({
		'opacity':0,
		left: left+80+'px'
	    }).animate({
		'left':left+'px',
		'opacity':1
	    });	    
	})

	
    }

    $.isMobile = function(){
	return !$('.ismobileflag').eq(0).is(':visible');
    }
    
    $.fn.keepRatio = function(ratio) {
	ratio = ratio || $(this).attr('ratio') || 1;
	var t = $(this);
	t.height(t.width/ratio);
	$(window).resize(function(){
	    t.height(t.width/ratio);
	})
    }
    $.fn.tileSlide = function()
    {
	return $(this).each(function(){
	    var elem = $(this);
	    var slides = $('.slide',elem);
		
	    if(slides.length<2) return; 
		
	    var itemH = elem.outerHeight();
		
	    var random = Math.floor(Math.random() * 2000)+1000;	
	    var down = Math.floor(Math.random() * 2);	//		
		
	    var slide = function(down){
				
		var current = $('.slide.current',elem);
		var next = current.nextOrFirst('.slide');
		if ( down ) {
		    current.animate({
			'top':itemH
		    },2000,'easeOutExpo',function(){
			$(this).css({
			    'top':(-1)*itemH
			})
		    }).removeClass('current');
		    next.animate({
			'top':'0px'
		    },2000,'easeOutExpo').addClass('current');
		}	else {
		    current.animate({
			'top':-1*itemH
		    },2000,'easeOutExpo',function(){
			$(this).css({
			    'top':itemH
			})
		    }).removeClass('current');
		    next.animate({
			'top':'0px'
		    },2000,'easeOutExpo').addClass('current');				
		}
	    }
	
	    slides.removeClass('current').eq(0).addClass('current');
		
	    if(down) {
		slides.not('.current').css({
		    'top':(-1)*itemH
		});
	    }
	    else{
		slides.not('.current').css({
		    'top':(1)*itemH
		});
	    }
		
	    setTimeout(function(){		
		slide(down);				
		setInterval(function(){	
				
		    slide(down);
		},4500);
	    },random);	
	});
    };    
    
    
    $.classObjToJQuery = function(classes,dataLabel) {
	var elems = $();
	
	for(var one in classes) {
	    if(classes.hasOwnProperty(one)) {		
		elems = elems.add('.' + one);
		$('.' + one).attr(dataLabel,classes[one])
	    } 
	}
	return elems;	
    }
    
    $.keepRatio = function(classes) {
	
	var setRatio = function(){
	    var elems = $.classObjToJQuery(classes,'ratio');
	    console.log(elems);
	    elems.each(function(){
		var t = $(this);
		var ratio = t.attr('ratio');
	   
		t.attr('ratio',ratio);
		t.height(t.width()/ratio);	    
	    })	    
	}
	setRatio();
	$(window).resize(function(){	    
	    setRatio();
	})

	
    }
    
})(jQuery);