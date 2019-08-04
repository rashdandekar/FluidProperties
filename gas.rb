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
        # a1 = 0.3265
        # a2 = -1.07
        # a3 = -0.5339
        # a4 = 0.01569
        # a5 = -0.05165
        # a6 = 0.5475
        # a7 = -0.7361
        # a8 = 0.1844
        # a9 = 0.1056
        # a10 = 0.6134
        # a11 = 0.721
      
        # epsilon = (120.0 * ((@h2s + @co2)**0.9 - (@h2s + @co2)**1.6)) 
        # epsilon += (15.0 * (@h2s**0.5 - @h2s**4))
        # ppc = 756.8 - (131.0 * @spgr) - (3.6 * @spgr * @spgr)
        # tpc = 169.2 + (349.5 * @spgr) - (74.0 * @spgr * @spgr)
        
        # tpc -= epsilon
        # ppc = ppc * tpc / (tpc + @h2s * (1 - @h2s) * epsilon)
        # ppr = press / ppc
        # tpr = (temp + 459.67) / tpc
        corr_sg=(@spgr-0.9672*@n2-1.5195*@co2-1.1765*@h2s)/(1-@n2-@co2-@h2s)
        tc_prime=168 + 325*corr_sg - 12.5*corr_sg**2
        pc_prime=677 + 15*corr_sg - 37.5*corr_sg**2
        tc_prime=(1.0-@n2-@co2-@h2s)*tc_prime + 227.3*@n2 + 547.6*@co2 + 672.4*@h2s
        pc_prime=(1.0-@n2-@co2-@h2s)*pc_prime + 493.0*@n2 + 1071.0*@co2 + 1306*@h2s
        corr_wa=120.0* ((@co2+@h2s)**0.9 - (@co2+@h2s)**1.6) + 15*(@h2s**0.5 - @h2s**4)
        #tc=tc_prime-corr_wa
        #pc=pc_prime*tc/(tc_prime+@h2s*(1-@h2s)*corr_wa)
        p_pr=press/(pc_prime*(tc_prime-corr_wa)/(tc_prime+@h2s*(1-@h2s)*corr_wa))
        t_pr=(temp+460)/(tc_prime-corr_wa)
        
        a=0.064225
        b=0.535308*t_pr - 0.612320
        c=0.315062*t_pr - 1.04671 - 0.578328/(t_pr**2)
        d=t_pr
        e=0.681570/(t_pr**2)
        f=0.684465
        g=0.27*p_pr
        rho=0.27*p_pr/t_pr
        rho_old=rho

        while true
            f_p=a*rho**6 + b*rho**3 + c*rho**2 + d*rho + e*(rho**3)*(1+f*rho**2)*Math.exp(-f*rho**2) -g
            df_p=6*a*rho**5 + 3*b*rho**2 + 2*c*rho +d + e*(rho**2)*(3+f*rho**2*(3-2*f*rho**2))*Math.exp(-f*rho**2)
            rho=(rho-f_p)/df_p
            if ((rho-rho_old)/rho)<0.00001
                break
            else
                rho_old=rho
            end
        end

        @gaszfactor=0.27*p_pr/(rho*t_pr)

    end
end


