


#let convert = (value, typ) => {
  if typ == "int" {
    return int(value)
  }
  if typ == "str" {
    return str(value)
  }
  if typ == "float" {
    return float(value)
  }
  if typ == "bool" {
    return bool(value)
  }
  if typ == "date" {
    return datetime(
      year: value.split("-").at(0),
      month: value.split("-").at(1),
      day: value.split("-").at(2),
    )
  }
  if typ == "object" {
    return value
  }
  panic("Invalid type: " + str(typ))
}

#let get-field = (definition: (), data: (:), name) => {
  let field = definition.find(field => field.name == name)
  if name in data {
    return convert(data.at(name), field.type)
  }
  if definition.required {
    panic("Field " + str(name) + " is required")
  }
  panic("Field " + str(name) + " not found")
}

#let build-example = fields => {
  fields.map(field => (field.name, field.example)).to-dict()
}
