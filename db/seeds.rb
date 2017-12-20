#bundle exec rake db:drop && bundle exec rake db:create && bundle exec rake db:migrate && bundle exec rake db:seed
comp = Company.create!(name: "LA GAITANA", nit: 8000000, phone: "1123456789")

la_gaitana = Farm.create!(code: "LG", name: "LA GAITANA", mamsl: 2600, pluviosity: 0.0, company_id: comp.id)
aurora = Farm.create!(code: "AR", name: "AURORA", mamsl: 2600, pluviosity: 0.0, company_id: comp.id)
['CLAVEL','MINICLAVEL'].each { |flower| Flower.create(name: flower)}

['MEDIO','FUERTE','DEBIL'].each { |strt| StorageResistanceType.create(name: strt) }

StorageResistance.import('db/seeds_data/storage_resistances.csv')
Color.import('db/seeds_data/colors.csv')
Variety.import('db/seeds_data/varieties.csv')
Submarket.import('db/seeds_data/submarkets.csv')
