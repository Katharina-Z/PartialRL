using CSV
using Statistics
using Distributions

Resp = CSV.read("/Users/katharinazuehlsdorff/PartialRL/RR20/Resp_rr20.csv", copycols=true)


grouped = groupby(Resp, [:Rat, :Action])

V = Vector{Float64}()
Ur = Vector{Float64}()
Cu = Vector{Float64}()
Cv = Vector{Float64}()
Action = Vector{Float64}()
Rat = Vector{Float64}()
Action = Vector{Float64}()
for group in grouped
    append!(V, mean(group.V))
    append!(Ur, mean(group.Ur))
    append!(Cu, mean(group.Cu))
    append!(Cv, mean(group.Cv))
    append!(Rat, mean(group.Rat))
    append!(Action, mean(group.Action))
end



Means = hcat(Rat, Action, V, Ur, Cu, Cv)
Means = convert(DataFrame, Means)
colnames = ["Rat", "Action", "V", "Ur", "Cu", "Cv"]
rename!(Means, Symbol.(colnames))




#compulsivity subgroups
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

Go = Means[in([1]).(Means.Action), :]


Other = Means[in([2]).(Means.Action), :]


CSV.write("RR20/Go_rr20_resp.csv", Go)

#CSV.write("RR80/Other_rr80_resp.csv", Other)



#
# Coll = CSV.read("/Users/katharinazuehlsdorff/PartialRL/RR80/Coll_rr80.csv", copycols=true)
#
#
# grouped = groupby(Coll, [:Rat, :Action])
#
# V = Vector{Float64}()
# Ur = Vector{Float64}()
# Cu = Vector{Float64}()
# Cv = Vector{Float64}()
# Action = Vector{Float64}()
# Rat = Vector{Float64}()
# Action = Vector{Float64}()
# for group in grouped
#     append!(V, mean(group.V))
#     append!(Ur, mean(group.Ur))
#     append!(Cu, mean(group.Cu))
#     append!(Cv, mean(group.Cv))
#     append!(Rat, mean(group.Rat))
#     append!(Action, mean(group.Action))
# end
#
#
#
# Means = hcat(Rat, Action, V, Ur, Cu, Cv)
# Means = convert(DataFrame, Means)
# colnames = ["Rat", "Action", "V", "Ur", "Cu", "Cv"]
# rename!(Means, Symbol.(colnames))
#
#
#
#
# #compulsivity subgroups
# Means.Com= 0
# for (i,v) in enumerate(Means.Rat)
#     if v == 2 || v == 4 || v == 5 || v == 9 || v == 11 || v == 12
#         Means.Com[i] = 1
#     elseif v == 21 ||v == 23 || v == 19 || v == 18 || v == 16 || v == 14
#         Means.Com[i] = 3
#     else
#         Means.Com[i] = 2
#     end
# end
#
# Go = Means[in([1]).(Means.Action), :]
#
#
# Other = Means[in([2]).(Means.Action), :]
#
#
# CSV.write("RR80/Go_rr80_coll.csv", Go)
#
# CSV.write("RR80/Other_rr80_coll.csv", Other)
