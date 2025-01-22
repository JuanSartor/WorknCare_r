/* Bookmarks
---------------------------------------------------------------- */

var bookmarks = function(){

	var bookmarked = {};
	var lasthash = '';

	return {
		initialize:function(){
            
            //setInterval("bookmarks.checkhash();", 400)            
            
		},
		sethash:function(hash,settings){
            bookmarked[hash] = settings;
            lasthash = hash;			
		},
		getHash:function(hash){
            if (bookmarked[hash]){
                return bookmarked[hash];
            }            
		},

		checkhash:function(){

			var actual_hash = window.location.hash;

			if(actual_hash){
				// If the current hashtag in different from the last hashtag
				// That is: if we have pushed the back / forward buttons
				if(actual_hash!= lasthash && (lasthash != "" && typeof(lasthash) != "undefined")){
                    
                    var settings = bookmarks.getHash(actual_hash);
                    
                    //console.debug(settings);
                    if (settings){
                       //console.debug("cambio");
                        x_goTo(settings.module,settings.submodule,settings.params,settings.destination_id);
                    }
                    
                    lasthash = actual_hash;
                    
                    
				}
			}
		}
		

	};
}();

