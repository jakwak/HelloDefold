components {
  id: "other_player"
  component: "/player/other_player.script"
}
embedded_components {
  id: "sprite"
  type: "sprite"
  data: "default_animation: \"anim\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "textures {\n"
  "  sampler: \"texture_sampler\"\n"
  "  texture: \"/builtins/graphics/particle_blob.tilesource\"\n"
  "}\n"
  ""
  scale {
    x: 3.0
    y: 3.0
  }
}
embedded_components {
  id: "label"
  type: "label"
  data: "size {\n"
  "  x: 128.0\n"
  "  y: 32.0\n"
  "}\n"
  "color {\n"
  "  y: 0.0\n"
  "  z: 0.0\n"
  "}\n"
  "text: \"\\353\\213\\244\\353\\245\\270 \\354\\202\\254\\354\\232\\251\\354\\236\\220 \"\n"
  "font: \"/assets/fonts/korean.font\"\n"
  "material: \"/builtins/fonts/label-df.material\"\n"
  ""
  position {
    y: 40.0
  }
}
