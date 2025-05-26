components {
  id: "airplane_sprite"
  component: "/main/airplane.sprite"
  scale {
    x: 0.5
    y: 0.5
  }
}
embedded_components {
  id: "airplane2_sprite"
  type: "sprite"
  data: "default_animation: \"airplane2\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "textures {\n"
  "  sampler: \"texture_sampler\"\n"
  "  texture: \"/main/airplane.atlas\"\n"
  "}\n"
  ""
}
