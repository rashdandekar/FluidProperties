require "./gas.rb"

myinputs = Hash.new
myinputs["name"] = "Dry Gas"
myinputs["spgr"] = 0.8

# myinputs.each do
#     |k,v|
#     print k
#     puts " " << v.to_s
# end

mygas = Gas.new(myinputs)
puts mygas.name
puts "Specific gravity is " << mygas.spgr.to_s
puts mygas.zfactor(1500, 100.00)