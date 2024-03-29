using CSV
using Statistics
using PyPlot

Resp = CSV.read("/Users/katharinazuehlsdorff/PartialRL/Coll_rr100.csv", copycols=true)

grouped = groupby(Resp, [:Rat, :Action])

Qmean = Vector{Float64}()
Qvar = Vector{Float64}()
Urmean = Vector{Float64}()
Urvar = Vector{Float64}()
Cumean = Vector{Float64}()
Cuvar = Vector{Float64}()
Cvmean = Vector{Float64}()
Cvvar = Vector{Float64}()
Action = Vector{Float64}()
Rat = Vector{Float64}()
Action = Vector{Float64}()
for group in grouped
    append!(Qmean, mean(group.Q))
    append!(Qvar, std(group.Q))
    append!(Urmean, mean(group.Ur))
    append!(Urvar, std(group.Ur))
    append!(Cumean, mean(group.Cu))
    append!(Cuvar, std(group.Cu))
    append!(Cvmean, mean(group.Cv))
    append!(Cvvar, std(group.Cv))
    append!(Rat, mean(group.Rat))
    append!(Action, mean(group.Action))
end



Means = hcat(Rat, Action, Qmean, Qvar, Urmean, Urvar, Cumean, Cuvar, Cvmean, Cvvar)
Means = convert(DataFrame, Means)
colnames = ["Rat", "Action", "Qmean", "Qvar", "Urmean","Urvar", "Cumean", "Cuvar", "Cvmean", "Cvvar"]
names!(Means, Symbol.(colnames))


Rat10 = Means[(Means[:Rat] .==10),:]


#low compulsive groups
Means.Com= 0
for (i,v) in enumerate(Means.Rat)
    if v == 2 || v == 4 || v == 5 || v == 9 || v == 11 || v == 12
        Means.Com[i] = 1
    elseif v == 21 ||v == 23 || v == 19 || v == 18 || v == 16 || v == 14
        Means.Com[i] = 3
    else
        Means.Com[i] = 2
    end
end
CR = Means[in([1]).(Means.Action), :]


NR = Means[in([2]).(Means.Action), :]

IN = Means[in([3]).(Means.Action), :]

PREM = Means[in([4]).(Means.Action), :]

OM = Means[in([5]).(Means.Action), :]


CSV.write("CR_rr100.csv",CR)

CSV.write("NR_rr100.csv",NR)

CSV.write("Means_rr100.csv",Means)

CSV.write("IN_rr100.csv",IN)

CSV.write("OM_rr100.csv",OM)

CSV.write("PREM_rr100.csv",PREM)
