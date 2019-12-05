require "./gas.rb"

myinputs = Hash.new
myinputs["name"] = "Dry Gas"
myinputs["spgr"] = 0.77603
myinputs["co2"] = 2.24
myinputs["h2s"] = 0.9

# myinputs.each do
#     |k,v|
#     print k
#     puts " " << v.to_s
# end

mygas = Gas.new(myinputs)
puts mygas.name
puts "Specific gravity is " << mygas.spgr.to_s
mygas.get_zfactor(4843, 206)
puts mygas.zfactor_g, mygas.b_g, mygas.rho_g