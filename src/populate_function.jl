function mapelites_step!(e::Evolution,
                             map_el::MapElites,
                             map_ind_to_b::Function;
                             mutation::Function=Cambrian.uniform_mutation,
                             crossover::Function=Cambrian.uniform_crossover,
                             evaluate::Function=Cambrian.random_evaluate)
    if (e.gen == 0)
        for i in eachindex(e.population)
            add_to_map(map_el,map_ind_to_b(e.population[i]),e.population[i],e.population[i].fitness)
        end
    end
    new_pop = Array{Individual}(undef,0)
    if e.cfg["n_elite"] > 0
        sort!(e.population)
        append!(new_pop,
                e.population[(length(e.population)-e.cfg["n_elite"]+1):end])
    end
    for i in (e.cfg["n_elite"]+1):e.cfg["n_population"]
        p1 = select_random(map_el)
        child = deepcopy(p1)
        if e.cfg["p_crossover"] > 0 && rand() < e.cfg["p_crossover"]
            parents = vcat(p1, select_random(map_el))
            child = crossover(parents...)
        end
        if e.cfg["m_rate"] > 0 && rand() < e.cfg["m_rate"]
            child = mutation(child)
        end
        push!(new_pop, child)
    end
    e.population = new_pop
    Cambrian.fitness_evaluate!(e;fitness=evaluate)
    for ind in e.population
        add_to_map(map_el,map_ind_to_b(ind),ind,ind.fitness)
    end
end
