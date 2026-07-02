#import "vars.typ"
#import "lib.typ"

#let init = (
  sql: (:),
  fields: (),
  params: (),
  layout: (:),
  meta: (name: str, description: str, tags: (), multipage: bool, version: str),
  body: () => {},
  index: 4,
  total: 12,
) => [
  #let fieldData = if "data" in sys.inputs { json.decode(sys.inputs.at("data")) } else { lib.build-example(fields) }
  #let paramsData = if "params" in sys.inputs { json.decode(sys.inputs.at("params")) } else {
    lib.build-example(params)
  }

  #let args = (
    index: if "index" in sys.inputs { sys.inputs.at("index") } else { index },
    total: if "total" in sys.inputs { sys.inputs.at("total") } else { none },
    fields: fields,
    p: name => lib.get-field(definition: params, data: paramsData, name),
    params: paramsData,
  )

  #if vars.sys.sql-query in sys.inputs {
    sql.query((..args, engine: sys.inputs.at(vars.sys.sql-query), params: params))
    return
  }

  #set page(..layout)
  #metadata((
    name: meta.name,
    description: meta.description,
    tags: meta.tags,
    version: meta.version,
    multipage: meta.multipage,
    layout: layout,
    fields: fields,
    params: params,
    databases: sql.keys(),
  ))<meta>

  #if vars.sys.meta in sys.inputs {
    return
  }

  #if type(fieldData) == array [
    #for idx in range(0, fieldData.len()) [
      #body((
        ..args,
        index: idx,
        total: fieldData.len(),
        data: fieldData.at(idx),
        f: name => lib.get-field(definition: fields, data: fieldData.at(idx), name),
        p: name => lib.get-field(definition: params, data: paramsData, name),
      ))
    ]
  ] else [
    #body((
      ..args,
      data: fieldData,
      f: name => lib.get-field(definition: fields, data: fieldData, name),
    ))
  ]
]
