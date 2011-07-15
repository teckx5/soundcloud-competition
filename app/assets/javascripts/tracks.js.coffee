jQuery ->

  window.scrollTo(0, 1)

  soundManager.url = '/swfs/'
  soundManager.flashVersion = 9
  soundManager.useFlashBlock = false
  soundManager.useHighPerformance = true
  soundManager.useFastPolling = true
  soundManager.wmode = 'transparent'

  if track_id?

    timecode = (ms) ->
      hms = h: Math.floor(ms/(60*60*1000)), m: Math.floor((ms/60000)%60), s: Math.floor((ms/1000)%60)
      tc = []
      tc.push hms.h if hms.h > 0
      tc.push if hms.m < 10 and hms.h > 0 then "0#{hms.m}" else hms.m
      tc.push if hms.s < 10 then "0#{hms.s}" else hms.s
      tc.join ':'

    key = "J8aFr3h5xyOSkYxsJMYXQ"

    soundManager.onready ->

      $.getJSON "http://api.soundcloud.com/tracks/#{track_id}?format=json&consumer_key=#{key}&secret_token=#{secret_token}&callback=?", (track) ->

        # Load Track...

        $('.info').data track
        $('.waveform').attr(src: track.waveform_url).fadeIn("slow")
        $('.about .comment p').text track.description || ""
        $('.edit').attr href: track.permalink_url + "/edit"
        $("#statsTemplate").tmpl(track).appendTo('.stats ul')

        # Favorite Check

        if $('.favorite').length
          $.getJSON $('.favorite').attr("href"), (data) ->
            $('.favorite').addClass("selected") if not data.errors

        # Create Sound

        soundManager.createSound
          autoLoad: true
          id: "track"
          url: "https://api.soundcloud.com/tracks/#{track.id}/stream?consumer_key=#{key}&secret_token=#{secret_token}"
          volume: 100

          whileloading: -> $('.loaded').css width: (@bytesLoaded / @bytesTotal * 100) + '%'
          whileplaying: -> $('.played').css width: (@position / track.duration * 100) + '%'
          onplay: -> $('.loaded').css width: '100%' if @loaded
          onstop: -> $('.time div').width 0
          onfinish: -> nextTrack()

        $.getJSON "http://api.soundcloud.com/tracks/#{track.id}/comments.json?limit=200&consumer_key=#{key}&secret_token=#{secret_token}&callback=?", (comments) ->
          $.each comments.reverse(), (i, comment) -> addComment comment
          countComments()

      # GUI Events

      $('.controls').click ->
        $('.player').toggleClass "playing"
        soundManager.togglePause "track"

      $('.time').click (event) -> seekTrack(this, event)

      $('.add_comment').click ->
        $('html, body').animate scrollTop: $('.new_comment').position().top

      $('.new_comment .submit').click ->
        $(@).text "Posting..."
        $.ajax
          type: 'post'
          url: '/comments.json'
          data: $('.new_comment').serialize()
          success: (comment) ->
            addComment comment
            countComments()
            $('.new_comment')[0].reset()
            $('.new_comment .submit').text "Post Comment"
            $('html, body').animate scrollTop: $('.share h2:eq(1)').position().top
          error: (data) ->
            # console.log data

        return false

      $('.favorite').click ->
        $that = $(@)
        $.ajax
          type: if $that.hasClass "selected" then 'delete' else 'put'
          url: $that.attr "href"
          success: () ->
            if $that.hasClass "selected" then $that.removeClass "selected" else $that.addClass "selected"
        return false

      # Functions

      seekTrack = (node, event) ->
        $node = $(node)
        loaded = $node.find('.loaded').width()
        available = $node.offset().left
        total = $node.width()

        relative = Math.min loaded, (event.pageX - available) / total

        soundManager.setPosition "track", $('.info').data('duration') * relative

      addComment = (comment) ->
        comment.created_at = $.timeago comment.created_at
        comment.timestamp = timecode comment.timestamp
        $comment = $("#commentTemplate").tmpl(comment).prependTo('.comments')
        $comment.addClass('owner') if $('.info').data().user.id == comment.user.id

      countComments = () ->
        comment_count = $('.comments').children().length
        $('.comment_count').text "#{comment_count} #{if comment_count == 1 then "Comment" else "Comments"}"

      # Reminder Scroll

      $p = $('.player')
      $r = $('.reminder')
      $a = $('.about')

      top = $p.first().position().top + $p.first().outerHeight()

      $(document).scroll ->
        if $(window).width() < 767
          $r.hide()
        else
          st = $(window).scrollTop()
          if st > top
            $r.fadeIn()
            if st > $r.position().top
              $r.addClass "sticky"
            else if st < $a.position().top + $a.outerHeight()
              $r.removeClass "sticky"
          else
            $r.fadeOut()
