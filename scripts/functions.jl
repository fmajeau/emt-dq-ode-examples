function plot_sanity_check(system, results)

    # Get tspan
    tspan = (results.solution.t[1], results.solution.t[end])
    
    # Grab sample from the data
    sg  = PSID.get_state_series(results, ("generator-3-1", :δ))
    inv = PSID.get_state_series(results, ("generator-2-1", :θ_oc))

    # Zoom to sanity check time step granularity
    zoom = (.9, tspan[end] / 15)

    # Full view to see it is stable
    full = tspan

    # Plot data
    p = plot(layout=(2, 1), title=["$(system) Sanity Check" ""])
    plot!(p[1], sg,
        ylabel="rotor angle [rad]",
        label="sg (gen-3)",
        marker=:circle,
        color=:red,
        xlims=zoom,
        legend=:topright
        )
    plot!(twinx(p[1]), inv,
        ylabel="outer loop angle [rad]",
        label="inv (gen-2)",
        marker=:circle,
        color=:blue,
        xlims=zoom,
        legend=:bottomright
        )
    plot!(p[2], sg,
        ylabel="rotor angle [rad]",
        label="sg (gen-3)",
        color=:red,
        xlims=full,
        legend=:topright
        )
    plot!(twinx(p[2]), inv,
        ylabel="outer loop angle [rad]",
        label="inv (gen-2)",
        color=:blue,
        xlims=full,
        legend=:bottomright
        )

    #display(p)
    mkpath("../plots")
    savefig(p, "../plots/$(system)_sanity_check")
end

function get_solve_time(results)
    # NREL-Sienna/PowerSimulationsDynamics.jl/src/base/simulation.jl#L532
    return results.time_log[:timed_solve_time]
end
