jQuery ->
  
  # timecode = (ms) ->
  #   hms = h: Math.floor(ms/(60*60*1000)), m: Math.floor((ms/60000)%60), s: Math.floor((ms/1000)%60)
  #   tc = []
  #   tc.push hms.h if hms.h > 0
  #   tc.push if hms.m < 10 and hms.h > 0 then "0#{hms.m}" else hms.m
  #   tc.push if hms.s < 10 then "0#{hms.s}" else hms.s
  #   tc.join ':'
  
  $recorder = $('.recorder ')
  $record   = $('.recorder .record')
  $play     = $('.recorder .play')
  $stop     = $('.recorder .stop')
  $upload   = $('.upload')

  Recorder.initialize
    swfSrc: "/swfs/recorder.swf"
  
  record = () ->
    Recorder.record
      start: ->
        $record.text "Recording..."
      progress: (ms) ->
        console.log ms
        
  stop = () ->
    $record.text "Record"
    $play.text "Play"
    Recorder.stop()
      
  play = () ->
    stop()
    Recorder.play
      progress: (ms) ->
        console.log ms

  upload = () ->
    $.ajax
      type: 'get'
      url: '/record'
      success: (url) ->
        $upload.text "Uploading..."
        Recorder.upload
          url: url
          audioParam: "track[asset_data]"
          params:
            "track[title]": "Cheer"
            "track[sharing]": "public"
          success: (res) ->
            $upload.text "Saving..."
            $.ajax
              type: 'post'
              url: '/tracks.json'
              data:
                track: tid: $.parseJSON(res).id
              success: (data) ->
                $upload.text "Redirecting..."
                setTimeout "window.location='/tracks/#{data.id}'", 7500
              error: (err) ->
                console.log "track creation failed"
          error: (err) ->
            console.log "upload to soundcloud failed"
      error: (err) ->
        console.log "token grab failed"
  
  # GUI Actions
  
  $record.click ->
    if $record.text() == "Record"
      record()
    else
      return false
      
  $play.click -> play()
  $stop.click -> stop()
  
  $upload.click ->
    if $upload.hasClass('disabled')
      alert "You must agree to the rules to submit."
    else
      if $upload.text() == "Submit"
        upload()
      else
        return false
    return false
