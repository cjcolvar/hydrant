$.widget("ui.iuplayer", {
	options: {
		library: 'jwplayer', // using jwplayer by default
		width: '480',
		height: '270',
		file: '',
		streamer: '',
		provider: 'rtmp', // streaming RTMP by default
		annotations: ''
	},
	_init: function(){ 
  	    console.log();

		// Initiates using a chosen player library
		if (this.options.library === 'jwplayer') {
			jwplayer(this.element.attr('id')).setup({
				'id': 'playerID',
				'width': this.options.width,
				'height': this.options.height,
				'provider': this.options.provider,
				'streamer': this.options.streamer,
				'file': this.options.file,
				'dock': 'true',
				"controlbar.position": "bottom",
				'preload': 'all',
				'bufferlength': '0',
				modes: [
					{
						type: 'flash',
						src: "/jwplayer/player.swf",
						config: { skin: "/jwplayer/modieus5.zip"}
					},
					{type:'html5'}
				],
				// 'file': '/jwplayer/videolong.mp4',
				plugins: {
				        //'/jwplayer/annotation.js': { text: 'XYZ' },
						//'/jwplayer/timeslidertooltipplugin-2.js' :{}
			    }
			});			
		}
		
		// Reads annotations file and populates, if path exists
		if (this.options.annotations != '') {
			// Fetches XML file
			
			// Parses
			
			// Populates
		}
		
	}
});
