# Copyright (c) 2012 mi93.com All rights reserved.
# Author: unstop ( unstop01@gmail.com )


# bind all at
$(".reply_content a[href^='/member/']").on "click", (e)->
	e.preventDefault()
	targetName = $(this).text()
	# find parent cell
	$(this).parents('.cell').prevAll().each (i) ->
		author = $(this).find("strong a[href^='/member/']").text()
		if author is targetName
			that = $(this);
			$("html,body").animate {scrollTop: $(this).offset().top - 150}, 600, ->
				that.css backgroundColor: '#FFD600' 
				that.animate 
					backgroundColor: '#FFF' 
				, 600
			return false