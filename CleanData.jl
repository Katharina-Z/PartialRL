using CSV
using DataFrames
using DataFramesMeta
using Glob


data = CSV.read("/Users/katharinazuehlsdorff/PartialRL/Data/rr20/mergedrr0.csv", copycols=true, header=["Rat", "Reinf", "Trial", "CR", "CN", "Prem", "Omissions", "Incorrect", "RespLat", "CollLat"], datarow=1)

function clean(data)

    #=

    Possible actions:
    Nose poke to light & receive reward (NPR = 1)
    Nose pose to light, correct & no reward (NPNR = 2)
    Nose poke to light but incorrect, no reward (NPiNR = 3)
    Nose poke to light but premature, no reward (NPpNR)
    Omission (O = 5)
    =#

    #The value in the sequence will be 1 when
    data.Action = 0
    data[data[!, :CR] .== 1,:Action] .= Ref(1)
    data[data[!,:CN] .== 1,:Action] .= Ref(1)
    data[data[!, :Incorrect] .== 1,:Action] .= Ref(1)
    data[data[!, :Prem] .== 1,:Action] .= Ref(1)
    data[data[!, :Omissions] .== 1,:Action] .= Ref(2)



    #response latency for omisssion not included
    #if collection latency 0, interpret as NaN
    #exclude collection latencies for premature, omissions and incorrect


    data.Pr = 0
    for (i,v) in enumerate(data.Action)
        if v == 1 || v == 2
            data.Pr[i] = data.Reinf[i]
        #elseif v == 3
            #data.Pr[i] =
        end
    end


    data.Pr = data.Pr/100
    data.Reinf = data.Reinf/100
    data.RespLat = data.RespLat/1000
    data.CollLat = data.CollLat/1000
    data.Tau = data.RespLat + data.CollLat
    data.TauSum = data[:, :Tau]
    data.RewSum = data[:, :CR]
    return data
end

clean(data)



grouped = groupby(data, [:Rat])



for group in grouped

    for (i,v) in enumerate(group.RewSum)
        if i > 1
            group.RewSum[i] = group.RewSum[i] + group.RewSum[i-1]
        end
    end


    for (i,v) in enumerate(group.TauSum)
        if i > 1
            group.TauSum[i] = group.TauSum[i] + group.TauSum[i-1]
        end
    end

end

newdata = DataFrame(grouped)
