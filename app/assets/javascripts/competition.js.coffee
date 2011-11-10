jQuery ->
  
  # center caption  
  $(window).resize ->
    $('.caption > div').css
      top: ( $('.caption').height() - $('.caption > div').height() ) / 2
      
  $(window).resize()

  # initialize chosen select

  $(".chzn-select").chosen()

  # mobile check

  if /mobile/i.test(navigator.userAgent)

    # scroll fix

    setTimeout =>
      window.scrollTo(0, 1)
    ,1000

    # temp fix for mobile hijack problem

    $("a:not(.vote_for, .vote_against, .favorite)").click (event) ->
      event.preventDefault()
      window.location = $(this).attr("href")

  # soundManager

  soundManager.url = '/swfs/'
  soundManager.flashVersion = 9
  soundManager.useFlashBlock = false
  soundManager.useHighPerformance = true
  soundManager.useFastPolling = true
  soundManager.wmode = 'transparent'

  # timecode

  timecode = (ms) ->
    hms = h: Math.floor(ms/(60*60*1000)), m: Math.floor((ms/60000)%60), s: Math.floor((ms/1000)%60)
    tc = []
    tc.push hms.h if hms.h > 0
    tc.push if hms.m < 10 and hms.h > 0 then "0#{hms.m}" else hms.m
    tc.push if hms.s < 10 then "0#{hms.s}" else hms.s
    tc.join ':'

  # load players

  soundManager.onready ->

    loadPlayer = (node) ->

      track_id = $(node).attr "href"

      $player = $("#playerTemplate").tmpl()
      $(node).replaceWith $player

      $.getJSON "http://api.soundcloud.com/tracks/#{track_id}?format=json&consumer_key=#{key}&callback=?", (track) ->

        $player.data(track)
        $player.find('.waveform').attr(src: track.waveform_url).fadeIn("slow")
        if $('.info').length then loadInfo(track)

        soundManager.createSound
          autoLoad: false
          id: "track_#{track.id}"
          url: "https://api.soundcloud.com/tracks/#{track.id}/stream?consumer_key=#{key}"
          volume: 100
          whileloading: -> $player.find('.loaded').css width: (@bytesLoaded / @bytesTotal * 100) + '%'
          whileplaying: -> $player.find('.played').css width: (@position / track.duration * 100) + '%'
          onplay:       -> $player.find('.loaded').css width: '100%' if @loaded
          onstop:       -> $player.find('.time div').width 0
          onfinish:     -> $player.removeClass('playing')

        if $('.comments').length then loadComments(track.id)
        if $('.favorite').length then loadFavorite()
        if $('.reminder').length then showReminder()

    loadPlayers = () ->

      $('.player').each -> loadPlayer @

      $('.controls').click ->
        $player = $(@).closest ".player"
        $player.toggleClass "playing"
        soundManager.togglePause "track_#{$player.data().id}"

      $('.time').click (event) -> seekTrack(this, event)

    loadPlayers()

    loadInfo = (track) ->
      $('.about .comment p').text track.description || ""
      $('.edit').attr href: track.permalink_url + "/edit"
      $("#statsTemplate").tmpl(track).appendTo('.stats ul')
      $('.artwork').attr href: track.permalink_url

  # GUI Events

  ## Scroll Top

  $('.top').click ->
    $('html, body').animate scrollTop: 0
    return false

  ## Edit Form

  $('.edit_competition .submit').click ->
    $('.edit_competition').submit()

  $('.new_track .submit').click ->
    if $(@).hasClass('disabled')
      alert "You must agree to the contest rules to submit."
    else
      $('.new_track').submit()
    return false
      
  $(':checkbox').click ->
    if $(@).is(':checked')
      $('.new_track .submit, .upload').removeClass('disabled')
    else
      $('.new_track .submit, .upload').addClass('disabled')

  ## Comments

  $('.add_comment').click ->
    $('html, body').animate scrollTop: $('.new_comment').position().top

  $('.new_comment .submit').click ->
    $(@).text "Posting..."
    $.ajax
      type: 'post'
      url: '/comments.json'
      data: $('.new_comment').serialize()
      success: (comment) ->
        loadComment comment
        countComments()
        $('.new_comment')[0].reset()
        $('.new_comment .submit').text "Post Comment"
        $('html, body').animate scrollTop: $('.share h2:eq(1)').position().top
    return false

  ## Favorites

  $('.favorite').click ->
    $that = $(@)
    $.ajax
      type: if $that.hasClass "selected" then 'delete' else 'put'
      url: $that.attr "href"
      success: () ->
        if $that.hasClass "selected" then $that.removeClass "selected" else $that.addClass "selected"
      error: () ->
        # error
    return false

  ## Voting

  $('.vote_for, .vote_against').click ->
    $('.votes div').text "Voting"
    if $(@).hasClass('voted') == false
      vote = $(@).hasClass('vote_for')
      $.ajax
        type: 'post'
        url: '/votes.json'
        data:
          vote: track_id: $('.player').data().id, vote: vote
        success: (data) ->
          $('.votes a').removeClass 'voted'
          if data then $(".vote_for").addClass('voted') else $(".vote_against").addClass('voted')
          $('.votes div').text "Voted"
        error: (data) ->
          # error
    return false

  # Functions

  ## Player

  seekTrack = (node, event) ->
    $time     = $(node)
    $player   = $time.closest('.player')
    loaded    = $time.find('.loaded').width()
    available = $time.offset().left
    total     = $time.width()
    relative = Math.min loaded, (event.pageX - available) / total
    soundManager.setPosition "track_#{$player.data().id}", $player.data().duration * relative

  ## Comments

  loadComment = (comment) ->
    comment.created_at = $.timeago comment.created_at
    comment.timestamp = timecode comment.timestamp
    $comment = $("#commentTemplate").tmpl(comment).prependTo('.comments')
    $comment.addClass('owner') if $('.player').data().user.id == comment.user.id

  countComments = () ->
    count = $('.comments').children().length
    $('.comment_count').text "#{count} #{if count == 1 then "Comment" else "Comments"}"

  loadComments = (track_id) ->
    $.getJSON "http://api.soundcloud.com/tracks/#{track_id}/comments.json?limit=200&consumer_key=#{key}&callback=?", (comments) ->
      $.each comments.reverse(), (i, comment) -> loadComment comment
      countComments()

  ## Favorites

  loadFavorite = () ->
    $.ajax
      type: 'get'
      url: $('.favorite').attr('href')
      success: (data) ->
        $('.favorite').addClass('selected')
      error: (err) ->
        # error
        
  ## Reminder Player

  showReminder = () ->
    $p = $('.player')
    $r = $('.reminder')
    $a = $('.about')

    top = $p.offset().top + $p.outerHeight()

    $(document).scroll ->
      if $(window).width() < 767
        $r.hide()
      else
        st = $(window).scrollTop()
        if st > top
          $r.find('h2').after $p
          $r.fadeIn()
          if st > $r.position().top
            $r.addClass "sticky"
          else if st < $a.position().top + $a.outerHeight()
            $r.removeClass "sticky"
        else
          $r.hide()
          $p.appendTo('.holder')