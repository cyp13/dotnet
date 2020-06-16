/*
 * jQuery and Bootsrap3 Plugin prettyFile
 *
 * version 2.0, Jan 20th, 2014
 * by episage, sujin2f
 * Git repository : https://github.com/episage/bootstrap-3-pretty-file-upload
 */
( function( $ ) {
	$.fn.extend({
		prettyFile: function( options ) {
			var defaults = {
				text : "选择文件"
			};
			var options =  $.extend(defaults, options);
			var plugin = this;

			function make_form( $el, text ,multiple) {

				$el.hide();
				if(multiple){
					$el.wrap('<div class="diyFile" style="margin-bottom:5px;"></div>');
					$el.removeAttr(multiple);
					var appendDiv = $('<div class="input-group">');
					appendDiv.append('<span class="input-append input-group-btn">\
						<button class="btn btn-white" type="button">' + text + '</button>\
						</span>');
					var appendInput = $('<input class="input-append input-large form-control" type="text">');
					appendInput.addClass($el.attr('class'));
					appendInput.attr('placeholder', $el.attr('placeholder'));
					appendDiv.append(appendInput);
					appendDiv.append('<span class="input-group-btn">\
						<a onclick="$addFile(this)" class="btn btn-sm btn_success">\
						<i class="fa fa-plus"></i></a>\
						</span>\
						<span class="input-group-btn">\
						<a onclick="$deleteFile(this)" class="btn btn-sm btn_success">\
						<i class="fa fa-minus"></i></a>\
						</span>');
					$el.after(appendDiv);
					/*
					$el.wrap('<div class="diyFile" style="margin-bottom:5px;"></div>');
					$el.removeAttr(multiple);
					$el.after( '\
							<div class="input-group"">\
							<span class="input-append input-group-btn">\
							<button class="btn btn-white" type="button">' + text + '</button>\
							</span>\
							<input class="input-append input-large form-control" type="text">\
							<span class="input-group-btn">\
							<a onclick="$addFile(this)" class="btn btn-sm btn_success">\
							<i class="fa fa-plus"></i></a>\
							</span>\
							<span class="input-group-btn">\
							<a onclick="$deleteFile(this)" class="btn btn-sm btn_success">\
							<i class="fa fa-minus"></i></a>\
							</span>\
							</div>\
					' );
					*/
				}else{
					$el.wrap('<div></div>');
					$el.after( '\
							<div class="input-group"">\
							<span class="input-append input-group-btn">\
							<button class="btn btn-white" type="button">' + text + '</button>\
							</span>\
							<input class="input-append input-large form-control" type="text">\
							</div>\
					' );
				}

				return $el.parent();
			};
			
			function bind_change( $wrap, multiple ) {
				$wrap.find( 'input[type="file"]' ).change(function () {
					// When original file input changes, get its value, show it in the fake input
					var files = $( this )[0].files,
					info = '';

					if ( files.length == 0 )
						return false;

					if ( !multiple || files.length == 1 ) {
						var path = $( this ).val().split('\\');
						info = path[path.length - 1];
					} else if ( files.length > 1 ) {
						// Display number of selected files instead of filenames
						info = files.length + ' files selected';
					}

					$wrap.find('input.input-append').val( info );
				});
			};

			function bind_button( $wrap, multiple ) {
				$wrap.find( '.input-append' ).click( function( e ) {
					e.preventDefault();
					$wrap.find( 'input[type="file"]' ).click();
				});
			};

			return plugin.each( function() {
				$this = $( this );

				if ( $this ) {
					var multiple = $this.attr( 'multiple' );
					$wrap = make_form( $this, options.text ,multiple);
					bind_change( $wrap, multiple );
					bind_button( $wrap );
				}
			});
		}
	});
}( jQuery ));

//添加inputfile框
function $addFile(dom){
	var newDom=$(dom).parent().parent().parent().find('input[type="file"]');
	newDom=$(newDom).clone().attr("multiple","multiple");
	$(dom).parent().parent().parent().parent().append(newDom);
	newDom.prettyFile(null);
}
//删除inputfile框
function $deleteFile(dom){
	var l=$(dom).parent().parent().parent().siblings().length;
//	if($("i.fa-minus").length == 1){
	if(l == 0){
//		alert("无法删除");
		return;
	}
	else{
		$(dom).parent().parent().parent().remove();
	}
}

