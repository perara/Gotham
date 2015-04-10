class Converters

  @formatSizeUnits = (bytes) ->
    if bytes >= 1024**4 then bytes = (bytes / 1024**4).toFixed(2) + ' TB'
    else if bytes >= 1024**3 then bytes = (bytes / 1024**3).toFixed(2) + ' GB'
    else if bytes >= 1024**2 then bytes = (bytes / 1024**2).toFixed(2) + ' MB'
    else if bytes >= 1024 then bytes = (bytes / 1024).toFixed(2) + ' KB'
    else if bytes > 1 then bytes = bytes + ' bytes'
    else if bytes == 1 then bytes = bytes + ' byte'
    else bytes = '0 byte'

    return bytes