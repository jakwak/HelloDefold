components {
  id: "player"
  component: "/player/player.script"
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
    x: 2.0
    y: 2.0
  }
}
embedded_components {
  id: "label"
  type: "label"
  data: "size {\n"
  "  x: 128.0\n"
  "  y: 32.0\n"
  "}\n"
  "blend_mode: BLEND_MODE_SCREEN\n"
  "text: \"player\\n"
  "\"\n"
  "  \"\"\n"
  "font: \"/assets/fonts/korean.font\"\n"
  "material: \"/builtins/fonts/label-df.material\"\n"
  ""
  position {
    y: 24.0
  }
  scale {
    x: 0.5
    y: 0.5
  }
}
