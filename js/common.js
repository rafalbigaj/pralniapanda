
var current_subpage = null;

function fadeInContent() {
	contentDiv = $('#content');
	contentDiv.css('display', 'none'); 
	contentDiv.css('visibility', 'visible'); 
	contentDiv.fadeIn(300);
}

function fadeOutContent() {
	$('#content').fadeOut(300);
}

function load_subpage(page_id) {
	$('#main_page').fadeOut("def", function() {
		$(page_id).fadeIn("def");	});
	current_subpage = page_id;
}

function load_main() {
	if( current_subpage ) {
		$(current_subpage).fadeOut("def", function() {
			$('#main_page').fadeIn("def"); } );	
	}
	current_subpage = null;
}

function show_map(id) {
	hide_map(".BigMap");
	var mapDiv = $(id);
	var zumiLink = $(".ZumiLink");
	var top = Math.floor($(window).height()/2-mapDiv.height()/2) + $(window).scrollTop();
	var left = Math.floor($(window).width()/2-mapDiv.width()/2);
	mapDiv.css('top', top); 
	mapDiv.css('left', left);
	zumiLink.css('top', 0);
	zumiLink.css('left', 0); 
	zumiLink.css('opacity', 0.8);
	mapDiv.fadeIn(400);	
}

function hide_map(id) {
	$(id).fadeOut(300);
}