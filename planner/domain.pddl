
(define
    (domain minecraft)

    (:types item - object 
    wood - item 
    oak_wood - wood 
    planks - item
    oak_planks - planks
    glass - item
    glass_pane - item
    chest - item
    computer - item 
    iron_ingot - item
    iron_ore - item
    redstone - item
    sand - item
    cobblestone - item
    stone - item
    turtle - item
    fuel - item
    diamond - item
    mining_turtle - item
    stick - item
    diamond_pickaxe - item
    coal - fuel)

    (:predicates
        (furnace)
        (chests)
        (farming_wood)
        (mining)
        (farming_sand)
    )

    (:functions
        (fuelvalue ?f - fuel)
        (count ?i - item)
    )

    (:constraint positive_amounts
        :parameters(?i - item)
        :condition (>= (count ?i) 0)
    )


    (:process farm_wood
        :parameters (?w - wood)
        :precondition (farming_wood)
        :effect (increase (count ?w) (* #t 2))
    )

    (:process mine
        :parameters (?i - iron_ore 
            ?r - redstone
            ?c - cobblestone
            ?c2 - coal
            ?d - diamond)
        :precondition (mining)
        :effect 
            (and    
                (increase (count ?i) (* #t 2))
                (increase (count ?r) (* #t 2))
                (increase (count ?c) (* #t 2))
                (increase (count ?c2) (* #t 2))
                (increase (count ?d) (* #t 2))
            )
    )

    (:process farm_sand
        :parameters (?w - sand)
        :precondition (farming_wood)
        :effect (increase (count ?w) (* #t 2))
    )



    ;; ACTIONS TO CHANGE WHAT THE TURTLE IS CURRENTLY DOING ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


    (:action start_farming_wood
        :parameters ()
        :precondition (not (farming_wood))
        :effect (and (farming_wood)
                    (not (mining))
                    (not (farming_sand))
                )
    )

    (:action start_mining
        :parameters ()
        :precondition (not (mining))
        :effect (and (mining)
                    (not (farming_wood))
                    (not (farming_sand))
                )
    )

    (:action start_farming_sand
        :parameters ()
        :precondition (not (farming_sand))
        :effect (and (farming_sand)
                    (not (farming_wood))
                    (not (mining))
                )
    )




;;CRAFTING RECIPES;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


    (:action craft_oak_planks
        :parameters (   ?w - oak_wood 
                        ?p - oak_planks
                        )
        :precondition (>= (count ?w) 1)
        :effect (and 
                    (decrease (count ?w) 1)
                    (increase (count ?p) 4)
                )
    )

    (:action craft_chest
        :parameters (   ?i1 - planks
                        ?o - chest 
                        )
        :precondition (>= (count ?i1) 8)
        :effect (and 
                    (decrease (count ?i1) 8)
                    (increase (count ?o) 1)
                )
    )

    (:action craft_glass_pane
        :parameters (   ?i1 - glass
                        ?o - glass_pane 
                        )
        :precondition (>= (count ?i1) 6)
        :effect (and 
                    (decrease (count ?i1) 6)
                    (increase (count ?o) 16)
                )
    )

    (:action craft_computer
        :parameters (   ?i1 - stone
                        ?i2 - glass_pane
                        ?i3 - redstone
                        ?o - computer 
                        )
        :precondition (and 
                            (>= (count ?i1) 7)
                            (>= (count ?i2) 1)
                            (>= (count ?i3) 1)
                            )
        :effect (and 
                    (decrease (count ?i1) 7)
                    (decrease (count ?i2) 1)
                    (decrease (count ?i3) 1)
                    (increase (count ?o) 1)
                )
    )


    (:action craft_turtle
        :parameters (   ?i1 - iron_ingot
                        ?i2 - computer
                        ?i3 - chest
                        ?o - turtle 
                        )
        :precondition (and 
                            (>= (count ?i1) 7)
                            (>= (count ?i2) 1)
                            (>= (count ?i3) 1)
                            )
        :effect (and 
                    (decrease (count ?i1) 7)
                    (decrease (count ?i2) 1)
                    (decrease (count ?i3) 1)
                    (increase (count ?o) 1)
                )
    )



    (:action craft_mining_turtle
        :parameters (   ?i1 - turtle
                        ?i2 - diamond_pickaxe
                        ?o - mining_turtle 
                        )
        :precondition (and 
                            (>= (count ?i1) 1)
                            (>= (count ?i2) 1)
                            )
        :effect (and 
                    (decrease (count ?i1) 1)
                    (decrease (count ?i2) 1)
                    (increase (count ?o) 1)
                )
    )



    (:action craft_diamond_pickaxe
        :parameters (   ?i1 - diamond
                        ?i2 - stick
                        ?o - diamond_pickaxe 
                        )
        :precondition (and 
                            (>= (count ?i1) 3)
                            (>= (count ?i2) 2)
                            )
        :effect (and 
                    (decrease (count ?i1) 3)
                    (decrease (count ?i2) 2)
                    (increase (count ?o) 1)
                )
    )


    (:action craft_stick
        :parameters (   ?i1 - planks
                        ?o - stick 
                        )
        :precondition (and 
                            (>= (count ?i1) 2)
                            )
        :effect (and 
                    (decrease (count ?i1) 2)
                    (increase (count ?o) 4)
                )
    )





    ;;SMELTING RECIPES ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


    (:action smelt_iron
        :parameters (   ?i1 - iron_ore
                        ?i2 - fuel
                        ?o - iron_ingot 
                        )
        :precondition (and  (>= (count ?i1) (fuelvalue ?i2))
                            (>= (count ?i2) 1)
                        )
        :effect (and 
                    (decrease (count ?i1) (fuelvalue ?i2))
                    (decrease (count ?i2) 1)
                    (increase (count ?o) (fuelvalue ?i2))
                )
    )

    (:action smelt_glass
        :parameters (   ?i1 - sand
                        ?i2 - fuel
                        ?o - glass 
                        )
        :precondition (and  (>= (count ?i1) (fuelvalue ?i2))
                            (>= (count ?i2) 1)
                        )
        :effect (and 
                    (decrease (count ?i1) (fuelvalue ?i2))
                    (decrease (count ?i2) 1)
                    (increase (count ?o) (fuelvalue ?i2))
                )
    )


    (:action smelt_stone
        :parameters (   ?i1 - cobblestone
                        ?i2 - fuel
                        ?o - stone 
                        )
        :precondition (and  (>= (count ?i1) (fuelvalue ?i2))
                            (>= (count ?i2) 1)
                        )
        :effect (and 
                    (decrease (count ?i1) (fuelvalue ?i2))
                    (decrease (count ?i2) 1)
                    (increase (count ?o) (fuelvalue ?i2))
                )
    )
)
