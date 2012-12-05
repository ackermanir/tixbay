TB = {
		setup: function() {
				var already_favorited = /Favorited/.test($('#hidden_favorite').text());
				if (already_favorited) {
						$('#hidden_favorite').
								replaceWith('<button id="favorited" class="btn">Favorited</button>')
						$('#favorited').click(TB.unfavorite_show);
						return(false);
				}
				//If not logged in, don't place button
				var sign_in_text = $('#log_out').text();
				if(/Log Out/.test(sign_in_text)) {
						$('<button id="favorite_this" class="btn">Favorite</button>').
								insertAfter($('#pricing_end'));
						$('#favorite_this').click(TB.favorite_show);
				}
		},
		favorite_show: function() {
				var url = window.location.pathname;
				var show_id = /show.([\d]+).*/.exec(url)[1];
				$.ajax({type: 'GET',
								url: '/show/' + show_id + '/favorite/do',
								timeout: 5000,
								success: TB.confirm_favorite,
								error: function() { alert('Error, unable to favorite show!'); }
							 });
				return(false);
		},
		unfavorite_show: function() {
				var url = window.location.pathname;
				var show_id = /show.([\d]+).*/.exec(url)[1];
				$.ajax({type: 'GET',
								url: '/show/' + show_id + '/favorite/undo',
								timeout: 5000,
								success: TB.confirm_unfavorite,
								error: function() { alert('Error, unable to unfavorite show!'); }
							 });
				return(false);
		},
		confirm_favorite: function(data) {
				$('#favorite_this').replaceWith('<button id="favorited" class="btn">Favorited</button>')
				$('#favorited').click(TB.unfavorite_show);
				return(false);
		},
		confirm_unfavorite: function(data) {
				$('#favorited').replaceWith('<button id="favorite_this" class="btn">Favorite</button>')
				$('#favorite_this').click(TB.favorite_show);
				return(false);
		},
}
$(TB.setup);
