RemoveSlugs =
	init: ->
		return unless Conf['Remove Slugs'] and not Conf['JSON Navigation']
		$.ready RemoveSlugs.initReady

	initReady: ->
		unless g.VIEW is 'thread'
			for op in $$ ".postContainer .post.op .postInfo"
				postnum = $ 'a[title="Reply to this post"]', op
				el = $ '.replylink', op
				el.href = "thread/#{postnum.textContent}"