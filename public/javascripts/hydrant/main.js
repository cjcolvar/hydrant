var totalW = $("#progressBar").width();
var barOffsetLeft = $("#progressBar").offset().left;

// Tricks jwplayer into preloading
jwplayer().play();
jwplayer().pause();

$('#progressBar').click(function(e){
	var dur = jwplayer().getDuration();
	if (dur == 0) {
		jwplayer().play();
	}
	var x = e.pageX - barOffsetLeft;
	jwplayer().seek(dur * x / totalW);
})


function getOffsetFromTime(time) {
	var dur = jwplayer().getDuration();
	return totalW * time / dur;
}

/*******************************************
**** Annotations processing & populating ***
********************************************/

var annosGlob = null; 
var metaReady = false;
var annoStart = []; // start time of each anno
var annoEnd = []; // end time of each anno

// The marker positioning can only be calculated once duration metadata gets here
jwplayer().onMeta(function(data){
	if (!metaReady && data.metadata.duration > 0) {	
		metaReady = true;
		checkMetaAndAnnoComplete();
	}
})

// Stores annotations in a global object and waits for metadata to arrive
function storeAnnos(annos) {
	annoGlob = annos;
	checkMetaAndAnnoComplete();
}

// Calculates annotations marker & box positioning, populates into player
function processAnnos(annos) {
	
	// Gets annotation of current playing video. 
	// An annotation file might contain annos for different videos in a playlist or a mashup
	var curAnnos = annos["http://vov.indiana.edu/demo1/Canvas-f1r"];

	// Iterates through annos collection
	for (var i in curAnnos) {
		var anno = curAnnos[i];
		
		// Creates a marker 
		var annoMarker = $('<div class="marker lv' + i + '"></div>');
		
		// Positions it on the progress bar
		// Here Im assuming timecode is the 2nd param in media fragment. TODO: make it flexible
		annoStart.push(anno.targets[0].fragments[1].fragmentInfo[0]);
		annoEnd.push(anno.targets[0].fragments[1].fragmentInfo[1]);
		annoMarker.css('left',  getOffsetFromTime(annoStart[i]) + 'px');
		$('#progressElapsed').before(annoMarker);
		
		// Creates an actual annotation to be put under the progress bar
		var annoNote = $('<div class="note lv' + i + '"><span class="title">' + anno.body.title + '</span><span class="expand">[+]</span></div>');

		if (i == curAnnos.length - 1) {
			var css = annoNote.css('border');
			console.log(css);
			annoNote.css('border-bottom', '2px solid');
		}
		$('#notes').append(annoNote);
		
		// Creates a bubble overlaid on to the video
		var annoBox = anno.targets[0].fragments[0].fragmentInfo;
		var map = {
			'left': annoBox[0] + 'px',
			'top': annoBox[1] + 'px',
			'width': annoBox[2] + 'px',
			'height': annoBox[3] + 'px',
		}		
		var bubble = $('<div class="bubble lv' + i + '">' + anno.body.value + '<span class="bottomRight"></span></div>').css(map);

		$('object').before(bubble);
	}
}

function checkMetaAndAnnoComplete() {
	if (metaReady && annoGlob) {
		processAnnos(annoGlob);	
	}
}

fetch_annotations('/Transcriptions-f1rc.xml', storeAnnos);


/*******************************************
******** Progress bar manipulation *********
********************************************/

// Keeps track of the last time we processed
var prevT = 0;
jwplayer().onTime(function(data){
				// console.log(data);
				var totalT = data.duration;
				var curT = data.position;
				var curW = totalW * curT / totalT;
				$("#progressElapsed").width(curW);
				
				// Checks every second to see if we need to display any bubble
				if ( Math.floor(curT) - prevT > 0 || curT < prevT ) {
					// Remembers the time so we can check if we've already run this job in this second 
					prevT = Math.floor(curT);
					for (var i in annoStart) {
						var curBubble = $('.bubble.lv' + i);
						if (curT >= annoStart[i] && curT < annoEnd[i]) {
							// Displays time left for this bubble
							curBubble.find('.bottomRight').html(annoEnd[i] - prevT);
							
							// Shows bubble if not already
							if (curBubble.css('display') === 'none') {
								curBubble.show();
							}
						} 
						else if ((curT < annoStart[i] || curT >= annoEnd[i]) && curBubble.css('display') != 'none') {
							curBubble.hide();
						}
					}
				}
			})
			

$('.expand').live('click', function(){
	var change = 30;

	// Gets parent of clicked item
	var parent = $(this).parent();

	// Increases parent height
	parent.height(parent.height() + change);

	// Finds current level of parent
	var classList = parent.attr('class').split(/\s+/);
	$.each( classList, function(index, item){
	    if (item.indexOf('lv') == 0) {
	    	var i = parseInt(item.substr(2));

			// Lengthens markers at lower levels
			for (var j = i + 1; j < 100; j++) {
				var nextMarker = $('.marker.lv' + j);
				if (!nextMarker[0]) {
					console.log("break");
					break;
				}
				nextMarker.height(nextMarker.height() + change);
			}
	    }
	});
	
	$(this).attr('class', 'collapse').html('[-]');
})

$('.collapse').live('click', function(){
	var change = 30;

	// Gets parent of clicked item
	var parent = $(this).parent();

	// Increases parent height
	parent.height(parent.height() - change);

	// Finds current level of parent
	var classList = parent.attr('class').split(/\s+/);
	$.each( classList, function(index, item){
	    if (item.indexOf('lv') == 0) {
	    	var i = parseInt(item.substr(2));

			// Lengthens markers at lower levels
			for (var j = i + 1; j < 100; j++) {
				var nextMarker = $('.marker.lv' + j);
				if (!nextMarker[0]) {
					console.log("break");
					break;
				}
				nextMarker.height(nextMarker.height() - change);
			}
	    }
	});
	
	$(this).attr('class', 'expand').html('[+]');
})

$('.title').live('click', function(){
	var change = 30;

	// Gets parent of clicked item
	var parent = $(this).parent();

	// Finds current level of parent
	var classList = parent.attr('class').split(/\s+/);
	$.each( classList, function(index, item){
	    if (item.indexOf('lv') == 0) {
	    	var i = parseInt(item.substr(2));

			jwplayer().seek(annoStart[i]);
	    }
	});
})
