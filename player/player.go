components {
  id: "player"
  component: "/player/player.script"
}
embedded_components {
  id: "other_player_factory"
  type: "factory"
  data: "prototype: \"/player/other_player.go\"\n"
  ""
}
