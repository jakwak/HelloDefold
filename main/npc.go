components {
  id: "npc"
  component: "/main/npc.script"
}
components {
  id: "explode1"
  component: "/main/assets/explode.particlefx"
  position {
    y: -9.0
  }
}
components {
  id: "explode2"
  component: "/main/assets/explode.particlefx"
  position {
    x: 7.0
  }
}
components {
  id: "explode3"
  component: "/main/assets/explode.particlefx"
  position {
    x: -7.0
  }
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
  id: "factory"
  type: "factory"
  data: "prototype: \"/main/airplane.go\"\n"
  ""
}
