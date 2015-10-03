_ = require( "lodash" )

module.exports = (robot) ->
  reactions = [
    {
      on: /\bold\b/i,
      reply: ["baita foder tu e o old", "gold", "Oldar sem partilhar dá sete anos sem pinar"]
    },
    {
      on: /o burro chegou ao monte e disse/i,
      reply: ["como é, rapazes"]
    },
    {
      on: /sabes quem/i,
      reply: ["A TUA VELHA"],
    },
    {
      on: /américus|americus/i,
      reply: ["quem?"],
    },
    {
      on: /recruiter|recrooter|recruiting/i,
      reply: ["recrutar? só se for o júlio"],
    },
    {
      on: /mp3|MP3|v0|V0|vbr|VBR|legit|LEGIT|flac/i,
      reply: ["audiofag"],
    },
    {
      on: /ai ui/i,
      reply: ["ai ui chuvinha"],
    },
    {
      on: /Jessie|jessie/i,
      reply: ["JESSE"],
    },
    {
      on: /horoscopo|horóscopo|horoscope|homeopatia|homeopathy|deepak|Deepak|chopra|Chopra|scientology|Scientology|cientologia|religion|Religion|religião|cristianismo|cristianity|budhism|budismo|budista|budhist|induhism|islam|islamismo|bible|bíblia|coran|corão|creationism|creacionismo/i,
      reply: ["*bullshit*cof*cof*"]
    },
    {
      on: /morrer|morreram|morres/i,
      reply: ["morrer mesmo? não é como aquelas pessoas que dizem que morrem se não forem ver os Simply Red mas não morrem nada, ficam só tristes?"]
    },
    {
      on: /cloud|synergy|big data|paradigm shift|entrepreneur|trep|hustle|crush it|crushing it/i,
      reply: ["bull-fucking-shit"]
    },
    {
      on: /portugal|Portugal|tuga|português|portugues|portuguese/i,
      reply: ["BUNGA"]
    },
    {
      on: /hitler|Hitler|HITLER/i,
      reply: "6 milhões de judeus e um palhaço"
    },
    {
      on: /Merkel/i,
      reply: ["merkel? a culpa da crise é dela", "MERKELZILLA"]
    },
    {
      on: /um palhaço/i,
      reply: ["tas a ver? toda a gente se está a cagar para os judeus"]
    },
    {
      on: /costa/i,
      reply: ["VEEEEEELHO"]
    },
    {
      on: /"old"/i,
      reply: ["chegou o bófia do old"]
    }
  ]

  _.each( reactions, (reaction) ->
    robot.hear reaction.on, (res) ->
      res.send _.sample reaction.reply
  )
