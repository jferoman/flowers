comp = Company.create!(name: "LA GAITANA", nit: 8000000, phone: "1123456789")

la_gaitana = Farm.create!(code: "LG", name: "LA GAITANA", mamsl: 2600, pluviosity: 0.0, company_id: comp.id)
aurora = Farm.create!(code: "AR", name: "AURORA", mamsl: 2600, pluviosity: 0.0, company_id: comp.id)

['MEDIANA','FUERTE','DEBIL'].each { |strt| StorageResistanceType.create(name: strt)}
