comp = Company.create!(name: "**Company*", nit: 8000000, phone: "1123456789")

la_gaitana = Farm.create!(code: "LG", name: "La Gaitana", mamsl: 0.0, pluviosity: 0.0, company_id: comp.id)
aurora = Farm.create!(code: "AU", name: "Aurora", mamsl: 0.0, pluviosity: 0.0, company_id: comp.id)
