grams_from_percent <- function(percent, flour){
  flour * percent / 100
}

calculate_ingredient_weight <- function(ingredient, percent, flour_weight, ingredients) {
  if (ingredient %in% ingredients) {
    grams_from_percent(percent, flour_weight)
  } else {
    0
  }
}
