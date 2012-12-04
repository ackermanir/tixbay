TB = {
		setup: function() {
				var already_favorited = /avorited/.test($('#favorited').text());
				if (already_favorited) {
						return(false);
				}
				//If not logged in, don't place button
				var sign_in_text = $('#sign_in').text();
				if(/log out/.test(sign_in_text)) {
						$('<p id="favorite_this" class="btn">Favorite</p>').
								insertAfter($('#pricing_end'));
						$('#favorite_this').click(TB.favorite_show);
				}
		},
		favorite_show: function() {
				var url = window.location.pathname;
				var show_id = /show.([\d]+).*/.exec(url)[1];
				$.ajax({type: 'GET',
								url: '/show/' + show_id + '/favorite',
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