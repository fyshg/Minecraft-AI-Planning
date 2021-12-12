
(define (problem make_turtle)
  (:domain minecraft)
  (:objects
  oak_wood - oak_wood
  oak_planks - oak_planks
  glass - glass
  glass_pane - glass_pane
  chest - chest
  computer - computer
  iron_ingot - iron_ingot
  iron_ore - iron_ore
  redstone - redstone
  sand - sand
  cobblestone - cobblestone
  stone - stone
  turtle - turtle
  coal - coal
  diamond - diamond
  mining_turtle - mining_turtle
  stick - stick
  diamond_pickaxe - diamond_pickaxe
  )

  (:init
  (= (count oak_planks) 0)
  (= (count oak_wood) 0)
  (= (count glass) 0)
  (= (count glass_pane) 0)
  (= (count chest) 0)
  (= (count computer) 0)
  (= (count iron_ingot) 0)
  (= (count iron_ore) 0)
  (= (count redstone) 0)
  (= (count sand) 0)
  (= (count cobblestone) 0)
  (= (count stone) 0)
  (= (count coal) 0)
  (= (count turtle) 0)
  (= (count diamond) 0)
  (= (count mining_turtle) 0)
  (= (count stick) 0)
  (= (count diamond_pickaxe) 0)

  (= (fuelvalue coal) 8)
  )

  (:goal
    (>= (count mining_turtle) 1)
	)
)
