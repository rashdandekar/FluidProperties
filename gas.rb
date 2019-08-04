class Gas
    attr_reader :name, :spgr, :co2, :h2s, :n2, :gaszfactor
    
    # def initialize(name)
    #     @name=name
    # end
    def initialize(inputhash)
        inputhash.each {
            |k , v|
            case k
                when "name" then @name = v
                when "spgr" then @spgr = v
                when "co2" then @co2 = v/100.0
                when "h2s" then @h2s = v/100.0
                when "n2" then @n2 = v/100.0
            end
            if @co2.nil? then
                @co2 = 0.0
            end
            if @h2s.nil? then
                @h2s = 0.0
            end
            if @n2.nil? then
                @n2=0.0
            end

        }
    end

    def zfactor(press, temp)
        a1 = 0.3265
        a2 = -1.07
        a3 = -0.5339
        a4 = 0.01569
        a5 = -0.05165
        a6 = 0.5475
        a7 = -0.7361
        a8 = 0.1844
        a9 = 0.1056
        a10 = 0.6134
        a11 = 0.721
      
        epsilon = (120.0 * ((@h2s + @co2)**0.9 - (@h2s + @co2)**1.6)) 
        epsilon += (15.0 * (@h2s**0.5 - @h2s**4))
        ppc = 756.8 - (131.0 * @spgr) - (3.6 * @spgr * @spgr)
        tpc = 169.2 + (349.5 * @spgr) - (74.0 * @spgr * @spgr)
        
        tpc -= epsilon
        ppc = ppc * tpc / (tpc + @h2s * (1 - @h2s) * epsilon)
        ppr = press / ppc
        tpr = (temp + 459.67) / tpc
    end
end


