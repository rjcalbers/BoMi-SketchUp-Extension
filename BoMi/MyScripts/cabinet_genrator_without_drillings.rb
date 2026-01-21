# --- KAST GENERATOR (2026) - ZONDER BORINGEN ---
model = Sketchup.active_model
sel = model.selection


# 1. Standaardwaarden (in mm) dus geen inches
prompts = ["Hoogte (mm): ", "Breedte (mm): ", "Diepte (mm): ", "Dikte Hout (mm): ", "Dikte Achterwand (mm): "]
defaults = [1000.0, 600.0, 400.0, 18.0, 6.0]
input = UI.inputbox(prompts, defaults, "Stel de kastmaten in")

if input
  model.start_operation('Kast Zonder Boringen', true)
  
  # Verwijder oude selectie als die er is
  pos = Geom::Point3d.new(0,0,0)
  if !sel.empty?
    pos = sel[0].bounds.min
    sel.each { |e| e.erase! if e.valid? }
  end

  # Maten omzetten naar SketchUp units
  h, b, d, t, t_achter = input.map { |i| i.mm }
  
  # Hoofdgroep
  hoofd_groep = model.active_entities.add_group
  hoofd_groep.name = "Kast_Basis"
  k_ents = hoofd_groep.entities

  # Helperfunctie voor panelen
  def maak_paneel(target, x, y, z, br, di, ho, naam)
    grp = target.add_group
    f = grp.entities.add_face([0,0,0], [br,0,0], [br,di,0], [0,di,0])
    f.pushpull(-ho)
    grp.transform!(Geom::Transformation.translation([x, y, z]))
    c = grp.to_component
    c.definition.name = naam
    return c
  end

  # Bouw de kast (geen boringen meer)
  maak_paneel(k_ents, 0, 0, 0, t, d, h, "Zijwand_L")
  maak_paneel(k_ents, b - t, 0, 0, t, d, h, "Zijwand_R")
  maak_paneel(k_ents, t, 0, 0, b - (2*t), d, t, "Bodem")
  maak_paneel(k_ents, t, 0, h - t, b - (2*t), d, t, "Bovenkant")
  maak_paneel(k_ents, 0, d, 0, b, t_achter, h, "Achterwand")

  # Zet de nieuwe kast op de oude plek
  hoofd_groep.transform!(Geom::Transformation.translation(pos))
  hoofd_groep.to_component.definition.name = "Kast_Geconfigureerd"

  model.commit_operation
  puts "Kast gegenereerd zonder gatenpatroon."
end
