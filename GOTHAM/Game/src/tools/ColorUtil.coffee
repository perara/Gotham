

class ColorUtil


  percentColors = [
    {
      pct: 0.0
      color:
        r: 0x00
        g: 0xff
        b: 0
    }
    {
      pct: 0.5
      color:
        r: 0xff
        g: 0xff
        b: 0
    }
    {
      pct: 1.0
      color:
        r: 0xff
        g: 0x00
        b: 0
    }
  ]

  @getColorForPercentage = (pct) ->
    i = 1
    while i < percentColors.length - 1
      if pct < percentColors[i].pct
        break
      i++
    lower = percentColors[i - 1]
    upper = percentColors[i]
    range = upper.pct - (lower.pct)
    rangePct = (pct - (lower.pct)) / range
    pctLower = 1 - rangePct
    pctUpper = rangePct
    color =
      r: Math.floor(lower.color.r * pctLower + upper.color.r * pctUpper)
      g: Math.floor(lower.color.g * pctLower + upper.color.g * pctUpper)
      b: Math.floor(lower.color.b * pctLower + upper.color.b * pctUpper)


    toHex = (c) ->
      hex = c.toString(16)
      if hex.length == 1 then '0' + hex else hex

    return "0x" + toHex(color.r) + toHex(color.g) + toHex(color.b);
    return 'rgb(' + [color.r, color.g, color.b].join(',') + ')'




module.exports = ColorUtil