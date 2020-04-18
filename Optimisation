using JuMP
using Ipopt
using CSV
using DataFrames

module CleanData
include("CleanData")
using .CleanData
export data
end


newdata = CleanData.newdata



function optimise(Lat, RewSum, Reinf, TauSum)

    V = Model(with_optimizer(Ipopt.Optimizer)) #could try out other optimiser

    @variable(V, 0.1 <= Ur<= 5)
    @variable(V, 0 <= Cu <= 1) #can also try constant
    @variable(V, 0.01 <= Cv <= 0.1) #in paper, it's 0.01

    @NLconstraint(V, -5 <= Reinf*Ur - Cu - (Cv/Lat) - (((RewSum-(Cu*TauSum))/TauSum)*Lat) <= 5)
    @NLobjective(V, Max, (Reinf*Ur) - Cu - (Cv/Lat) - (((RewSum-(Cu*TauSum))/TauSum)*Lat))

    JuMP.optimize!(V)

    V= JuMP.objective_value(V)
    Ur = JuMP.value.(Ur)
    Cu = JuMP.value.(Cu)
    Cv = JuMP.value.(Cv)
    return V , Ur, Cu, Cv
end


function optimise_response(data)
    V_R = Vector{Float64}()
    Ur_R = Vector{Float64}()
    Cu_R = Vector{Float64}()
    Cv_R = Vector{Float64}()
        for i in 1:size(data, 1)
            RespLat = data.RespLat[i]
            RewSum = data.RewSum[i]
            Reinf = data.Pr[i]
            TauSum = data.TauSum[i]
            V, Ur, Cu, Cv = optimise(RespLat, RewSum, Reinf, TauSum)
            append!(V_R, V)
            append!(Ur_R, Ur)
            append!(Cv_R, Cv)
            append!(Cu_R, Cu)
        end
    return V_R, Ur_R, Cu_R, Cv_R
end


V_R, Ur_R, Cu_R, Cv_R = optimise_response(data)



# function optimise_collection(data)
#     V_C = Vector{Float64}()
#     Ur_C = Vector{Float64}()
#     Cu_C = Vector{Float64}()
#     Cv_C = Vector{Float64}()
#         for i in 1:size(data, 1)
#             CollLat = data.CollLat[i]
#             RewSum = data.RewSum[i]
#             Reinf = data.CR[i]
#             TauSum = data.TauSum[i]
#             V, Ur, Cu, Cv = optimise(CollLat, RewSum, Reinf, TauSum)
#             append!(V_C, V)
#             append!(Ur_C, Ur)
#             append!(Cu_C, Cu)
#             append!(Cv_C, Cv)
#         end
#     return V_C, Ur_C, Cu_C, Cv_C
# end
#
#
# V_C, Ur_C, Cu_C, Cv_C = optimise_collection(data)





Resp = hcat(data.Rat, data.Reinf, data.CR, data.Trial, data.Action, V_R, Ur_R, Cu_R, Cv_R)
Resp = convert(DataFrame, Resp)
colnames = ["Rat", "Reinf", "Reward", "Trial", "Action","V", "Ur", "Cu", "Cv"]
names!(Resp, Symbol.(colnames))



# Coll = hcat(data.Rat, data.Reinf, data.CR, data.Trial, data.Action, V_C, Ur_C, Cu_C, Cv_C)
# Coll = convert(DataFrame, Coll)
# colnames = ["Rat", "Reinf", "Reward", "Trial", "Action","V", "Ur", "Cu", "Cv"]
# names!(Coll, Symbol.(colnames))




CSV.write("RR0/Resp_rr0.csv",Resp)
# CSV.write("RR80/Coll_rr80.csv",Coll)
