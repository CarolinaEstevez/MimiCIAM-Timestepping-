using Mimi 

@defcomp lslr_model begin
    segments = Index()
    nmodelt = Index()
	lslr_modeled = Variable(index =[time, segments], unit = "m")  #Local sea level rise  (m) model
    #--- Parameters to model lslr ---
    LWS = Parameter(index = [nmodelt], unit = "m") 
    GLAC = Parameter(index = [nmodelt], unit = "m")  
    GIS = Parameter(index = [nmodelt], unit = "m") 
    AIS = Parameter(index = [nmodelt], unit = "m")   
    TE = Parameter(index = [nmodelt], unit = "m")
   #--- Variables to normalize data ---
    LWS_val = Variable(index = [time], unit = "m") 
    GLAC_val = Variable(index = [time], unit = "m")  
    GIS_val = Variable(index = [time], unit = "m") 
    AIS_val = Variable(index = [time], unit = "m")   
    TE_val = Variable(index = [time], unit = "m")
    TimeNorm = Parameter(default = 1) #Time step index value to normalize the data with respect to 2000
    #--- Fingerprints ---
    fp = Parameter(index = [segments, 3]) #Fingerprints of AIS, GSIC, and GIS
    tmodel = Parameter(index = [time]) #Array of time indices that marks the time steps of the lslr model that correspond to MimiCIAM 

	function run_timestep(p, v, d, t)
         d_segments = d.segments::Vector{Int}
         println("M")
         #Normalize data
         t_model = Int(p.tmodel[t])
         v.LWS_val[t]=p.LWS[t_model].-p.LWS[Int(p.TimeNorm)]
         v.GLAC_val[t]=p.GLAC[t_model].-p.GLAC[Int(p.TimeNorm)]
         v.GIS_val[t]=p.GIS[t_model].-p.GIS[Int(p.TimeNorm)]
         v.AIS_val[t]=p.AIS[t_model].-p.AIS[Int(p.TimeNorm)]
         v.TE_val[t]=p.TE[t_model].-p.TE[Int(p.TimeNorm)]
         for m in d_segments
		     v.lslr_modeled[t, m] = v.LWS_val[t]+p.fp[m,3]*v.GLAC_val[t]+p.fp[m,3]*v.GIS_val[t]+p.fp[m,1]*v.AIS_val[t]+v.TE_val[t]
         end
	end
end