components {
  id: "bullet"
  component: "/main/bullet.script"
}
components {
  id: "explode"
  component: "/main/assets/explode.particlefx"
  position {
    x: -14.0
  }
}
embedded_components {
  id: "sprite"
  type: "sprite"
  data: "default_animation: \"missile\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "size {\n"
  "  x: 32.0\n"
  "  y: 32.0\n"
  "}\n"
  "size_mode: SIZE_MODE_MANUAL\n"
  "textures {\n"
  "  sampler: \"texture_sampler\"\n"
  "  texture: \"/main/assets/airplane.atlas\"\n"
  "}\n"
  ""
  rotation {
    z: 0.70710677
    w: -0.70710677
  }
  scale {
    x: 0.299837
  }
}
