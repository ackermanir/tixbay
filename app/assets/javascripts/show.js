TB = {
		setup: function() {
				//If user has already favorited, don't place button
				//$('<div id="favorited">Favorited</div></br>').
				//		insertAfter($('#pricing_end'));
				$('<p id="favorite_this" class="btn">Favorite</p>').
						insertAfter($('#pricing_end'));
				$('#favorite_this').click(TB.favorite_show);
		},
		favorite_show: function() {
				var url = window.location.pathname;
				var show_id = /show.([\d]+).*/.exec(url)[1];
				$.ajax({type: 'POST',
								url: '/show/117/favorite/0',
								//url: '/show/' + show_id + '/favorite/' + user_id,
								timeout: 5000,
								success: TB.confirm_favorite,
								error: function() { alert('Error, unable to favorite show!'); }
							 });
				return(false);
		},
		confirm_favorite: function(data) {
				$('#favorite_this').replaceWith('<div id="favorited">Favorited</div>')
				return(false);
		},
}
$(TB.setup);