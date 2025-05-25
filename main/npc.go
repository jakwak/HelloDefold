components {
  id: "npc"
  component: "/main/npc.script"
  properties {
    id: "id"
    value: "npc_1"
    type: PROPERTY_TYPE_HASH
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
