components {
  id: "pad_script"
  component: "/main/pad.script"
}
embedded_components {
  id: "sprite"
  type: "sprite"
  data: "default_animation: \"wall_horizontal\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "textures {\n"
  "  sampler: \"texture_sampler\"\n"
  "  texture: \"/assets/images/walls/walls.atlas\"\n"
  "}\n"
  ""
  position {
    x: 0.0
    y: 0.0
  }
  scale {
    x: 0.2
  }
}
