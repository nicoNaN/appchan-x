MarkNewIPs =
  init: ->
    return if g.VIEW isnt 'thread' or !Conf['Mark New IPs']
    Thread.callbacks.push
      name: 'Mark New IPs'
      cb:   @node

  node: ->
    MarkNewIPs.ipCount = @ipCount
    MarkNewIPs.postIDs = (+x for x in @posts.keys)
    $.on d, 'ThreadUpdate', MarkNewIPs.onUpdate

  onUpdate: (e) ->
    {ipCount, newPosts} = e.detail
    {postIDs} = ThreadUpdater
    return unless ipCount?
    if newPosts.length
      obj = {}
      obj[x] = true for x in MarkNewIPs.postIDs
      added = 0
      added++ for x in postIDs when not (x of obj)
      removed = MarkNewIPs.postIDs.length + added - postIDs.length
      switch ipCount - MarkNewIPs.ipCount
        when added
          i = MarkNewIPs.ipCount
          for fullID in newPosts
            MarkNewIPs.markNew g.posts[fullID], ++i
        when -removed
          for fullID in newPosts
            MarkNewIPs.markOld g.posts[fullID]
    MarkNewIPs.ipCount = ipCount
    MarkNewIPs.postIDs = postIDs

  markNew: (post, ipCount) ->
    suffix = if (ipCount // 10) % 10 is 1 || if (ipCount % 10) is 0
      'th'
    else
      ['st', 'nd', 'rd'][ipCount % 10 - 1] or 'th'
    counter = $.el 'span',
      className: 'ip-counter'
      textContent: "(#{ipCount})"
    post.nodes.nameBlock.title = "This is the #{ipCount}#{suffix} IP in the thread."
    $.add post.nodes.nameBlock, [$.tn(' '), counter]
    $.addClass post.nodes.root, 'new-ip'

  markOld: (post) ->
    post.nodes.nameBlock.title = 'Not the first post from this IP.'
    $.addClass post.nodes.root, 'old-ip'
