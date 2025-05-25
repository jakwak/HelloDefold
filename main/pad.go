components {
  id: "pad"
  component: "/main/pad.script"
}
embedded_components {
  id: "pad_sprite"
  type: "sprite"
  data: "default_animation: \"wall_horizontal\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "textures {\n"
  "  sampler: \"texture_sampler\"\n"
  "  texture: \"/assets/images/walls/walls.atlas\"\n"
  "}\n"
  ""
  scale {
    x: 0.2
  }
}
