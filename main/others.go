components {
  id: "others"
  component: "/main/others.script"
}
components {
  id: "hp_bar"
  component: "/main/hp_bar.gui"
}
embedded_components {
  id: "sprite"
  type: "sprite"
  data: "default_animation: \"anim\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "size {\n"
  "  x: 40.0\n"
  "  y: 40.0\n"
  "}\n"
  "textures {\n"
  "  sampler: \"texture_sampler\"\n"
  "  texture: \"/builtins/graphics/particle_blob.tilesource\"\n"
  "}\n"
  ""
}
embedded_components {
  id: "label"
  type: "label"
  data: "size {\n"
  "  x: 128.0\n"
  "  y: 32.0\n"
  "}\n"
  "text: \"ABCD\"\n"
  "font: \"/assets/fonts/korean.font\"\n"
  "material: \"/builtins/fonts/label-df.material\"\n"
  ""
  position {
    y: 20.0
  }
  scale {
    x: 0.7
    y: 0.7
  }
}
embedded_components {
  id: "airplane_factory"
  type: "factory"
  data: "prototype: \"/main/airplane.go\"\n"
  ""
}
