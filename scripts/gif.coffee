# Description:
#   A way to interact with the Google Images API.
#
# Commands:
#   <query>.gif - Queries Google Images for animations of <query> and returns a random top result.

module.exports = (robot) ->
  robot.hear /^(?!https?:\/\/)(.*?)(\.gif)/i, (msg) ->
    imageMe msg, msg.match[1], (url) ->
      msg.send url

imageMe = (msg, query, callback) ->
    q = v: '1.0', rsz: '8', q: query, safe: 'active'
    q.imgtype = 'animated'
    msg.http('https://ajax.googleapis.com/ajax/services/search/images')
      .query(q)
      .get() (err, res, body) ->
        if err
          msg.send "Encountered an error :( #{err}"
          return
        if res.statusCode isnt 200
          msg.send "Bad HTTP response :( #{res.statusCode}"
          return
        images = JSON.parse(body)
        images = images.responseData?.results
        if images?.length > 0
          image = msg.random images
          callback ensureImageExtension image.unescapedUrl

ensureImageExtension = (url) ->
  ext = url.split('.').pop()
  if /(png|jpe?g|gif)/i.test(ext)
    url
  else
    "#{url}#.png"
