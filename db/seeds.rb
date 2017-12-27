#bundle exec rake db:drop && bundle exec rake db:create && bundle exec rake db:migrate && bundle exec rake db:seed
comp = Company.create!(name: "LA GAITANA", nit: 8000000, phone: "1123456789")

la_gaitana = Farm.create!(code: "LG", name: "LA GAITANA", mamsl: 2600, pluviosity: 0.0, company_id: comp.id)
aurora = Farm.create!(code: "AR", name: "AURORA", mamsl: 2600, pluviosity: 0.0, company_id: comp.id)
['CLAVEL','MINICLAVEL'].each { |flower| Flower.create(name: flower)}

['MEDIO','FUERTE','DEBIL'].each { |strt| StorageResistanceType.create(name: strt) }

StorageResistance.import('db/seeds_data/storage_resistances.csv')
Color.import('db/seeds_data/colors.csv')
Variety.import('db/seeds_data/varieties.csv')


Market.create(name: "United Kingdom", code: "UK", company_id: comp.id)
Market.create(name: "Europuean Union ", code: "EU", company_id: comp.id)
Market.create(name: "United States", code: "US", company_id: comp.id)
Market.create(name: "Rusia", code: "RU", company_id: comp.id)
Market.create(name: "Japan", code: "JA", company_id: comp.id)

Block.import('db/seeds_data/blocks.csv')
BedType.create(name: "ANGOSTA", width: 50)
BedType.create(name: "ANCHA", width: 64)
Bed.import('db/seeds_data/beds.csv')
Coldroom.create( name: "Cuarto-001", capacity: 1000, farm_id: 1)
Coldroom.create( name: "Cuarto-002", capacity: 1000, farm_id: 1)
FlowerDensity.create( density: 30, farm_id: 1, flower_id: 1)
FlowerDensity.create( density: 30, farm_id: 1, flower_id: 2)
Week.import('db/seeds_data/weeks.csv')
Cutting.import('db/seeds_data/cuttings.csv')

