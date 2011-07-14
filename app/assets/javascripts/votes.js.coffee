# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->

  $('.vote a').click ->

    if $(@).hasClass('voted') == false

      vote = $(@).hasClass('vote_for')

      $.ajax
        type: 'post'
        url: '/votes.json'
        data:
          vote: track_id: track_id, vote: vote
        success: (data) ->
          $('.votes a').removeClass 'voted'
          if data then $(".vote_for").addClass('voted') else $(".vote_against").addClass('voted')
          $('.votes div').text "Voted"
        error: (data) ->
          # console.log data
