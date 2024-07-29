using Mimi 

@defcomp lslr_model begin
    segments = Index()
    nmodelt = Index()
	lslr_modeled = Variable(index =[nmodelt, segments], unit = "m")  #Local sea level rise  (m) model
    #--- Parameters to model lslr ---
    LWS = Parameter(index = [nmodelt], unit = "m") 
    GLAC = Parameter(index = [nmodelt], unit = "m")  
    GIS = Parameter(index = [nmodelt], unit = "m") 
    AIS = Parameter(index = [nmodelt], unit = "m")   
    TE = Parameter(index = [nmodelt], unit = "m")
   #--- Variables to normalize data ---
    LWS_val = Variable(index = [nmodelt], unit = "m") 
    GLAC_val = Variable(index = [nmodelt], unit = "m")  
    GIS_val = Variable(index = [nmodelt], unit = "m") 
    AIS_val = Variable(index = [nmodelt], unit = "m")   
    TE_val = Variable(index = [nmodelt], unit = "m")
    TimeNorm = Parameter(default = 1) #Time step index value to normalize the data with respect to 2000
    #--- Fingerprints ---
    fp = Parameter(index = [segments, 3]) #Fingerprints of AIS, GSIC, and GIS

	function run_timestep(p, v, d, t)
         d_segments = d.segments::Vector{Int}
         d_n_time = d.nmodelt::Vector{Int}
         #Normalize data
         v.LWS_val[:]=p.LWS[:].-p.LWS[Int(p.TimeNorm)]
         v.GLAC_val[:]=p.GLAC[:].-p.GLAC[Int(p.TimeNorm)]
         v.GIS_val[:]=p.GIS[:].-p.GIS[Int(p.TimeNorm)]
         v.AIS_val[:]=p.AIS[:].-p.AIS[Int(p.TimeNorm)]
         v.TE_val[:]=p.TE[:].-p.TE[Int(p.TimeNorm)]
         for m in d_segments
             for n in d_n_time
		         v.lslr_modeled[n, m] = v.LWS_val[n]+p.fp[m,3]*v.GLAC_val[n]+p.fp[m,3]*v.GIS_val[n]+p.fp[m,1]*v.AIS_val[n]+v.TE_val[n]
             end 
         end
	end
end